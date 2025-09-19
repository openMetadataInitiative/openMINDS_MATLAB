classdef MixedTypeSet < openminds.internal.mixin.CustomInstanceDisplay & handle
% MixedTypeSet - Abstract class representing a set of types that can mixed

% Many properties of openMINDS metadata schemas/types can hold linked or
% embedded metadata instances of different types. This class acts as a
% container that can hold a set of instances that can be mixed with instances
% of other types. This provides a way to add instances of different types
% as property values to a property of an openMINDS metadata type even
% though MATLAB does not natively support mixing different class objects in a
% list.
%
% For each openMIDNS property that allows a set of different linked or embedded
% types, the openMINDS_MATLAB build pipeline will generate a subclass of
% the MixedTypeSet and place in the "mixedtypes/" folder

% Developer notes:
%
% The behavior is similar to the matlab.mixin.Heterogeneous, but with some
% key differences. If using matlab.mixin.Heterogeneous, it would need to be
% added as a mixin the the base class of metadata types, i.e
% openminds.abstract.Schema and as a result any typed instance could be
% mixed with any other typed instance. However, the MixedTypeSet only
% allows mixing a specified subset of instances in a specific context. For
% example, the openminds.internal.mixedtype.datasetversion.Author allows
% instances of types Consortium, Organization and Person to be mixed, and
% the DatasetVersion type specifies that the author property is restricted
% to the "*.Author" mixed type. Therefore mixing instances of these types
% are supported only in a DatasetVersion/author context.
%
% Using the matlab.mixin.Heterogeneous as a mixin on the base class and
% mustBeA for property validation on generated type classes is an an
% alternative option. Need to consider whether it is a benefit to allow all
% metadata types to be represented in array form instead of cell array
% form. Originally in this project, using the Heterogeneous mixin was not
% an option because of the use of enumerations for controlled instances in
% the ControlledTerm subtypes, but this was later removed.
%
% This class is internal and should not be exposed to users.

% TODO:
%  - [ ] Implement subsref in order to get instances out.
%  - [ ] If all requested instances are the same, return an object array
%  - [ ] Consider if we need to define intersect, union etc.
%  - [ ] Any other builtins needed???

    properties (Abstract, Constant)
        % Allowed types for a specific MixedTypeSet instance
        ALLOWED_TYPES
        % Whether a specific MixedTypeSet subclass should be "scalar".
        IS_SCALAR
    end

    properties % Todo: SetAccess = immutable ?
        % The openMINDS instance for an element of a mixed type object array
        Instance {mustBeA(Instance, ["double", "openminds.abstract.Schema"] )} = []
    end

    methods
        function obj = MixedTypeSet(sourceValue)
        % MixedTypeSet - Constructor for MixedTypeSet

        % Constructor supports many types of input to create instances from:
        %
        %   - char / string : IRI or name of a Controlled Term instance
        %   - openMINDS instance
        %   - mixed type instance
        %   - cell array of openMINDS instances
        %   - Mix of all the above
        %  
        % This flexibility is necessary because of how MATLAB's property type 
        % validation works. When a class is specified as a property type, 
        % any value assigned to that property is automatically passed to 
        % the class constructor for conversion. This way a user does not
        % have to explicitly create MixedType instances themselves, but
        % work with more concrete data types.

            if nargin == 0; return; end
           
            if isempty(sourceValue)
                obj(:) = []; % Create empty instance
                return
            end

            if ischar(sourceValue)
                sourceValue = string(sourceValue);
            end

            if ~iscell(sourceValue) % Normalize to cell array
                sourceValue = num2cell(sourceValue);
            end

            % Preallocate object array
            obj(1, numel(sourceValue)) = feval(class(obj));
            
            % Process each instance value
            for i = 1:numel(sourceValue)
                
                if isstring(sourceValue{i}) || ischar(sourceValue{i})
                    sourceValue{i} = obj(i).preprocessFromString(sourceValue{i});
                end

                if isstruct(sourceValue{i}) % Linked or embedded instance
                    obj(i).Instance = obj.initializeFromStructure(sourceValue{i});

                elseif isa(sourceValue{i}, class(obj)) % Already a mixed type instance
                    obj(i) = sourceValue{i};
                
                else % An openMINDS typed instance: validate type, then add
                    if isa(sourceValue{i}, "openminds.internal.MixedTypeReference")
                        obj(i).Instance = sourceValue{i};
                    else
                        mustBeOneOf(sourceValue{i}, obj(i).ALLOWED_TYPES)
                        obj(i).Instance = sourceValue{i};
                    end
                end
            end
        end

        function [lia, locb] = ismember(obj, B)
        %ismember Check if instance is member of group
        
            % Todo: Revisit this. Is it useful. Is it robust?

            % If checking membership for mixedtypes
            if isequal( class(obj), class(B) )
                if nargout > 1
                    [lia,locb] = ismember(obj, B);
                else
                    lia = ismember(obj, B);
                end
                        
            % If checking membership for instance in list of mixedtypes.
            else
                isOfClassB = arrayfun(@(o) isequal(class(o.Instance), class(B)), obj);
                tempA = arrayfun(@(i) feval(class(B)), 1:numel(obj), 'uni', 0 );
                tempA = [tempA{:}];
                tempA(isOfClassB) = [obj(isOfClassB).Instance];

                if nargout > 1
                    [lia,locb] = ismember(tempA, B);
                else
                    lia = ismember(tempA, B);
                end
            end
        end

        function cellArray = cellstr(obj)
            cellArray = cell(1, numel(obj));
            for i = 1:numel(cellArray)
                cellArray{i} = char(obj(i));
            end
        end

        function stringArray = string(obj)
            stringArray = repmat("", 1, numel(obj));
            for i = 1:numel(stringArray)
                stringArray(i) = string(char(obj(i)));
            end
        end

        function cellArrayOfStruct = toStruct(obj)
            cellArrayOfStruct = cell(1, numel(obj));
            for i = 1:numel(cellArrayOfStruct)
                cellArrayOfStruct{i} = obj(i).Instance.toStruct();
            end
        end
    
        function tf = isequal(obj, instance)
            if isempty(obj) && isempty(instance)
                if strcmp( class(obj), class(instance) )
                    tf = true;
                else
                    tf = false;
                end
            elseif isempty(obj) || isempty(instance)
                tf = false;
            else
                tf = builtin('isequal', obj, instance) || ...
                        builtin('isequal', obj.Instance, instance);
            end
        end
    
        function instance = resolve(obj, options)
            arguments
                obj (1,:) openminds.internal.abstract.MixedTypeSet
                options.NumLinksToResolve = 0
            end
            for i = 1:numel(obj)
                if isa(obj(i).Instance, 'openminds.internal.MixedTypeReference')
                    obj(i).Instance = obj(i).Instance.resolve("NumLinksToResolve", options.NumLinksToResolve);
                else
                    obj(i).Instance.resolve("NumLinksToResolve", options.NumLinksToResolve)
                end
            end
            instance = {obj.Instance};
        end
    end

    methods (Access = private)

        function instance = preprocessFromString(obj, stringValue)
        % preprocessFromString - Try to initialize an openMINDS instance
        % from a controlled term name or IRI

        % Note: If only a controlled term name is given, this function stops at 
        % the first match. If multiple controlled term types contain instances 
        % with the same name, the result may be unintended.

            instance = [];

            if openminds.utility.isInstanceIRI(stringValue)
                [typeEnum, ~] = openminds.utility.parseInstanceIRI(stringValue);
                mustBeOneOf(typeEnum.ClassName, obj(1).ALLOWED_TYPES)
                instance = openminds.instanceFromIRI(stringValue);
            else
                % Check if we can create a controlled instance from it
                for type = obj(1).ALLOWED_TYPES
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
    
        function instance = initializeFromStructure(~, structure)
        % initializeFromStructure - Initialize an instance from a structure
            arguments
                ~
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
                % Todo: warning or error? From preference...
                error('Unsupported structure') % TODO: more detailed error
            end
        end
    end
    
    methods (Access = protected)
        function tf = isReference(obj)
            tf = isa(obj.Instance, 'struct');
        end

        function str = getDisplayLabel(obj)
            if isa(obj.Instance, 'struct')
                str = '<unresolved link>';
            elseif openminds.utility.isInstance(obj.Instance)
                str = obj.Instance.getDisplayLabel();
            else
                error('Unsupported type for instance')
            end
        end
    end
    
    methods (Hidden, Access = protected) % Override CustomDisplay methods

        function str = getHeader(obj)
            % Todo: combine with superclass methods.
            import openminds.internal.utility.getSchemaDocLink
            docLinkStr = getSchemaDocLink(class(obj));
            
            % Todo: Consider indicating that the array has mixed types,
            % i.e is heterogeneous-like...
            % docLinkStr = sprintf('1x%d heterogeneous %s', numel(obj), docLinkStr);

            docLinkStr = sprintf('1x%d %s', numel(obj), docLinkStr);
            if isempty(obj)
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
            % This should not happen...
            disp(obj.Instance)
            warning('Displaying scalar mixed type object. This is a non-critical bug.')
        end

        function displayNonScalarObject(obj)
            if isstruct(obj(1).Instance)
                stringArray = strjoin( arrayfun(@(o) o.Instance.id, obj, 'UniformOutput', false), newline);
            else
                repArray = arrayfun(@(o) o.Instance.compactRepresentationForSingleLine, obj, 'UniformOutput', false);
                % stringArray = cellfun(@(r) r.Representation, repArray);
                % rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', stringArray, 'Annotation', annotation');
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

    % Utility methods for CustomCompactDisplayProvider methods
    methods (Access = protected)
        
        function stringArray = getStringArrayForSingleLine(obj, displayConfiguration, width)
            try
                repArray = arrayfun(@(o) o.Instance.compactRepresentationForSingleLine(displayConfiguration, width), obj, 'UniformOutput', false);
            catch
                repArray = arrayfun(@(o) o.compactRepresentationForSingleLine(displayConfiguration, width), obj, 'UniformOutput', false);
            end
            % stringArray = cellfun(@(r) r.Representation, repArray);
            % rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', stringArray, 'Annotation', annotation');

            stringArray = cellfun(@(r) r.PaddedDisplayOutput, repArray);
            stringArray = strrep(stringArray, '[', '');
            stringArray = strrep(stringArray, ']', '');
        end
    end

    methods (Access = protected)
    
        function annotation = getAnnotation(obj, width)
            if nargin < 2; width = inf; end
            
            if isempty(obj)
                annotation = obj.getAnnotationForEmptyObject(width);
            
            elseif isscalar(obj)
                if isa(obj.Instance, "openminds.internal.MixedTypeReference")
                    annotation = obj.getAnnotationForEmptyObject(width);
                else
                    annotation = obj.getAnnotationForScalarObject(width);
                end
            else
                annotation = obj.getAnnotationForNonScalarObject(width);
            end
        end
    
        function annotation = getAnnotationForEmptyObject(obj, width)
            import openminds.internal.utility.getSchemaDocLink
            if eval( [class(obj), '.IS_SCALAR'] )
                prefix = 'One of';
            else
                prefix = 'Any of';
            end

            availableWidth = width - strlength(prefix) - 2; % 2 = ": "

            allAllowedClasses = eval(sprintf('%s.ALLOWED_TYPES', class(obj)));
            allowedClassesShort = openminds.internal.utility.getSchemaShortName(allAllowedClasses);
            
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

            annotation = arrayfun(@(s) getSchemaDocLink(s), allowedClasses, 'UniformOutput', false);
            annotation = strjoin(annotation, ', ');

            annotation = sprintf('%s: %s%s', prefix, annotation, postFix);
        end
    
        function annotation = getAnnotationForScalarObject(obj, ~)
            import openminds.internal.utility.getSchemaDocLink
            annotation = getSchemaDocLink(class(obj.Instance));
        end

        function annotation = getAnnotationForNonScalarObject(~, ~)
            annotation = ''; return
            % Each element will be annotated. Todo: Consider, whether we
            % want to show the annotation for all allowed types in addition
            % % import openminds.internal.utility.getSchemaDocLink
            % % classNames = arrayfun(@(x) class(x.Instance), obj, "UniformOutput", false);
            % % classNames = unique(classNames);
            % % annotation = arrayfun(@(s) getSchemaDocLink(s), ...
            % %     string(classNames), 'UniformOutput', false);
        end
    end

    methods (Access = ?openminds.internal.mixin.CustomInstanceDisplay)
        function semanticName = getSemanticName(obj)
            import openminds.internal.utility.string.packageParts

            iriPrefix = openminds.constant.PropertyIRIPrefix();
            assert(isa(iriPrefix,'string'), 'Internal error: Expected string')

            [~, shortName] = packageParts(class(obj));
            shortName = openminds.internal.utility.string.camelCase(shortName);
            semanticName = iriPrefix + shortName;
        end
    end

    methods (Static, Access = protected, Hidden)
        
        function shortSchemaName = getSchemaShortName(fullSchemaName)
        %getSchemaShortName Get short schema name from full schema name
        %
        %   shortSchemaName = getSchemaShortName(fullSchemaName)
        %
        %   Example:
        %   fullSchemaName = 'openminds.core.research.Subject';
        %   shortSchemaName = obj.getSchemaShortName(fullSchemaName)
        %
        %     'Subject'

            import openminds.internal.utility.getSchemaName
            shortSchemaName = getSchemaName(fullSchemaName);
        end
    end
end
