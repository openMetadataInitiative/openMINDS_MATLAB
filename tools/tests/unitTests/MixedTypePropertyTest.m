classdef MixedTypePropertyTest < matlab.unittest.TestCase
% MixedTypePropertyTest - What a mixed type property hands out, and how it
% takes assignments and raises change events, without indexing overrides
%
%   A property that allows several types stores a mixed type set. The
%   generated get method hands out the held instances as one array when
%   they share a type, and the set itself otherwise. The set forwards dot
%   indexing to the instances, so both cases index the same way.

    properties (Constant)
        PersonClass = "openminds.core.actors.Person"
        OrganizationClass = "openminds.core.actors.Organization"
    end

    methods (Test) % Reading
        function testHomogeneousListIsHandedOutAsInstances(testCase)
            contribution = testCase.contributionWith(testCase.twoPersons());

            contributors = contribution.contributor;
            testCase.verifyClass(contributors, testCase.PersonClass)
            testCase.verifyLength(contributors, 2)
            testCase.verifyEqual([contributors.givenName], ["Ada", "Alan"])
        end

        function testEmptyListIsTheEmptySet(testCase)
            contribution = openminds.core.Contribution();

            testCase.verifyEmpty(contribution.contributor)
            testCase.verifyTrue(openminds.utility.isMixedInstance(contribution.contributor))
        end

        function testHeterogeneousListStaysASet(testCase)
            contribution = testCase.contributionWith(testCase.personAndOrganization());

            testCase.verifyTrue(openminds.utility.isMixedInstance(contribution.contributor))
            testCase.verifyLength(contribution.contributor, 2)
        end

        function testHeterogeneousElementForwardsProperties(testCase)
            contribution = testCase.contributionWith(testCase.personAndOrganization());

            testCase.verifyEqual(contribution.contributor(1).givenName, "Ada")
            testCase.verifyEqual(contribution.contributor(2).name, "Bletchley Park")
        end

        function testHeterogeneousElementForwardsMethods(testCase)
            contribution = testCase.contributionWith(testCase.personAndOrganization());

            testCase.verifyEqual(contribution.contributor(2).getTypeIRI(), ...
                openminds.core.Organization.X_TYPE)
        end

        function testScalarPropertyIsHandedOutAsInstance(testCase)
            datasetVersion = openminds.core.DatasetVersion();
            datasetVersion.digitalIdentifier = openminds.core.DOI( ...
                "identifier", "https://doi.org/10.1234/abc");

            testCase.verifyClass(datasetVersion.digitalIdentifier, "openminds.core.digitalidentifier.DOI")
            testCase.verifyEqual(datasetVersion.digitalIdentifier.identifier, ...
                "https://doi.org/10.1234/abc")
        end
    end

    methods (Test) % Assigning
        function testAssignmentThroughElementReachesInstance(testCase)
            persons = testCase.twoPersons();
            contribution = testCase.contributionWith(persons);

            contribution.contributor(2).givenName = "Changed";
            testCase.verifyEqual(persons(2).givenName, "Changed")
        end

        function testAssignmentThroughHeterogeneousElementReachesInstance(testCase)
            instances = testCase.personAndOrganization();
            contribution = testCase.contributionWith(instances);

            contribution.contributor(2).name = "Changed";
            testCase.verifyEqual(instances{2}.name, "Changed")
        end

        function testIndexedAssignmentGrowsHeterogeneousList(testCase)
            contribution = testCase.contributionWith(testCase.personAndOrganization());

            contribution.contributor(3) = openminds.core.Person("givenName", "Grace");
            testCase.verifyLength(contribution.contributor, 3)
            testCase.verifyEqual(contribution.contributor(3).givenName, "Grace")
        end

        function testElementOfOneSetIsAcceptedByAnother(testCase)
            source = testCase.contributionWith(testCase.personAndOrganization());
            target = openminds.core.Contribution();

            target.contributor = source.contributor(2);
            testCase.verifyClass(target.contributor, testCase.OrganizationClass)
        end

        function testListOfMixedTypesRefusesDeeperIndexing(testCase)
            % One dot on a list gives one value per element, as for an
            % array. Indexing further into each of them is refused.
            contribution = testCase.contributionWith(testCase.personAndOrganization());

            testCase.verifyError(@() contribution.contributor(1:2).givenName(1), ...
                'openMINDS:MixedTypeSet:IndexingIntoList')
        end
    end

    methods (Test) % Change events
        function testInstanceChangedCarriesOldAndNewValue(testCase)
            person = openminds.core.Person("givenName", "Ada");
            received = testCase.listenTo(person, 'InstanceChanged');

            person.givenName = "Grace";

            eventData = received();
            testCase.assertNotEmpty(eventData)
            testCase.verifyEqual(eventData.OldValue, "Ada")
            testCase.verifyEqual(eventData.NewValue, "Grace")
            testCase.verifyFalse(eventData.IsLinkedProperty)
            testCase.verifySameHandle(eventData.IsPropertyOf, person)
        end

        function testLinkedPropertyChangedOnDirectAssignment(testCase)
            contribution = openminds.core.Contribution();
            received = testCase.listenTo(contribution, 'PropertyWithLinkedInstanceChanged');
            person = openminds.core.Person("givenName", "Ada");

            contribution.contributor = person;

            eventData = received();
            testCase.assertNotEmpty(eventData)
            testCase.verifyTrue(eventData.IsLinkedProperty)
            testCase.verifySameHandle(eventData.NewValue, person)
            testCase.verifySameHandle(eventData.IsPropertyOf, contribution)
        end

        function testAssignmentThroughLinkReportedByLinkedInstance(testCase)
            person = openminds.core.Person("givenName", "Ada");
            contribution = testCase.contributionWith(person);
            receivedByParent = testCase.listenTo(contribution, 'PropertyWithLinkedInstanceChanged');
            receivedByPerson = testCase.listenTo(person, 'InstanceChanged');

            contribution.contributor.givenName = "Grace";

            testCase.verifyEmpty(receivedByParent())
            testCase.verifyEqual(receivedByPerson().NewValue, "Grace")
        end

        function testNoEventWithoutListenerLeavesNoTrace(testCase)
            % Assigning with nobody listening must be silent and must not
            % record a stale old value for a later listener to report.
            person = openminds.core.Person("givenName", "Ada");
            person.givenName = "Alan";
            received = testCase.listenTo(person, 'InstanceChanged');

            person.givenName = "Grace";

            testCase.verifyEqual(received().OldValue, "Alan")
        end
    end

    methods (Access = private)
        function contribution = contributionWith(~, contributors)
            contribution = openminds.core.Contribution("contributor", contributors);
        end

        function persons = twoPersons(~)
            persons = [ ...
                openminds.core.Person("givenName", "Ada", "familyName", "Lovelace"), ...
                openminds.core.Person("givenName", "Alan", "familyName", "Turing")];
        end

        function instances = personAndOrganization(~)
            instances = { ...
                openminds.core.Person("givenName", "Ada", "familyName", "Lovelace"), ...
                openminds.core.Organization("name", "Bletchley Park")};
        end

        function received = listenTo(~, node, eventName)
        % listenTo - Record the last event data raised on node, readable
        % through the returned function. The listener lives with the node.
            store = containers.Map('KeyType', 'char', 'ValueType', 'any');
            addlistener(node, eventName, @(~, eventData) recordLast(store, eventData));
            received = @() lastOrEmpty(store);
        end
    end
end

function recordLast(store, eventData)
    store('last') = eventData; %#ok<NASGU> store is a handle, so the caller sees this
end

function eventData = lastOrEmpty(store)
    if store.isKey('last')
        eventData = store('last');
    else
        eventData = [];
    end
end
