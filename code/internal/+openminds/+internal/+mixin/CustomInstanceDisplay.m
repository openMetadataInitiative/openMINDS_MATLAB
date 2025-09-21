classdef CustomInstanceDisplay < handle & matlab.mixin.CustomDisplay & ...
                                   matlab.mixin.CustomCompactDisplayProvider
% CustomInstanceDisplay Abstract base class providing customized instance display
%
%
%   Known subclasses:
%       - openminds.abstract.Schema
%       - openminds.internal.abstract.MixedTypeSet

% Todo:
%  [ ] Add displayEmptyObject, displayScalarObject, displayNonScalarObject
%  [ ] getFooter is different from instance/schema and mixedInstance...

    
    properties (Dependent, Transient, Hidden)
        DisplayString
    end

    properties (Constant, Access = protected)
        REFERENCE_DISPLAY_LABEL = "<reference>"
        NULLVALUE_DISPLAY_LABEL = 'None'; % 'Not set', 'Not present', 'N/A';
    end
    
    methods
        function obj = CustomInstanceDisplay()
            %pass
        end

        function str = char(obj)
            str = char( obj.DisplayString );
        end

        function str = string(obj)
            if numel(obj) > 1
                str = strjoin( arrayfun(@(x) string(x.DisplayString), obj ), '; ');
            else
                str = string( obj.DisplayString );
            end
        end

        function displayLabel = get.DisplayString(obj)
            if obj.isReference()
                displayLabel = obj.REFERENCE_DISPLAY_LABEL;
            else
                displayLabel = obj.getDisplayLabel();
                if isempty(displayLabel)
                    displayLabel = '<not named>';
                end
            end
        end
    end

    % Abstract - Subclasses must implement:
    methods (Abstract, Access = protected) 
        tf = isReference(obj)

        str = getDisplayLabel(obj)
        
        annotation = getAnnotation(obj, width)

        % str = getInstanceType(obj)
    end

    % Abstract - Subclasses must implement:
    methods (Abstract, Access = ?openminds.internal.mixin.CustomInstanceDisplay)
        semanticName = getSemanticName(obj)
    end

    % CustomDisplay - Method implementations
    methods (Hidden, Access = protected)
        
        function requiredProperties = getRequiredProperties(~)
            % Subclasses should override.
            requiredProperties = [];
        end

        function str = getHeader(obj)
            
            import openminds.internal.utility.getSchemaDocLink
            docLinkStr = getSchemaDocLink(class(obj));

            semanticName = obj.getSemanticName();
            
            if numel(obj) == 0
                docLinkStr = sprintf('Empty %s', docLinkStr);
                annotation = semanticName;
            elseif isscalar(obj)
                annotation = obj.id;
            elseif numel(obj) > 1
                docLinkStr = sprintf('1x%d %s', numel(obj), docLinkStr);
                annotation = semanticName;
            end

            str = sprintf('  %s (%s) with properties:\n', docLinkStr, annotation);
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

        function groups = getPropertyGroups(obj)

            displayPref = openminds.getpref("PropertyDisplayMode");
            switch displayPref
                case "all"
                    groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
                
                case "non-empty"
                    propNames = properties(obj);
                    s = struct();
                    for i = 1:numel(propNames)
                        if ~isempty( obj.(propNames{i}) )
                            s.(propNames{i}) = obj.(propNames{i});
                        end
                    end
                    groups = matlab.mixin.util.PropertyGroup(s);
            end
        end
        
        function displayNonScalarObject(obj)
        % displayNonScalarObject - Override non-scalar display

            % Get single line representation for each element
            repArray = arrayfun(@(o) o.compactRepresentationForSingleLine, obj, 'UniformOutput', false);
            stringArray = cellfun(@(r) "    "+ r.PaddedDisplayOutput, repArray);
            
            % Remove array brackets          
            stringArray = strrep(stringArray, '[', '');
            stringArray = strrep(stringArray, ']', '');

            % Display
            headerStr = obj.getHeader();
            headerStr = strrep(headerStr, 'with properties', 'with elements');
            disp(headerStr)
            if iscell(stringArray) || isstring(stringArray)
                fprintf( '%s\n\n', strjoin(stringArray, newline) );
            else
                fprintf( '%s\n\n', stringArray)
            end
        end
    end

    % CustomCompactDisplayProvider - Method implementation
    methods (Hidden)
        
        function rep = compactRepresentationForSingleLine(obj, displayConfiguration, width)
            if nargin < 2
                displayConfiguration = matlab.display.DisplayConfiguration();
            end
            if nargin < 3
                width = inf;
            end
            
            numObjects = numel(obj);

            if numObjects == 0
                str = openminds.internal.mixin.CustomInstanceDisplay.NULLVALUE_DISPLAY_LABEL;
                annotation = obj.getAnnotation(width);
                % displayConfiguration.DataDelimiters=["<", ">"];

                rep = matlab.display.PlainTextRepresentation(...
                    obj, str, displayConfiguration, 'Annotation', annotation);

            elseif numObjects == 1
                % Create a representation without annotation to learn it's width
                rep = fullDataRepresentation(obj, displayConfiguration, ...
                    'StringArray', obj.DisplayString);
                
                widthForAnnotation = width - rep.CharacterWidth - 3; % 3 = annotation padding " ()" 
                annotation = obj.getAnnotation(widthForAnnotation);
                
                rep = fullDataRepresentation(obj, displayConfiguration, ...
                    'StringArray', obj.DisplayString, ...
                    'Annotation', annotation);
            else
                stringArray = obj.getStringArrayForSingleLine(displayConfiguration, width);
                annotation = obj.getAnnotation(width);

                rep = fullDataRepresentation(obj, displayConfiguration, ...
                    'StringArray', stringArray, ...
                    'Annotation', annotation);
                
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
                        'StringArray', tempStringArray, ...
                        'Annotation', annotation);
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
                rep = fullDataRepresentation(obj, displayConfiguration, 'StringArray', arrayfun(@(i) obj(i).DisplayString, (1:numRows)', 'uni', 0) );

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
        
        function stringArray = getStringArrayForSingleLine(obj, displayConfiguration, width) %#ok<INUSD> Subclasses might use extra input args
            stringArray = arrayfun(@(o) o.DisplayString, obj, 'UniformOutput', false);
            if iscell(stringArray)
                stringArray = string(stringArray);
            else
                warning('A cell array was expected, but result was %s. Please report.', class(stringArray))
            end
            % Note: 2023-11-03: This function was returning a cell array but 
            % should return a string array...
        end
    end
end
