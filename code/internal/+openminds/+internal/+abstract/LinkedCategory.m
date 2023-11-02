classdef LinkedCategory < openminds.internal.mixin.CustomInstanceDisplay & handle
%LinkedTypeSet Abstract class representing a set of linked types

% This class behaves as a container for holding an instance that can be mixed 
% with other instances. This is similar to the matlab.mixin.Heterogeneous,
% but this class is context specific. I.e in general, a Person instance
% should not be mixed with any other schema, but a subclass allows a Person
% instance to be mixed with a specified set of other instances.
%
% This class is internal and should not be exposed to users. Subclasses will be 
% used for schema property definitions if properties support linked/embedded 
% types of different types.

% Rename to MixedTypeSet or MixableType

%   TODO:
%       [ ] Implement subsref in order to get instances out.
%       [ ] If all requested instances are the same, return a an object array
%       [ ] Consider if we need to define intersect, union etc.
%       [ ] Any other builtins needed???

% Subclass from CustomInstanceDisplay but override some of the methods...

    properties (Abstract, Constant)
        % Allowed types for a specific LinkedCategory instance
        ALLOWED_TYPES
        % Whether a specific LinkedCategory subclass should be "scalar".
        IS_SCALAR
    end

    properties
        % The openMINDS instance for an element of a mixed type object array
        Instance
    end

    methods 
        function obj = LinkedCategory(instance)
            
            if nargin == 0; return; end

            % Handle empty instance
            if isempty(instance)
                obj(:) = [];
                return
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
                
                if ischar(instance{i})
                    instanceName = string(instance{i});
                    % Check if we can create a controlled instance from it
                    for type = obj(i).ALLOWED_TYPES
                        if contains(type, 'openminds.controlledterms')
                            %[e, m] = enumeration(type);
                            m = eval(sprintf('%s.CONTROLLED_INSTANCES', type));
                            isMatch = strcmp(instanceName, m);

                            if any( isMatch )
                                %instance{i} = e(strcmp(instance{i}, m));
                                instance{i} = feval(type, instanceName);
                                break
                            end
                        end
                    end
                end

                if isstruct(instance{i}) && isfield(instance{i}, 'at_id')
                    % Support initializing an Instance from a struct with 
                    % an @id. This will be act as a placeholder for an 
                    % unresolved linked instance, and the link needs to be 
                    % resolved externally in order to put a real instance in place.
                    obj.Instance = instance{i}.at_id;
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

    end
    
    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.Instance.getDisplayLabel();
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
            docLinkStr = sprintf('1x%d %s', numel(obj), docLinkStr);
            
            semanticName = obj.getSemanticName();
            str = sprintf('  %s array (%s):\n', docLinkStr, semanticName);
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
        end

        function displayNonScalarObject(obj)
                
            repArray = arrayfun(@(o) o.Instance.compactRepresentationForSingleLine, obj, 'UniformOutput', false);
            %stringArray = cellfun(@(r) r.Representation, repArray);
            %rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', stringArray, 'Annotation', annotation');


            stringArray = cellfun(@(r) "    "+ r.PaddedDisplayOutput, repArray);
            stringArray = strrep(stringArray, '[', '');
            stringArray = strrep(stringArray, ']', '');
            str = obj.getHeader;
            disp(str)
            fprintf( '%s\n\n', strjoin(stringArray, '    \n') );
        end

    end

    % Utility methods for CustomCompactDisplayProvider methods
    methods (Access = protected)
        
        function stringArray = getStringArrayForSingleLine(obj)
            repArray = arrayfun(@(o) o.Instance.compactRepresentationForSingleLine, obj, 'UniformOutput', false);
            %stringArray = cellfun(@(r) r.Representation, repArray);
            %rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', stringArray, 'Annotation', annotation');

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