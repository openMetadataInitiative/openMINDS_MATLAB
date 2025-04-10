classdef InstanceTest < matlab.unittest.TestCase
% InstanceTest - Unit test for creation and save/load of OpenMINDS instances

    % Automatically generate a test case for each schema type
    properties (TestParameter)
        SchemaType = cellstr( enumeration('openminds.enum.Types') );
    end

    properties
        ItemPreSave  % Property to store the object created in the first test
        TempSavePath % Property to store the temporary save path
        CurrentSchemaType   % Property to store the current schema type being tested
    end

    methods (Test)
    
        function testCreateSchema(testCase, SchemaType)
            % Get the schema class name and function handle

            schemaType = openminds.enum.Types(SchemaType);
            schemaClassFunctionName = schemaType.ClassName;
            schemaFcn = str2func(schemaClassFunctionName);
            
            % Skip abstract classes
            mc = meta.class.fromName(schemaClassFunctionName);
            if isempty(mc) || mc.Abstract
                return;
            end

            % Attempt to create an object of the schema class
            instance = schemaFcn();
            testCase.assertInstanceOf(instance, 'openminds.abstract.Schema')

            testCase.verifyWarningFree( @(i)dispNoOutput(instance) )

            strRep = string(instance);
            testCase.verifyClass(strRep, 'string')

            % list instances if the type has controlled instances
            superClassNames = superclasses(schemaClassFunctionName);

            if any(ismember(superClassNames, ...
                    {'openminds.internal.mixin.HasControlledInstance', ...
                    'openminds.abstract.ControlledTerm'}))
                instances = feval(sprintf('%s.listInstances', schemaClassFunctionName));
                testCase.verifyClass(instances, 'string')
            end

            function dispNoOutput(instance) %#ok<INUSD>
                c = evalc('disp(instance)'); %#ok<NASGU>
            end
        end

        function testSaveLoadForSchema(testCase, SchemaType)
            % Test saving and loading for a specific schema type

            if strcmp( SchemaType, "None" ); return; end

            % Get the schema class name and function handle
            schemaType = openminds.enum.Types(SchemaType);
            schemaClassFunctionName = schemaType.ClassName;
            schemaFcn = str2func(schemaClassFunctionName);
            
            % Skip abstract classes
            mc = meta.class.fromName(schemaClassFunctionName);
            if isempty(mc) || mc.Abstract
                return;
            end

            % Attempt to create an object of the schema class
            try
                itemPreSave = schemaFcn();
            catch ME
                testCase.verifyFail(sprintf('Failed to create object for %s: %s', schemaClassFunctionName, ME.message));
                return;
            end
            
            % Define a temporary file path for saving the object
            tempsavepath = [tempname, '.mat'];
            cleanupObj = onCleanup(@() delete(tempsavepath)); % Ensure cleanup of the temp file

            % Attempt to save the object
            try
                save(tempsavepath, 'itemPreSave');
            catch ME
                testCase.verifyFail(sprintf('Failed to save object for %s: %s', schemaClassFunctionName, ME.message));
                return;
            end

            % Attempt to load the object
            try
                S = load(tempsavepath, 'itemPreSave');
            catch ME
                testCase.verifyFail(sprintf('Failed to load object for %s: %s', schemaClassFunctionName, ME.message));
                return;
            end
            
            % Verify that the loaded object matches the original object
            testCase.verifyEqual(S.itemPreSave, itemPreSave, ...
                sprintf('Loaded object does not match the original for %s', schemaClassFunctionName));
        end
    end
end
