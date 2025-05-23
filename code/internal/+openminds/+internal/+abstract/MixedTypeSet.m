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

%   TODO:
%       [ ] Implement subsref in order to get instances out.
%       [ ] If all requested instances are the same, return a an object array
%       [ ] Create a separate mixin class for the custom display related functionality
%       [ ] Consider if we need to define intersect, union etc.
%       [ ] Any other builtins needed???

% Subclass from CustomInstanceDisplay but override some of the methods...

    properties (Abstract, Constant)
        % Allowed types for a specific MixedTypeSet instance
        ALLOWED_TYPES
        % Whether a specific MixedTypeSet subclass should be "scalar".
        IS_SCALAR
    end

    properties
        % The openMINDS instance for an element of a mixed type object array
        Instance
    end

    methods
        function obj = MixedTypeSet(instance)
            
            if nargin == 0; return; end

            % Handle empty instance
            if isempty(instance)
                obj(:) = [];
                return
            end

            % if isstruct(instance) && isfield(instance, 'at_id')
            %     instance = {instance.at_id};
            % end

            if ischar(instance)
                instance = string(instance);
            end

            if ~iscell(instance)
                if numel(instance) == 1
                    instance = {instance};
                else
                    instance = arrayfun(@(i) i, instance, 'UniformOutput', false);
                end
            end
            
            % Preallocate object array
            obj(numel(instance)) = feval(class(obj));
            
            % Process each instance value
            for i = 1:numel(instance)
                
                if isstring(instance{i})
                    instanceName = instance{i};
                    % Check if we can create a controlled instance from it
                    for type = obj(i).ALLOWED_TYPES
                        if contains(type, 'openminds.controlledterms')
                            allInstanceNames = eval(sprintf('%s.CONTROLLED_INSTANCES', type));

                            if openminds.utility.isSemanticInstanceName(instanceName)
                                S = openminds.utility.parseAtID(instanceName);
                                instanceName = S.Name;
                            end
                             
                            isMatch = strcmp(instanceName, allInstanceNames);

                            if any( isMatch )
                                instance{i} = feval(type, instanceName);
                                break
                            end
                        end
                    end
                end

                if isstruct(instance{i}) && isfield(instance{i}, 'at_id')
                    % Support initializing an Instance from a struct with
                    % an @id. This will act as a placeholder for an
                    % unresolved linked instance, and the link needs to be
                    % resolved externally in order to put a real instance in place.
                    obj(i).Instance = struct;
                    obj(i).Instance.id = instance{i}.at_id;
                elseif isstruct(instance{i}) && isfield(instance{i}, 'x_id')
                    % Variation of before
                    obj(i).Instance = struct;
                    obj(i).Instance.id = instance{i}.x_id;
                elseif isstruct(instance{i}) && isfield(instance{i}, 'at_type')
                    % Embedded type as structure
                    obj(i).Instance = openminds.fromTypeName(instance{i}.at_type);
                    obj(i).Instance = obj(i).Instance.fromStruct(instance{i});

                elseif isa(instance{i}, class(obj))
                    obj(i) = instance{i};
                else
                    mustBeOneOf(instance{i}, obj(i).ALLOWED_TYPES)
                    obj(i).Instance = instance{i};
                end
            end
        end

        function [lia, locb] = ismember(obj, B)
        %ismember Check if instance instance is member of group
        
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
    end
    
    methods (Access = protected)
        function str = getDisplayLabel(obj)
            if isa(obj.Instance, 'struct')
                str = '<unresolved link>';
            elseif openminds.utility.isInstance(obj.Instance)
                str = obj.Instance.getDisplayLabel();
            else
                error('Unsupported type for instance')
            end
        end

        function str = getSemanticName(obj)
            shortName = obj.getShortName();
            shortName = openminds.internal.utility.string.camelCase(shortName);
            str = sprintf('https://openminds.ebrains.eu/vocab/%s', shortName);
        end
        
        function str = getShortName(obj)
            import openminds.internal.utility.string.packageParts
            [~, str] = packageParts(class(obj));
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
        
        function stringArray = getStringArrayForSingleLine(obj)
            try
                repArray = arrayfun(@(o) o.Instance.compactRepresentationForSingleLine, obj, 'UniformOutput', false);
            catch
                repArray = arrayfun(@(o) o.compactRepresentationForSingleLine, obj, 'UniformOutput', false);
            end
            % stringArray = cellfun(@(r) r.Representation, repArray);
            % rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', stringArray, 'Annotation', annotation');

            stringArray = cellfun(@(r) r.PaddedDisplayOutput, repArray);
            stringArray = strrep(stringArray, '[', '');
            stringArray = strrep(stringArray, ']', '');
        end
    end

    methods (Access = protected)
    
        function annotation = getAnnotation(obj)
            import openminds.internal.utility.getSchemaDocLink

            if ~isempty(obj) && isa(obj(1).Instance, 'openminds.controlledterms.ControlledTerm')
                % Todo: Use obj.Instance.getAnnotation (but: can't access method if protected...)
                annotation = 'Controlled Instance';
            else
                allowedClasses = eval(sprintf('%s.ALLOWED_TYPES', class(obj)));
                annotation = arrayfun(@(s) getSchemaDocLink(s), allowedClasses, 'UniformOutput', false);
                annotation = strjoin(annotation, ', ');
                
                if eval( [class(obj), '.IS_SCALAR'] )
                    prefix = 'One of';
                else
                    prefix = 'Any of';
                end

                annotation = sprintf('%s: %s', prefix, annotation);
            end
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
