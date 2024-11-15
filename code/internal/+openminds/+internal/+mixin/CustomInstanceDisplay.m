classdef CustomInstanceDisplay < handle & matlab.mixin.CustomDisplay & ...
                                   matlab.mixin.CustomCompactDisplayProvider
% CustomInstanceDisplay Abstract base class providing customized instance display
%
%
%   Known subclasses:
%       - openminds.abstract.Schema
%       - openmidns.internal.abstract.LinkedCategory

% Todo:
%  [ ] Clean up and improve Compact Displays
%  [ ] Smarter collapse if single line display is too long.
%  [ ] Add displayEmptyObject, displayScalarObject, displayNonScalarObject
%  [ ] Distinguish between arrays and scalars...
%  [ ] getFooter is different from instance/schema and mixedInstance...

    % Dependencies that should be handled better:
    %  - X_TYPE
    
    properties (Dependent, Transient, Hidden)
        DisplayString
    end
    
    methods

        function obj = CustomInstanceDisplay()
            %pass
        end

        function str = char(obj)
            str = char( obj.DisplayString );
        end

        function str = string(obj)
            str = string( obj.DisplayString );
        end

        function displayLabel = get.DisplayString(obj)
            displayLabel = obj.getDisplayLabel();
            if isempty(displayLabel)
                displayLabel = '<not named>';
            end
        end
    end

    methods (Abstract, Access = protected) % Subclasses must implement.
        
        str = getDisplayLabel(obj)
        
        annotation = getAnnotation(obj)

        % str = getInstanceType(obj)
    end

    methods (Hidden, Access = protected) % CustomDisplay - Method implementation
        
        function requiredProperties = getRequiredProperties(obj)
            requiredProperties = [];
        end

        function str = getHeader(obj)
            
            import openminds.internal.utility.getSchemaDocLink
            docLinkStr = getSchemaDocLink(class(obj));

            semanticName = obj.getSemanticName();
            
            if numel(obj) == 0
                docLinkStr = sprintf('Empty %s', docLinkStr);
            elseif numel(obj) > 1
                docLinkStr = sprintf('1x%d %s', numel(obj), docLinkStr);
            end

            str = sprintf('  %s (%s) with properties:\n', docLinkStr, semanticName);
        end

        function str = getFooter(obj)
            str = '';

            if isempty(obj)
                return
            end

            requiredProperties = obj(1).getRequiredProperties();

            if ~isempty(requiredProperties)
                str = sprintf('  Required Properties: <strong>%s</strong>', strjoin(requiredProperties, ', '));
                str = openminds.internal.utility.string.strfold(str, 100);
                str = strjoin(str, '\n    ');
                str = sprintf('  %s\n', str);
            end
        end
        
        function displayNonScalarObject(obj)
            displayNonScalarObject@matlab.mixin.CustomDisplay(obj)
        end
    end

    methods (Hidden) % % CustomCompactDisplayProvider - Method implementation
        
        function rep = compactRepresentationForSingleLine(obj, displayConfiguration, width)
            import openminds.internal.utility.getSchemaName
   
            if nargin < 2
                displayConfiguration = matlab.display.DisplayConfiguration();
            end

            numObjects = numel(obj);
                       
            annotation = obj.getAnnotation();

            if numObjects == 0
                str = 'None';
                % schemaName = getSchemaName(class(obj));
                % str = sprintf("0x0 empty %s", schemaName);
                rep = matlab.display.PlainTextRepresentation(obj, str, displayConfiguration, 'Annotation', annotation);
                % rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', string(str));

            elseif numObjects == 1
                rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', obj.DisplayString, 'Annotation', annotation);
            
            else
                stringArray = obj.getStringArrayForSingleLine();

                rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', stringArray, 'Annotation', annotation);
                
                count = 1;

                defaultRep = compactRepresentationForSingleLine@matlab.mixin.CustomCompactDisplayProvider(obj, displayConfiguration, width);
                sizeTypeStr = defaultRep.PaddedDisplayOutput;
                sizeTypeStr = strrep(sizeTypeStr, '[', '(');
                sizeTypeStr = strrep(sizeTypeStr, ']', ')');

                while rep.CharacterWidth > width
                    tempStringArray = stringArray(1:end-count);
                    if isempty(tempStringArray)
                        break
                    end

                    tempStringArray(end) = tempStringArray(end) + "... " + sizeTypeStr;
                    rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', tempStringArray, 'Annotation', annotation);
                    count = count + 1;
                end
            end
        end

        function rep = compactRepresentationForColumn(obj, displayConfiguration, default)
            
            % Note: Input will be an array with one object per row in the
            % column to represent. Output needs to take this into account.
            
            import openminds.internal.utility.string.packageParts

            if nargin < 2
                displayConfiguration = matlab.display.DisplayConfiguration();
            end
            
            % Todo: Do this per row....
            numObjects = numel(obj);

            numRows = size(obj, 1);

            className = packageParts( class(obj) );

            if numObjects == 0
                % str = 'None';
                % Todo: Make plural labels.
                str = sprintf('No %s available', className{end});
                rep = matlab.display.PlainTextRepresentation(obj, repmat({str}, numRows, 1), displayConfiguration);
            elseif numObjects >= 1
                % str = obj.DisplayString;
                rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', arrayfun(@(i) obj(i).DisplayString, [1:numRows]', 'uni', 0) );

            elseif numObjects > 1
                % rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', obj.DisplayString );
                rep = compactRepresentationForColumn@matlab.mixin.CustomCompactDisplayProvider(obj, displayConfiguration, default);
            end
            
            % Fit all array elements in the available space, or else use
            % the array dimensions and class name
            % rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', str );
        end
    end

    % Utility methods for CustomCompactDisplayProvider methods
    methods (Access = protected)
        
        function stringArray = getStringArrayForSingleLine(obj)
            stringArray = arrayfun(@(o) o.DisplayString, obj, 'UniformOutput', false);
            if iscell(stringArray)
                stringArray = string(stringArray);
            else
                warning('A cell array was expected, but result was %s. Please report.', class(stringArray))
            end
            % Note: 2023-11-03: This was returning a cell array but should
            % return a string array...
        end
    end

    methods (Access = protected)

        function semanticName = getSemanticName(obj)

            import openminds.internal.utility.string.packageParts
            import openminds.internal.utility.string.camelCase

            fullClassName = class(obj);

            if contains(fullClassName, 'mixedtype')
                BASE_URL = "https://openminds.ebrains.eu/vocab/";
                [~, shortClassName] = packageParts(fullClassName);
                shortClassName = camelCase(shortClassName);
                semanticName = BASE_URL + shortClassName;
            else
                semanticName = eval( [fullClassName '.X_TYPE'] );
            end
        end
    end
end
