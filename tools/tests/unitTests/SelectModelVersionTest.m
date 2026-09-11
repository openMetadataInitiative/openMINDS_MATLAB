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
        %
        % The two versions are numbered ones, which are pinned to a schema
        % commit and do not change, unlike latest. They are chosen for
        % what tells them apart: v5.0 declares AnatomicalAtlas, which v3.0
        % calls BrainAtlas. The first is selected here rather than assumed,
        % so that the test does not pass for nothing in a session that is
        % on v3.0 or v4.0 already.

            import ommtest.helper.ModelVersionFixture

            testCase.applyFixture(ModelVersionFixture("v5.0"))
            testCase.assertTrue(ismember("AnatomicalAtlas", typesInMemory()), ...
                'v5.0 is pinned and declares AnatomicalAtlas; something changed it.')

            % Held, as a session that has looked any type up holds it.
            openminds.introspection.internal.MetaTypeRegistry.getSingleton();

            testCase.applyFixture(ModelVersionFixture("v3.0"))

            membersInMemory = typesInMemory();

            testCase.verifyTrue(ismember("BrainAtlas", membersInMemory), ...
                'The Types enumeration in memory must be the selected version''s.')
            testCase.verifyFalse(ismember("AnatomicalAtlas", membersInMemory), ...
                'The previous version''s Types enumeration must not stay in memory.')
        end
    end
end

function names = typesInMemory()
% typesInMemory - The Types enumeration as loaded, not as on the path
    names = string({ ...
        meta.class.fromName("openminds.enum.Types").EnumerationMemberList.Name});
end
