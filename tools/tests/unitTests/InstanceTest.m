classdef InstanceTest < matlab.unittest.TestCase
% InstanceTest - Unit test for creation and save/load of OpenMINDS instances

    % Automatically generate a test case for each metadata type
    properties (TestParameter)
        MetadataType = cellstr( enumeration('openminds.enum.Types') );
    end

    methods (Test)
    
        function testCreateType(testCase, MetadataType)
            % Get class constructor for metadata type
            metadataType = openminds.enum.Types(MetadataType);
            typeConstructor = str2func( metadataType.ClassName );
            
            % Skip abstract classes
            mc = meta.class.fromName( metadataType.ClassName );
            if isempty(mc) || mc.Abstract
                return;
            end

            % Attempt to create an object of the type class for a metadata schema
            instance = typeConstructor();
            testCase.assertInstanceOf(instance, 'openminds.abstract.Schema')

            testCase.verifyWarningFree( @(i)dispNoOutput(instance) )

            strRep = string(instance);
            testCase.verifyClass(strRep, 'string')

            % list instances if the type has controlled instances
            superClassNames = superclasses(metadataType.ClassName);

            if any(ismember(superClassNames, ...
                    {'openminds.internal.mixin.HasControlledInstance', ...
                    'openminds.abstract.ControlledTerm'}))
                instances = feval(sprintf('%s.listInstances', metadataType.ClassName));
                if ~isempty(instances)
                    testCase.verifyClass(instances, 'string')
                end
            end

            function dispNoOutput(instance) %#ok<INUSD>
                c = evalc('disp(instance)'); %#ok<NASGU>
            end
        end

        function testSaveLoadForTypedInstance(testCase, MetadataType)
            % Test saving and loading for a specific metadata type

            if strcmp( MetadataType, "None" ); return; end

            % Get class constructor for metadata type
            metadataType = openminds.enum.Types(MetadataType);
            typeConstructor = str2func( metadataType.ClassName );

            % Skip abstract classes
            mc = meta.class.fromName(metadataType.ClassName);
            if isempty(mc) || mc.Abstract
                return;
            end

            % Attempt to create an object of the type class for a metadata schema
            try
                itemPreSave = typeConstructor();
            catch ME
                testCase.verifyFail(...
                    sprintf('Failed to create object for %s: %s', ...
                    metadataType.ClassName, ME.message));
                return;
            end
            
            % Define a temporary file path for saving the object
            tempsavepath = [tempname, '.mat'];
            cleanupObj = onCleanup(@() delete(tempsavepath)); % Ensure cleanup of the temp file

            % Attempt to save the object
            try
                save(tempsavepath, 'itemPreSave');
            catch ME
                testCase.verifyFail(...
                    sprintf('Failed to save object for %s: %s', ...
                    metadataType.ClassName, ME.message));
                return;
            end

            % Attempt to load the object
            try
                S = load(tempsavepath, 'itemPreSave');
            catch ME
                testCase.verifyFail(...
                    sprintf('Failed to load object for %s: %s', ...
                    metadataType.ClassName, ME.message));
                return;
            end
            
            % Verify that the loaded object matches the original object
            testCase.verifyEqual(S.itemPreSave, itemPreSave, ...
                sprintf('Loaded object does not match the original for %s', metadataType.ClassName));
        end
    end
end
