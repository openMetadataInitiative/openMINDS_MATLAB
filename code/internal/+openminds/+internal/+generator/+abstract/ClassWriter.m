classdef ClassWriter < handle
%ClassWriter A class that can be used for writing matlab class definitions
%
%   This class provides useful methods and templates for generating a
%   formatted matlab class definition file.
%
%   Subclasses can use these methods in order to translate a collection of
%   schemas or templates into matlab class definitions.

%   Todo:
%   [ ] Highlight properties and methods that should be set and used by
%       subclasses in the class documentation.

    properties
        ClassName string       % Name of class
        SuperclassList cell    % List of superclasses for class
    end

    properties
        Filepath               % Name of file to save class definition
    end

    properties (Dependent)
        IsAbstract             % Whether class is abstract (default is false)
        HasSuperclass          % Whether class has superclasses
    end

    properties (SetAccess = private)
        ClassDefText string = ""
    end

    properties (Constant, Hidden)
        INDENTATION_WIDTH = 4  % Width of indentation in spaces % Todo: setting
    end

    properties (Access = private)
        CurrentStep = ""
        PreviousStep = ""
    end

    properties (Constant, Hidden)
        LineIndenter = memoize(@openminds.internal.generator.abstract.ClassWriter.getLineIndent)
    end

    methods % Set / get
        function isAbstract = get.IsAbstract(obj)
            isAbstract = obj.isClassAbstract();
        end
        
        function hasSuperclass = get.HasSuperclass(obj)
            hasSuperclass = ~isempty(obj.SuperclassList);
        end

        function set.ClassName(obj, newName)
            firstLetter = newName.extractBefore(2);
            if strcmp(firstLetter, lower(firstLetter))
                newNameLowercase = newName;
                newName{1}(1) = upper(firstLetter);
                warning('Classname should start with a capital letter. Changed name from "%s" to "%s"', newNameLowercase, newName) %#ok<PFCEL>
            end
            obj.ClassName = newName;
        end
    end

    methods
        function show(obj)
            fprintf(obj.ClassDefText)
        end
    end

    methods (Access = protected)
        function isAbstract = isClassAbstract(obj)
        %isClassAbstract Whether class is abstract. Subclasses can override
            isAbstract = false;
        end
    end

    methods (Access = protected) % Methods which subclasses should implement

        function writeDocString(obj)
        end

        function writePropertyBlocks(obj)
        end
    
        function writeEnumerationBlock(obj)
        end
    
        function writeEventBlocks(obj)
        end
            
        function writeMethodBlocks(obj)
        end
    end
    
    methods (Access = protected, Sealed)
        
        function addSuperclass(obj, varargin)
        %addSuperclass Add superclass(es)
            for i = 1:numel(varargin)
                obj.SuperclassList(end+1) = varargin(i);
            end
        end
    
        function writeClassdef(obj)
        %writeClassdef Write class definition.

            obj.initClassDef()
            
            obj.writeDocString()

            obj.appendLine(0, "")

            obj.writePropertyBlocks()
            
            obj.writeEnumerationBlock()

            obj.writeEventBlocks()

            obj.writeMethodBlocks()
                       
            obj.endClassDef()
        end
    
        function saveClassdef(obj)
            
            filePath = obj.Filepath;

            if isempty(filePath)
                error('No filename is specified for saving class definition')
            end

            [folderPath, ~, fileExt] = fileparts(filePath);
            if isempty(fileExt)
                filePath = [filePath, '.m'];
            else
                assert(strcmp(fileExt, '.m'), 'The specified filepath must be pointing to a .m file')
            end
            
            % Todo: Use openminds.internal.utility.filewrite:

            if ~exist(folderPath, 'dir')
                mkdir(folderPath)
            end
        
            fid = fopen(filePath, 'w');
            fwrite(fid, obj.ClassDefText);
            fclose(fid);

            %fprintf('Saved class definition for %s to:\n"%s"\n', obj.ClassName, filePath)
        end

        function appendLine(obj, numIndent, str)
            newStr = obj.indentLine(str, numIndent);
            obj.ClassDefText = obj.ClassDefText + newStr + newline;
        end

        function appendDocString(obj, numIndent, str)
            newStr = obj.indentLine(str, numIndent);
            newStr{1}(1) = "%";
            obj.ClassDefText = obj.ClassDefText + newStr + newline;
        end
    end

    % % Methods for starting and ending different code blocks
    methods (Access = protected)
        
        % Class definition
        function initClassDef(obj)
        %writeClassDef Writes the class definition header for a class
            assert(obj.ClassDefText == "", ...
                "Can not initialize class, because class definition is not empty")
            
            newStr = "classdef " + obj.ClassName;
            
            if obj.HasSuperclass
                newStr = newStr + " < " + strjoin( obj.SuperclassList, ' & ' );
            end

            if obj.IsAbstract
                newStr = replace(newStr, "classdef", "classdef (Abstract)");
            end

            obj.ClassDefText = obj.ClassDefText + newStr + newline;
        
            obj.CurrentStep = "classdef";
        end

        function endClassDef(obj)
            obj.ClassDefText = obj.ClassDefText + "end";
            obj.CurrentStep = "";
        end

        % Class member blocks

        function startPropertyBlock(obj, varargin)
            assert(obj.CurrentStep == "classdef" && ...
                    (obj.PreviousStep == "" || ...
                     obj.PreviousStep == "properties"), 'Can not start new property block here!' )
            
            %    "Can not start a new property block because the " + ...
            %    "current stage is set to %s", obj.CurrentStep)

            % Todo: Validate property attributes
            attributes = varargin;

            blockName = "properties";
            obj.startClassMemberBlock(blockName, attributes{:})
        end

        function startEnumerationBlock(obj)
            blockName = "enumeration";
            obj.startClassMemberBlock(blockName)
        end

        function startEventsBlock(obj)
            % Todo: Validate events attributes
            attributes = varargin;

            blockName = "events";
            obj.startClassMemberBlock(blockName, attributes{:})
        end

        function startMethodsBlock(obj, varargin)
                          
            % Todo: Validate methods attributes
            attributes = varargin;

            blockName = "methods";
            obj.startClassMemberBlock(blockName, attributes{:})
        end

        function endPropertyBlock(obj)
            obj.endClassMemberBlock()
        end

        function endEnumerationBlock(obj)
            obj.endClassMemberBlock()
        end

        function endMethodsBlock(obj)
            obj.endClassMemberBlock()
        end

        function endEventsBlock(obj, varargin)
            obj.endClassMemberBlock()
        end
        
        % Adding properties
        function addProperty(obj, name, options)
            
            arguments
                obj (1,1) openminds.internal.generator.abstract.ClassWriter
                name (1,1) string
                options.DefaultValue = ""
                options.Size = ""
                options.Type = ""
                options.Validator (1,1) string = ""
            end
            
            newStr = name;
            
            if options.Size ~= ""
                newStr = newStr + " " + options.Size;
            end

            if options.Type ~= ""
                newStr = newStr + " " + options.Type;
                splitIdx = strlength(newStr);
            end

            if options.Validator ~= ""
                newStr = newStr + " " + options.Validator;
            end

            if options.DefaultValue ~= ""
                newStr = newStr + " = " + options.DefaultValue;
            end
            
            if strlength(newStr) > 80 && exist('splitIdx', 'var')
                indent = string( repmat(' ', 1, 12) );
                newStr = insertAfter(newStr, splitIdx, " ..."+newline+indent);
            end

            obj.appendLine(2, newStr)
        end

        % Method that adds an enumeration value
        function addEnumValue(obj, enumValue, varargin)
    
            enumValue = string(enumValue);
            if enumValue.strlength > 63
                warning("Skip %s of %s because name is too long for MATLAB", enumValue, obj.SchemaClassName)
                return
            end

            if isempty(varargin)
                enumInput = enumValue;
            else
                enumInput = strjoin(varargin, ", ");
            end
            
            newStr = sprintf("%s('%s')", enumValue, enumInput);
            obj.appendLine(2, newStr)
        end
        
        % Adding methods
        function startFunctionBlock(obj, functionName, options)
            arguments
                obj (1,1) openminds.internal.generator.abstract.ClassWriter
                functionName (1,1) string
                options.Inputs (1,:) cell = {}
                options.Outputs (1,:) cell = {}
            end
            % Todo
            warning('Method "startFunctionBlock" is not implemented yet')
        end

        function endFunctionBlock(obj)
            numIndent = 2;
            obj.appendLine(numIndent, "end");
            %obj.appendLine(numIndent, ""); % Add empty line
            obj.CurrentStep = "methods";
        end
    end
    
    % Set/get for private properties
    methods
        function set.CurrentStep(obj, newValue)
            currentStep = obj.CurrentStep;
            obj.CurrentStep = newValue;
            obj.updatePreviousStep(currentStep)
        end
    end

    methods (Access = private) % Internal methods
        function startClassMemberBlock(obj, blockName, varargin)
        %startClassMemberBlock Start one of the class member blocks
            
            validNames = ["properties", "methods", "enumeration", "events"];
            blockName = validatestring(blockName, validNames);
            
            numIndent = 1;
            
            newStr = blockName;
            
            if ~isempty(varargin)
                newStr = obj.addAttributes(newStr, varargin);
            end
            
            obj.appendLine(numIndent, newStr);
            obj.CurrentStep = blockName;
        end

        function endClassMemberBlock(obj)
            numIndent = 1;
            obj.appendLine(numIndent, "end");
            obj.appendLine(numIndent, ""); % Add empty line
            obj.CurrentStep = "classdef";
        end

        function updatePreviousStep(obj, previousStep)
            obj.PreviousStep = previousStep;
        end
    end

    methods (Static, Access = private)
        function newStr = addAttributes(newStr, attributes)
        %addAttributes Add attributes as comma separated list in parenthesis
            newStr = sprintf("%s (%s)", newStr, strjoin(attributes, ', '));
        end

        function str = indentLine(str, numIndents)
        %indentLine Add indentation to a str representing a line of code
            indentationStr = openminds.internal.generator.abstract.ClassWriter.LineIndenter(numIndents);
            str = sprintf("%s%s", indentationStr, str);
        end

        function indentationStr = getLineIndent(numIndents)
        %getLineIndent Get spaces for indentation
            indentationWidth = numIndents * openminds.internal.generator.abstract.ClassWriter.INDENTATION_WIDTH;
            indentationStr = repmat(' ', 1, indentationWidth);
        end
    end

    % Utility methods
    methods (Static, Access = protected)
        function str = cellArrayToTextString(cellArray)
            str = openminds.internal.generator.utility.cellArrayToTextString(cellArray);
        end
    end
end
