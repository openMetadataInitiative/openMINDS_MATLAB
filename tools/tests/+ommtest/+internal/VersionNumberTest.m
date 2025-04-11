classdef VersionNumberTest < matlab.unittest.TestCase
    % VERSIONNUMBERTEST Tests for the VersionNumber class
    %
    % This test suite verifies the functionality of the openminds.internal.utility.VersionNumber
    % class, which handles semantic versioning with Major.Minor.Patch.Build components.
    
    properties
        % Common version numbers used across tests
        Version1_0_0
        Version2_1_0
        Version2_1_3
        Version2_1_3_5
        LatestVersion
        MissingVersion
    end
    
    methods(TestMethodSetup)
        function createVersions(testCase)
            % Create common version objects for use in tests
            import openminds.internal.utility.VersionNumber
            
            testCase.Version1_0_0 = openminds.internal.utility.VersionNumber('1.0.0');
            testCase.Version2_1_0 = openminds.internal.utility.VersionNumber('2.1.0');
            testCase.Version2_1_3 = openminds.internal.utility.VersionNumber('2.1.3');
            testCase.Version2_1_3_5 = openminds.internal.utility.VersionNumber('2.1.3.5');
            testCase.LatestVersion = openminds.internal.utility.VersionNumber('latest');
            testCase.MissingVersion = openminds.internal.utility.VersionNumber(missing);
        end
    end
    
    methods(Test)
        function testConstructorWithString(testCase)
            % Test constructor with string inputs
            import openminds.internal.utility.VersionNumber
            
            % Test basic version string
            v = openminds.internal.utility.VersionNumber('1.2.3');
            testCase.verifyEqual(v.Major, uint8(1));
            testCase.verifyEqual(v.Minor, uint8(2));
            testCase.verifyEqual(v.Patch, uint8(3));
            testCase.verifyEqual(v.Build, uint8(0));
            
            % Test with 'v' prefix
            v = openminds.internal.utility.VersionNumber('v1.2.3');
            testCase.verifyEqual(v.Major, uint8(1));
            testCase.verifyEqual(v.Minor, uint8(2));
            testCase.verifyEqual(v.Patch, uint8(3));
            
            % Test with build number
            v = openminds.internal.utility.VersionNumber('1.2.3.4');
            testCase.verifyEqual(v.Major, uint8(1));
            testCase.verifyEqual(v.Minor, uint8(2));
            testCase.verifyEqual(v.Patch, uint8(3));
            testCase.verifyEqual(v.Build, uint8(4));
            
            % Test with partial version
            v = openminds.internal.utility.VersionNumber('1.2');
            testCase.verifyEqual(v.Major, uint8(1));
            testCase.verifyEqual(v.Minor, uint8(2));
            testCase.verifyEqual(v.Patch, uint8(0));
            testCase.verifyEqual(v.Build, uint8(0));
            
            % Test with single number
            v = openminds.internal.utility.VersionNumber('1');
            testCase.verifyEqual(v.Major, uint8(1));
            testCase.verifyEqual(v.Minor, uint8(0));
            testCase.verifyEqual(v.Patch, uint8(0));
            testCase.verifyEqual(v.Build, uint8(0));
        end
        
        function testConstructorWithNumeric(testCase)
            % Test constructor with numeric inputs
            import openminds.internal.utility.VersionNumber
            
            % Test with array of numbers
            v = openminds.internal.utility.VersionNumber([1, 2, 3]);
            testCase.verifyEqual(v.Major, uint8(1));
            testCase.verifyEqual(v.Minor, uint8(2));
            testCase.verifyEqual(v.Patch, uint8(3));
            testCase.verifyEqual(v.Build, uint8(0));
            
            % Test with array including build
            v = openminds.internal.utility.VersionNumber([1, 2, 3, 4]);
            testCase.verifyEqual(v.Major, uint8(1));
            testCase.verifyEqual(v.Minor, uint8(2));
            testCase.verifyEqual(v.Patch, uint8(3));
            testCase.verifyEqual(v.Build, uint8(4));
            
            % Test with single number
            v = openminds.internal.utility.VersionNumber(1);
            testCase.verifyEqual(v.Major, uint8(1));
            testCase.verifyEqual(v.Minor, uint8(0));
            testCase.verifyEqual(v.Patch, uint8(0));
            testCase.verifyEqual(v.Build, uint8(0));
        end
        
        function testConstructorWithSpecialValues(testCase)
            % Test constructor with special values
            import openminds.internal.utility.VersionNumber
            
            % Test 'latest' version
            v = openminds.internal.utility.VersionNumber('latest');
            testCase.verifyTrue(v.IsLatest);
            testCase.verifyEqual(v.Major, uint8(255));
            
            % Test missing version
            v = openminds.internal.utility.VersionNumber(missing);
            testCase.verifyTrue(v.IsMissing);
        end
        
        function testConstructorWithMultipleVersions(testCase)
            % Test constructor with multiple versions
            import openminds.internal.utility.VersionNumber
            
            % Test with cell array of versions
            versions = openminds.internal.utility.VersionNumber({'1.0.0', '2.1.0', '3.2.1'});
            testCase.verifyLength(versions, 3);
            testCase.verifyEqual(versions(1).Major, uint8(1));
            testCase.verifyEqual(versions(2).Major, uint8(2));
            testCase.verifyEqual(versions(3).Major, uint8(3));
            
            % Test with mixed types
            versions = openminds.internal.utility.VersionNumber({'1.0.0', [2, 1, 0], 'latest'});
            testCase.verifyLength(versions, 3);
            testCase.verifyEqual(versions(1).Major, uint8(1));
            testCase.verifyEqual(versions(2).Major, uint8(2));
            testCase.verifyTrue(versions(3).IsLatest);
        end
        
        function testConstructorWithOptions(testCase)
            % Test constructor with options
            import openminds.internal.utility.VersionNumber
            
            % Test with Format option
            v = openminds.internal.utility.VersionNumber('1.2.3', 'Format', 'vX.Y');
            testCase.verifyEqual(v.Format, "vX.Y");
            testCase.verifyEqual(string(v), "v1.2");
            
            % Test with IsLatest option
            v = openminds.internal.utility.VersionNumber('1.2.3', 'IsLatest', true);
            testCase.verifyTrue(v.IsLatest);
            testCase.verifyEqual(string(v), "latest");
        end
        
        function testInvalidVersionString(testCase)
            % Test invalid version string
            import openminds.internal.utility.VersionNumber
            
            % Test with invalid version string
            testCase.verifyError(@() openminds.internal.utility.VersionNumber('1.2.a'), '');
            testCase.verifyError(@() openminds.internal.utility.VersionNumber('1.2.3-alpha'), '');
            testCase.verifyError(@() openminds.internal.utility.VersionNumber('not-a-version'), '');
        end
        
        function testStringConversion(testCase)
            % Test string conversion methods
            
            % Test default format (X.Y.Z)
            testCase.verifyEqual(string(testCase.Version1_0_0), "1.0.0");
            testCase.verifyEqual(string(testCase.Version2_1_3), "2.1.3");
            
            % Test with build number
            testCase.verifyEqual(string(testCase.Version2_1_3_5), "2.1.3");
            
            % Test with custom format
            v = testCase.Version2_1_3;
            v.Format = 'X.Y';
            testCase.verifyEqual(string(v), "2.1");
            
            v.Format = 'vX.Y.Z';
            testCase.verifyEqual(string(v), "v2.1.3");
            
            v.Format = 'X.Y.Z.B';
            testCase.verifyEqual(string(v), "2.1.3.0");
            
            % Test special versions
            testCase.verifyEqual(string(testCase.LatestVersion), "latest");
            testCase.verifyEqual(string(testCase.MissingVersion), "missing");
            
            % Test char conversion
            testCase.verifyEqual(char(testCase.Version1_0_0), '1.0.0');
        end
        
        function testNumericConversion(testCase)
            % Test numeric conversion
            
            % Test double conversion
            testCase.verifyEqual(double(testCase.Version1_0_0), uint8([1, 0, 0, 0]));
            testCase.verifyEqual(double(testCase.Version2_1_3), uint8([2, 1, 3, 0]));
            testCase.verifyEqual(double(testCase.Version2_1_3_5), uint8([2, 1, 3, 5]));
        end
        
        function testVersionBumping(testCase)
            % Test version bumping methods
            import openminds.internal.utility.VersionNumber
            
            % Test bumpMajor
            v = openminds.internal.utility.VersionNumber('2.1.3');
            v.bumpMajor();
            testCase.verifyEqual(double(v), uint8([3, 0, 0, 0]));
            
            % Test bumpMinor
            v = openminds.internal.utility.VersionNumber('2.1.3');
            v.bumpMinor();
            testCase.verifyEqual(double(v), uint8([2, 2, 0, 0]));
            
            % Test bumpPatch
            v = openminds.internal.utility.VersionNumber('2.1.3');
            v.bumpPatch();
            testCase.verifyEqual(double(v), uint8([2, 1, 4, 0]));
            
            % Test bumpBuild
            v = openminds.internal.utility.VersionNumber('2.1.3');
            v.bumpBuild();
            testCase.verifyEqual(double(v), uint8([2, 1, 3, 1]));
            
            % Test cascading resets
            v = openminds.internal.utility.VersionNumber('2.1.3.5');
            v.bumpMajor();
            testCase.verifyEqual(double(v), uint8([3, 0, 0, 0]));
            
            v = openminds.internal.utility.VersionNumber('2.1.3.5');
            v.bumpMinor();
            testCase.verifyEqual(double(v), uint8([2, 2, 0, 0]));
            
            v = openminds.internal.utility.VersionNumber('2.1.3.5');
            v.bumpPatch();
            testCase.verifyEqual(double(v), uint8([2, 1, 4, 0]));
        end
        
        function testComparisonOperators(testCase)
            % Test comparison operators
            
            % Test equality (==)
            testCase.verifyTrue(testCase.Version1_0_0 == testCase.Version1_0_0);
            testCase.verifyFalse(testCase.Version1_0_0 == testCase.Version2_1_0);
            
            % Test inequality (~=)
            testCase.verifyTrue(testCase.Version1_0_0 ~= testCase.Version2_1_0);
            testCase.verifyFalse(testCase.Version1_0_0 ~= testCase.Version1_0_0);
            
            % Test less than (<)
            testCase.verifyTrue(testCase.Version1_0_0 < testCase.Version2_1_0);
            testCase.verifyFalse(testCase.Version2_1_0 < testCase.Version1_0_0);
            
            % Test less than or equal (<=)
            testCase.verifyTrue(testCase.Version1_0_0 <= testCase.Version2_1_0);
            testCase.verifyTrue(testCase.Version1_0_0 <= testCase.Version1_0_0);
            testCase.verifyFalse(testCase.Version2_1_0 <= testCase.Version1_0_0);
            
            % Test greater than (>)
            testCase.verifyTrue(testCase.Version2_1_0 > testCase.Version1_0_0);
            testCase.verifyFalse(testCase.Version1_0_0 > testCase.Version2_1_0);
            
            % Test greater than or equal (>=)
            testCase.verifyTrue(testCase.Version2_1_0 >= testCase.Version1_0_0);
            testCase.verifyTrue(testCase.Version1_0_0 >= testCase.Version1_0_0);
            testCase.verifyFalse(testCase.Version1_0_0 >= testCase.Version2_1_0);
            
            % Test with build numbers
            v1 = openminds.internal.utility.VersionNumber('2.1.3');
            v2 = openminds.internal.utility.VersionNumber('2.1.3.5');
            testCase.verifyTrue(v2 > v1);
            testCase.verifyTrue(v1 < v2);
            
            % Test with latest version
            testCase.verifyTrue(testCase.LatestVersion > testCase.Version2_1_3);
            testCase.verifyTrue(testCase.LatestVersion >= testCase.Version2_1_3);
            testCase.verifyFalse(testCase.LatestVersion < testCase.Version2_1_3);
            testCase.verifyFalse(testCase.LatestVersion <= testCase.Version2_1_3);
            
            % Test latest with latest
            v1 = openminds.internal.utility.VersionNumber('latest');
            v2 = openminds.internal.utility.VersionNumber('latest');
            testCase.verifyTrue(v1 == v2);
            testCase.verifyFalse(v1 ~= v2);
        end
        
        function testValidateVersion(testCase)
            % Test validateVersion static method
            import openminds.internal.utility.VersionNumber
            
            % Create valid versions
            validVersions = [
                openminds.internal.utility.VersionNumber('1.0.0')
                openminds.internal.utility.VersionNumber('2.0.0')
                openminds.internal.utility.VersionNumber('3.0.0')
            ];
            
            % Test with valid version
            testVersion = openminds.internal.utility.VersionNumber('2.0.0');
            testCase.verifyWarningFree(...
                @() VersionNumber.validateVersion(testVersion, validVersions));
            
            % Test with invalid version
            testVersion = openminds.internal.utility.VersionNumber('4.0.0');
            testCase.verifyError(@() VersionNumber.validateVersion(testVersion, validVersions), 'VersionNumber:InvalidVersion');
        end
        
        function testIsMissing(testCase)
            % Test ismissing method
            
            % Test with missing version
            testCase.verifyTrue(ismissing(testCase.MissingVersion));
            
            % Test with non-missing version
            testCase.verifyFalse(ismissing(testCase.Version1_0_0));
            testCase.verifyFalse(ismissing(testCase.LatestVersion));
        end
    end
    
end
