classdef (Abstract) MixedTypeSet < matlab.mixin.indexing.RedefinesParen & ...
        matlab.mixin.indexing.RedefinesDot & ...
        matlab.mixin.CustomDisplay & matlab.mixin.CustomCompactDisplayProvider
% MixedTypeSet - Holds the instances of a property that allows several types
%
%   One object holds the whole list, and indexing it hands out the instances
%   themselves: set(2) is the second instance, set(:) is an array of them
%   when they share a type and a set of them otherwise, and set.name is the
%   comma-separated list of their name properties. Assigning through the set
%   reaches the instances too, and set(end+1) = instance appends any type the
%   property allows. A property declared with a subclass of this class thus
%   reads and writes like an array of its instances. The set itself shows
%   only in class(set).
%
%   Properties:
%       Instances     - Hidden. The instances held, as a cell array
%       ALLOWED_TYPES - Constant. The types the property accepts
%       IS_SCALAR     - Constant. Whether the property holds a single value
%
%   Use openminds.utility.isMixedInstance to test whether a value is one of
%   these. The concrete subclasses are generated per property and are an
%   implementation detail; do not name them.
%
%   See also openminds.utility.isMixedInstance, openminds.introspection.MetaType

% Many properties of openMINDS metadata types can hold linked or embedded
% instances of different types, and MATLAB cannot put objects of different
% classes in one array. This class is the container that stands in for such
% an array. For each property that allows several types, the build pipeline
% generates a subclass naming the allowed types, and the generated type
% class declares the property with that subclass.

% Developer notes:
%
% The container is a value class holding the instances in a cell. Indexing
% is redefined, so that what comes out of the container is an instance and
% never the container, unless the selection mixes types. MATLAB cannot
% synthesize a (1,:) default for a class that redefines paren indexing, so a
% generated declaration carries an explicit empty set as its default, and
% each generated subclass defines the static empty that RedefinesParen
% requires, since a static method in this abstract class cannot know which
% subclass was asked for.
%
% matlab.mixin.Heterogeneous on openminds.Node would make the container
% unnecessary, but it switches off constructor conversion for the whole
% hierarchy, and with it the string shorthand for controlled terms. See
% issue 105.
%
% This class is internal and should not be exposed to users.

% TODO:
%  - [ ] Consider if we need to define intersect, union etc.

    properties (Abstract, Constant)
        % Allowed types for a specific MixedTypeSet instance
        ALLOWED_TYPES
        % Whether a specific MixedTypeSet subclass should be "scalar".
        IS_SCALAR
    end

    properties (SetAccess = private, Hidden)
        % Instances - The instances held, in order. Each is an openMINDS
        % instance of an allowed type, or a MixedTypeReference standing in
        % for one that has not been resolved.
        Instances (1,:) cell = cell(1, 0)
    end

    methods
        function obj = MixedTypeSet(sourceValue)
        % MixedTypeSet - Create a set from anything the property accepts
        %
        %   Accepted values, alone, in an array or in a cell array:
        %     - an openMINDS instance of an allowed type
        %     - a MixedTypeReference for an instance not yet resolved
        %     - a struct with an @id, which becomes such a reference, or
        %       with an @type, which becomes an embedded instance
        %     - a controlled term name or instance IRI, as text
        %     - another set, whose instances are taken over
        %
        %   The flexibility is what lets a user assign an instance or a
        %   term name to a property directly. MATLAB passes the value to
        %   this constructor to convert it to the property's class.

            if nargin == 0
                return
            end
            obj.Instances = obj.toInstances(sourceValue);
        end
    end

    methods % Array behaviour
        function varargout = size(obj, varargin)
            [varargout{1:nargout}] = size(obj.Instances, varargin{:});
        end

        function obj = cat(~, varargin)
        % cat - Concatenate sets and instances into one set
        %
        %   The first set among the operands decides the class, and every
        %   operand is validated against its allowed types.

            isSet = cellfun(@(v) isa(v, 'openminds.base.MixedTypeSet'), varargin);
            obj = varargin{find(isSet, 1)};
            parts = cellfun(@(v) obj.toInstances(v), varargin, 'UniformOutput', false);
            obj.Instances = [parts{:}];
        end
    end

    methods % Instance access
        function cellArrayOfStruct = toStruct(obj)
            cellArrayOfStruct = cellfun(@(instance) instance.toStruct(), ...
                obj.Instances, 'UniformOutput', false);
        end

        function tf = isReference(obj)
        % isReference - Whether each held instance stands for a node
            tf = cellfun(@(instance) instance.isReference(), obj.Instances);
        end

        function instances = resolve(obj, options)
        % resolve - The held instances with references resolved
        %
        %   Returns a cell array of instances. The set is a value, so the
        %   property it came from is not updated; resolve the owning node
        %   to replace references in place.

            arguments
                obj openminds.base.MixedTypeSet
                options.NumLinksToResolve = 0
            end
            instances = obj.Instances;
            for i = 1:numel(instances)
                if isa(instances{i}, 'openminds.internal.MixedTypeReference')
                    instances{i} = instances{i}.resolve("NumLinksToResolve", options.NumLinksToResolve);
                else
                    instances{i}.resolve("NumLinksToResolve", options.NumLinksToResolve)
                end
            end
        end

        function [lia, locb] = ismember(obj, B)
        % ismember - Whether each held instance is among the instances of B
        %
        %   B is a set or an instance array. Membership is by instance
        %   equality, as isequal defines it.

            if isa(B, 'openminds.base.MixedTypeSet')
                candidates = B.Instances;
            else
                candidates = num2cell(B);
            end
            lia = false(1, numel(obj.Instances));
            locb = zeros(1, numel(obj.Instances));
            for i = 1:numel(obj.Instances)
                for j = 1:numel(candidates)
                    if isequal(obj.Instances{i}, candidates{j})
                        lia(i) = true;
                        locb(i) = j;
                        break
                    end
                end
            end
        end

        function tf = isequal(obj, other)
        % isequal - Whether two sets hold equal instances, or a set of one
        % holds an instance equal to other

            if isa(other, 'openminds.base.MixedTypeSet')
                tf = strcmp(class(obj), class(other)) ...
                    && isequal(obj.Instances, other.Instances);
            elseif isscalar(obj.Instances)
                tf = isequal(obj.Instances{1}, other);
            else
                tf = false;
            end
        end

        function cellArray = cellstr(obj)
            cellArray = cellfun(@(instance) char(instance), obj.Instances, 'UniformOutput', false);
        end

        function stringArray = string(obj)
            stringArray = string(obj.cellstr());
        end

        function str = char(obj)
            str = char(strjoin(obj.string(), '; '));
        end

        function propertyIRI = getPropertyIRI(obj)
        % getPropertyIRI - IRI of the openMINDS property this set of types belongs to

            import openminds.internal.utility.string.packageParts

            iriPrefix = openminds.constant.PropertyIRIPrefix();
            assert(isa(iriPrefix,'string'), 'Internal error: Expected string')

            [~, shortName] = packageParts(class(obj));
            shortName = openminds.internal.utility.string.camelCase(shortName);
            propertyIRI = iriPrefix + shortName;
        end
    end

    methods (Access = protected) % Paren indexing hands out instances
        function varargout = parenReference(obj, indexOp)
            selected = obj.Instances.(indexOp(1));
            value = obj.handOut(selected);
            if isscalar(indexOp)
                varargout{1} = value;
            else
                [varargout{1:nargout}] = value.(indexOp(2:end));
            end
        end

        function obj = parenAssign(obj, indexOp, varargin)
            if isscalar(indexOp)
                obj.Instances.(indexOp) = obj.toInstances(varargin{:});
                if any(cellfun(@isempty, obj.Instances))
                    error('openMINDS:MixedTypeSet:GapInList', ...
                        ['Assigning past the end of a list of %d instances ', ...
                        'would leave a gap. Assign the next position or use end+1.'], ...
                        numel(obj.Instances))
                end
            else
                % Assignment through one instance, such as list(2).name = x.
                % Instances are handles, so this reaches the instance the
                % property holds.
                target = obj.handOut(obj.Instances.(indexOp(1)));
                target.(indexOp(2:end)) = varargin{:};
            end
        end

        function obj = parenDelete(obj, indexOp)
            obj.Instances.(indexOp) = [];
        end

        function n = parenListLength(obj, indexOp, indexContext)
            if isscalar(indexOp)
                n = 1;
            else
                value = obj.handOut(obj.Instances.(indexOp(1)));
                n = listLength(value, indexOp(2:end), indexContext);
            end
        end
    end

    methods (Access = protected) % Dot indexing forwards to the instances
        function varargout = dotReference(obj, indexOp)
            if isscalar(obj.Instances)
                [varargout{1:nargout}] = obj.Instances{1}.(indexOp);
            else
                % A list yields one value per instance, as an array does.
                % Indexing deeper into each of them is refused, as MATLAB
                % refuses it for arrays.
                if ~isscalar(indexOp)
                    error('openMINDS:MixedTypeSet:IndexingIntoList', ...
                        ['Indexing into a list of %d instances is not ', ...
                        'supported. Index one instance at a time.'], numel(obj.Instances))
                end
                varargout = cellfun(@(instance) instance.(indexOp), ...
                    obj.Instances, 'UniformOutput', false);
            end
        end

        function obj = dotAssign(obj, indexOp, varargin)
            if ~isscalar(obj.Instances)
                error('openMINDS:MixedTypeSet:AssigningIntoList', ...
                    ['Assigning through a list of %d instances is not ', ...
                    'supported. Index one instance at a time.'], numel(obj.Instances))
            end
            obj.Instances{1}.(indexOp) = varargin{:};
        end

        function n = dotListLength(obj, indexOp, indexContext)
            if isscalar(obj.Instances)
                n = listLength(obj.Instances{1}, indexOp, indexContext);
            else
                n = numel(obj.Instances);
            end
        end
    end

    methods (Access = private) % Conversion helpers
        function instances = toInstances(obj, sourceValue)
        % toInstances - Any accepted value as a cell array of instances
        %
        %   Each element is validated against the allowed types.

            if isempty(sourceValue)
                instances = cell(1, 0);
                return
            end

            if isa(sourceValue, 'openminds.base.MixedTypeSet')
                sourceValue = sourceValue.Instances;
            elseif ischar(sourceValue)
                sourceValue = string(sourceValue);
            end

            if ~iscell(sourceValue)
                sourceValue = num2cell(sourceValue);
            end

            % A cell may hold arrays or other sets; flatten to one instance
            % per element before validating.
            isNested = cellfun(@(v) iscell(v) || numel(v) > 1 ...
                || isa(v, 'openminds.base.MixedTypeSet'), sourceValue);
            if any(isNested)
                parts = cellfun(@(v) obj.toInstances(v), sourceValue, 'UniformOutput', false);
                instances = [parts{:}];
                return
            end

            instances = cell(1, numel(sourceValue));
            for i = 1:numel(sourceValue)
                value = sourceValue{i};
                if isstring(value)
                    value = obj.preprocessFromString(value);
                end

                if isstruct(value) % Reference or embedded instance
                    instances{i} = obj.initializeFromStructure(value);
                elseif isa(value, 'openminds.internal.MixedTypeReference')
                    instances{i} = value;
                else
                    mustBeOneOf(value, obj.ALLOWED_TYPES)
                    instances{i} = value;
                end
            end
        end

        function value = handOut(obj, instances)
        % handOut - Instances as an array of their type, or as a set when
        % they are of different types or there are none

            if ~isempty(instances) && openminds.base.MixedTypeSet.isHomogeneous(instances)
                value = [instances{:}];
            else
                value = obj;
                value.Instances = instances;
            end
        end

        function instance = preprocessFromString(obj, stringValue)
        % preprocessFromString - Try to initialize an openMINDS instance
        % from a controlled term name or IRI

        % Note: If only a controlled term name is given, this function stops at
        % the first match. If multiple controlled term types contain instances
        % with the same name, the result may be unintended.

            instance = [];

            if openminds.utility.isInstanceIRI(stringValue)
                [typeEnum, ~] = openminds.utility.parseInstanceIRI(stringValue);
                mustBeOneOf(typeEnum.ClassName, obj.ALLOWED_TYPES)
                instance = openminds.instanceFromIRI(stringValue);
            else
                % Check if we can create a controlled instance from it
                for type = obj.ALLOWED_TYPES
                    % Todo: Learn from ControlledTerm constructor, trying
                    % more variations of stringValue
                    if contains(type, 'openminds.controlledterms')
                        allInstanceNames = eval(sprintf('%s.CONTROLLED_INSTANCES', type));
                        if contains(stringValue, " ")
                            stringValue = strrep(stringValue, ' ', '');
                        end
                        isMatch = strcmpi(stringValue, allInstanceNames);

                        if any( isMatch )
                            instance = feval(type, stringValue);
                            break
                        end
                    end
                end
            end

            % Could not create instance from string: return original string
            if isempty(instance)
                instance = stringValue;
            end
        end

        function instance = initializeFromStructure(obj, structure)
        % initializeFromStructure - Initialize an instance from a structure
            arguments
                obj
                structure (1,1) struct
            end

            if isfield(structure, 'at_id') % Linked instance
                % Support initializing an Instance from a struct with
                % an @id. This will act as a placeholder for an
                % unresolved linked instance, and the link needs to be
                % resolved externally in order to put a real instance in place.
                instance = openminds.internal.MixedTypeReference(structure.at_id);

            elseif isfield(structure, 'x_id') % Linked instance
                % Variation of above
                instance = openminds.internal.MixedTypeReference(structure.x_id);

            elseif isfield(structure, 'at_type') % Embedded instance
                instance = openminds.fromTypeName(structure.at_type);
                instance = instance.fromStruct(structure);
            else
                error('openminds:MixedTypeSet:UnsupportedStructure', ...
                    ['Cannot create an instance from a structure with the fields [%s]. ', ...
                    'A linked instance needs an "at_id" (or "x_id") field, and an embedded ', ...
                    'instance needs an "at_type" field naming one of: %s.'], ...
                    strjoin(fieldnames(structure), ', '), strjoin(obj.ALLOWED_TYPES, ', '))
            end
        end
    end

    methods (Static, Access = private)
        function tf = isHomogeneous(instances)
            classNames = cellfun(@class, instances, 'UniformOutput', false);
            tf = isscalar(unique(classNames));
        end
    end

    methods (Hidden, Access = protected) % Override CustomDisplay methods
        function str = getHeader(obj)
            import openminds.internal.utility.getTypeDocLink
            docLinkStr = getTypeDocLink(class(obj));

            % Todo: Consider indicating that the array has mixed types,
            % i.e is heterogeneous-like...
            docLinkStr = sprintf('1x%d %s', numel(obj.Instances), docLinkStr);
            if isempty(obj.Instances)
                str = sprintf('  %s array\n', docLinkStr);
            else
                str = sprintf('  %s array with elements:\n', docLinkStr);
            end
        end

        function str = getFooter(~)
            str = '';
        end

        function displayEmptyObject(obj)
            str = obj.getHeader;
            if strcmp(str(end-1), ':')
                str(end-1) = [];
            end
            disp(str)
        end

        function displayScalarObject(obj)
            % A set of one instance. Show the instance it holds.
            disp(obj.Instances{1})
        end

        function displayNonScalarObject(obj)
            if any(obj.isReference())
                stringArray = strjoin(cellfun(@(instance) instance.id, ...
                    obj.Instances, 'UniformOutput', false), newline);
            else
                repArray = cellfun(@(instance) instance.compactRepresentationForSingleLine, ...
                    obj.Instances, 'UniformOutput', false);
                stringArray = cellfun(@(r) "    "+ r.PaddedDisplayOutput, repArray);
                stringArray = strrep(stringArray, '[', '');
                stringArray = strrep(stringArray, ']', '');
            end

            str = obj.getHeader;
            disp(str)
            if iscell(stringArray) || isstring(stringArray)
                fprintf( '%s\n\n', strjoin(stringArray, '    \n') );
            else
                fprintf( '%s\n\n', stringArray)
            end
        end
    end

    methods (Hidden) % CustomCompactDisplayProvider - Method implementation
        function rep = compactRepresentationForSingleLine(obj, displayConfiguration, width)
        % The representation of a property value in the display of the
        % node that owns it. Mirrors what openminds.Node does for an array
        % of instances, so a mixed property reads like any other.

            if nargin < 2
                displayConfiguration = matlab.display.DisplayConfiguration();
            end
            if nargin < 3
                width = inf;
            end

            numInstances = numel(obj.Instances);

            if numInstances == 0
                str = 'None';
                annotation = plainWhenHotlinksOff(obj.getAnnotation(width));
                rep = matlab.display.PlainTextRepresentation(...
                    obj, str, displayConfiguration, 'Annotation', annotation);

            elseif numInstances == 1
                label = string(obj.Instances{1});
                % Create a representation without annotation to learn its width
                rep = fullDataRepresentation(obj, displayConfiguration, ...
                    'StringArray', label);

                widthForAnnotation = width - rep.CharacterWidth - 3; % 3 = annotation padding " ()"
                annotation = plainWhenHotlinksOff(obj.getAnnotation(widthForAnnotation));

                rep = fullDataRepresentation(obj, displayConfiguration, ...
                    'StringArray', label, 'Annotation', annotation);
            else
                stringArray = obj.getStringArrayForSingleLine(displayConfiguration, width);
                annotation = plainWhenHotlinksOff(obj.getAnnotation(width));

                rep = fullDataRepresentation(obj, displayConfiguration, ...
                    'StringArray', stringArray, 'Annotation', annotation);

                defaultRep = compactRepresentationForSingleLine@matlab.mixin.CustomCompactDisplayProvider(obj, displayConfiguration, width);
                sizeTypeStr = defaultRep.PaddedDisplayOutput;
                sizeTypeStr = strrep(sizeTypeStr, '[', '(');
                sizeTypeStr = strrep(sizeTypeStr, ']', ')');

                % Iterate to find a string that fits within the display
                count = 1;
                while rep.CharacterWidth > width
                    tempStringArray = stringArray(1:end-count);
                    if isempty(tempStringArray)
                        break
                    end

                    tempStringArray(end) = tempStringArray(end) + "... " + sizeTypeStr;
                    rep = fullDataRepresentation(obj, displayConfiguration, ...
                        'StringArray', tempStringArray, 'Annotation', annotation);
                    count = count + 1;
                end
            end
        end

        function rep = compactRepresentationForColumn(obj, displayConfiguration, ~)
            if nargin < 2
                displayConfiguration = matlab.display.DisplayConfiguration();
            end
            if isempty(obj.Instances)
                str = 'None';
            else
                str = char(obj);
            end
            rep = matlab.display.PlainTextRepresentation(obj, str, displayConfiguration);
        end
    end

    methods (Access = protected) % Utility methods for compact display
        function stringArray = getStringArrayForSingleLine(obj, displayConfiguration, width)
            repArray = cellfun(@(instance) instance.compactRepresentationForSingleLine(displayConfiguration, width), ...
                obj.Instances, 'UniformOutput', false);
            stringArray = cellfun(@(r) r.PaddedDisplayOutput, repArray);
            stringArray = strrep(stringArray, '[', '');
            stringArray = strrep(stringArray, ']', '');
        end
    end

    methods (Access = protected) % Get annotations
        function annotation = getAnnotation(obj, width)
            if nargin < 2; width = inf; end

            if isempty(obj.Instances)
                annotation = obj.getAnnotationForEmptyObject(width);

            elseif isscalar(obj.Instances)
                if isa(obj.Instances{1}, "openminds.internal.MixedTypeReference")
                    annotation = obj.getAnnotationForEmptyObject(width);
                else
                    annotation = obj.getAnnotationForScalarObject(width);
                end
            else
                annotation = obj.getAnnotationForNonScalarObject(width);
            end
        end

        function annotation = getAnnotationForEmptyObject(obj, width)
            import openminds.internal.utility.getTypeDocLink
            if obj.IS_SCALAR
                prefix = 'One of';
            else
                prefix = 'Any of';
            end

            availableWidth = width - strlength(prefix) - 2; % 2 = ": "

            allAllowedClasses = obj.ALLOWED_TYPES;
            allowedClassesShort = openminds.internal.utility.getTypeName(allAllowedClasses);

            annotationWidth = arrayfun(@(x) strlength(x) + 2, allowedClassesShort); % +2 = ", "
            cumWidth = cumsum(annotationWidth);

            postFix = '';
            if any(cumWidth > availableWidth) % Truncate annotation
                availableWidth = availableWidth - 10;
                availableWidth = availableWidth - 4; % 4 = " ..." (postfix)
                idx = find(cumWidth > availableWidth, 1, 'first') - 1;
                allowedClasses = allAllowedClasses(1:idx);

                allAllowedClassesStr = strjoin(allAllowedClasses, ',');

                classNameSplit = strsplit(class(obj), '.');
                classShortName = classNameSplit{end};
                postFix = sprintf(...
                    [' <a href="matlab:openminds.internal.display.printTypeLinks(', ...
                    '''%s'', ''prefix'', ''%s'', ''Delimiter'', ''\\n  '')" ', ...
                    'style="font-weight:bold">...</a>'], ...
                    allAllowedClassesStr, ...
                    sprintf('Types for %s can be %s:', classShortName, lower(prefix)));
            else
                allowedClasses = allAllowedClasses;
            end

            annotation = arrayfun(@(s) getTypeDocLink(s), allowedClasses, 'UniformOutput', false);
            annotation = strjoin(annotation, ', ');

            annotation = sprintf('%s: %s%s', prefix, annotation, postFix);
        end

        function annotation = getAnnotationForScalarObject(obj, ~)
            import openminds.internal.utility.getTypeDocLink
            annotation = getTypeDocLink(class(obj.Instances{1}));
        end

        function annotation = getAnnotationForNonScalarObject(~, ~)
            % Each element is annotated on its own line.
            annotation = '';
        end
    end
end

function text = plainWhenHotlinksOff(text)
% plainWhenHotlinksOff - Reduce hyperlinks to their visible label when
% hotlinks are off, so the annotation measures what it shows. See the
% function of the same name in CustomInstanceDisplay for the reasoning.

    if feature("hotlinks")
        return
    end
    text = regexprep(text, "<a [^>]*>(.*?)</a>", "$1");
end
