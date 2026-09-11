classdef SelectModelVersionTest < matlab.unittest.TestCase
% SelectModelVersionTest - Tests for selecting a model version within a session
%
%   A model version is selected by putting its generated classes on the
%   search path. MATLAB reads a class definition from the path again only
%   once nothing holds an instance of it, so anything the toolbox itself
%   keeps across a switch pins the classes of the previous version.

    methods (Test)
        function testTheTypeRegistryDoesNotPinThePreviousVersion(testCase)
        % The type registry holds enumeration values of the version it was
        % built for. Left in place across a switch, it kept the previous
        % version's Types enumeration in memory, and the instance library
        % then resolved the selected version's instances against it: every
        % type the two versions do not share came out untyped.

            % Held, as a session that has looked any type up holds it.
            openminds.introspection.internal.MetaTypeRegistry.getSingleton();

            testCase.applyFixture(ommtest.helper.ModelVersionFixture("v3.0"))

            % BrainAtlas is declared by v3.0 and not by v5.0 or latest,
            % where it became AnatomicalAtlas. meta.class reports the
            % enumeration in memory, not the one on the path.
            membersInMemory = string({ ...
                meta.class.fromName("openminds.enum.Types").EnumerationMemberList.Name});

            testCase.verifyTrue(ismember("BrainAtlas", membersInMemory), ...
                'The Types enumeration in memory must be the selected version''s.')
            testCase.verifyFalse(ismember("AnatomicalAtlas", membersInMemory), ...
                'The previous version''s Types enumeration must not stay in memory.')
        end
    end
end
