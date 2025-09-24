classdef PreferencesTest < matlab.unittest.TestCase
%PreferencesTest Unit tests for the openMINDS Preferences utility
%
%   Tests the preferences system including singleton behavior, saving/loading,
%   property validation, and preference manipulation.

    properties (TestParameter)
        PropertyDisplayModeValues = {"all", "non-empty"}
        DocLinkTargetValues = {"help", "online"}
    end

    methods (TestMethodSetup)
        function backupPreferences(testCase)
            % Backup current preferences before each test
            prefs = openminds.utility.Preferences.getSingleton();
            
            % Store original values
            testCase.addTeardown(@() testCase.restorePreferences(...
                prefs.PropertyDisplayMode, prefs.DocLinkTarget));
        end
    end

    methods (Test)
        function testSingletonBehavior(testCase)
            % Test that Preferences implements singleton pattern
            prefs1 = openminds.utility.Preferences.getSingleton();
            prefs2 = openminds.utility.Preferences.getSingleton();
            
            % Should be the same object
            testCase.verifyTrue(prefs1 == prefs2);
            testCase.verifyEqual(prefs1, prefs2);
        end
        
        function testDefaultValues(testCase)
            % Test that preferences have correct default values
            prefs = openminds.utility.Preferences.getSingleton();
            
            % Reset to ensure defaults
            prefs.reset();
            
            % Check default values
            testCase.verifyEqual(prefs.PropertyDisplayMode, "all");
            testCase.verifyEqual(prefs.DocLinkTarget, "online");
        end
        
        function testPropertyDisplayModeValidation(testCase, PropertyDisplayModeValues)
            % Test PropertyDisplayMode property validation
            prefs = openminds.utility.Preferences.getSingleton();
            
            % Valid values should work
            prefs.PropertyDisplayMode = PropertyDisplayModeValues;
            testCase.verifyEqual(prefs.PropertyDisplayMode, PropertyDisplayModeValues);
            
            % Invalid values should error
            testCase.verifyError(...
                @() openminds.setpref('PropertyDisplayMode', "invalid"), ...
                'MATLAB:validators:mustBeMember');
        end
        
        function testDocLinkTargetValidation(testCase, DocLinkTargetValues)
            % Test DocLinkTarget property validation
            prefs = openminds.utility.Preferences.getSingleton();
            
            % Valid values should work
            prefs.DocLinkTarget = DocLinkTargetValues;
            testCase.verifyEqual(prefs.DocLinkTarget, DocLinkTargetValues);
            
            % Invalid values should error
            testCase.verifyError(...
                @() openminds.setpref('DocLinkTarget', "invalid"), ...
                'MATLAB:validators:mustBeMember');
        end
        
        function testPreferencePersistence(testCase)
            % Test that preference changes are saved and persist
            prefs = openminds.utility.Preferences.getSingleton();
            
            % Change preferences
            newMode = "non-empty";
            newTarget = "help";
            
            prefs.PropertyDisplayMode = newMode;
            prefs.DocLinkTarget = newTarget;
            
            % Clear singleton to force reload
            clearSingleton();
            
            % Get fresh instance
            newPrefs = openminds.utility.Preferences.getSingleton();
            
            % Verify values persisted
            testCase.verifyEqual(newPrefs.PropertyDisplayMode, newMode);
            testCase.verifyEqual(newPrefs.DocLinkTarget, newTarget);
        end
        
        function testResetFunctionality(testCase)
            % Test the reset method
            prefs = openminds.utility.Preferences.getSingleton();
            
            % Change preferences to non-default values
            prefs.PropertyDisplayMode = "non-empty";
            prefs.DocLinkTarget = "help";
            
            % Reset
            prefs.reset();
            
            % Verify back to defaults
            testCase.verifyEqual(prefs.PropertyDisplayMode, "all");
            testCase.verifyEqual(prefs.DocLinkTarget, "online");
        end
        
        function testGetPreferenceValueMethod(testCase)
            % Test the static getPreferenceValue method
            prefs = openminds.utility.Preferences.getSingleton();
            
            % Set known values
            prefs.PropertyDisplayMode = "non-empty";
            prefs.DocLinkTarget = "help";
            
            % Test static getter
            mode = openminds.utility.Preferences.getPreferenceValue("PropertyDisplayMode");
            target = openminds.utility.Preferences.getPreferenceValue("DocLinkTarget");
            
            testCase.verifyEqual(mode, "non-empty");
            testCase.verifyEqual(target, "help");
        end
        
        function testGetPreferenceValueInvalidName(testCase)
            % Test error handling for invalid preference name
            testCase.verifyError(...
                @() openminds.utility.Preferences.getPreferenceValue("InvalidPreference"), ...
                'openMINDS_MATLAB:Preferences:PreferenceDoesNotExist');
        end
        
        function testPreferenceFileLocation(testCase)
            % Test that preferences file is in expected location
            prefs = openminds.utility.Preferences.getSingleton();
            
            % Access private property using reflection
            mc = metaclass(prefs);
            filenameProp = findobj(mc.PropertyList, 'Name', 'Filename');
            
            if ~isempty(filenameProp)
                testCase.verifyTrue(contains(char(filenameProp.DefaultValue), 'openMINDSPreferences.mat'));
            end
        end
        
        function testCustomDisplayBehavior(testCase)
            % Test that preferences display correctly
            prefs = openminds.utility.Preferences.getSingleton(); %#ok<NASGU>
            
            % Test that object can be displayed without error
            try
                C = evalc('disp(prefs)'); % Capture output to avoid console spam
                testCase.verifyTrue(true); % If we get here, display worked
            catch ME
                testCase.verifyFail(['Display failed: ' ME.message]);
            end
            
            % Verify that the display contains the expected header text
            testCase.verifyTrue(contains(C, 'for the openMINDS Metadata Toolbox'))
        end
    end
    
    methods (Access = private)
        function restorePreferences(~, originalMode, originalTarget)
            % Restore preferences to original values
            prefs = openminds.utility.Preferences.getSingleton();
            prefs.PropertyDisplayMode = originalMode;
            prefs.DocLinkTarget = originalTarget;
        end
    end
end

% Helper function to clear singleton for testing
function clearSingleton()
    % Clear the persistent variable in getSingleton method
    clear openminds.utility.Preferences
end
