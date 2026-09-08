classdef MixedTypePropertyTest < matlab.unittest.TestCase
% MixedTypePropertyTest - How a mixed type property reads, takes assignments
% and raises change events, without indexing overrides on Node
%
%   A property that allows several types holds a mixed type set. Indexing
%   the set hands out the instances themselves, as one array when they
%   share a type, and dot indexing forwards to them, so the property reads
%   and writes like an array of its instances whatever types it holds.

    properties (Constant)
        PersonClass = "openminds.core.actors.Person"
        OrganizationClass = "openminds.core.actors.Organization"
    end

    methods (Test) % Reading
        function testPropertyHoldsASet(testCase)
            contribution = testCase.contributionWith(testCase.twoPersons());

            testCase.verifyTrue(openminds.utility.isMixedInstance(contribution.contributor))
            testCase.verifyLength(contribution.contributor, 2)
        end

        function testHomogeneousListIndexesAsAnArray(testCase)
            contribution = testCase.contributionWith(testCase.twoPersons());

            testCase.verifyClass(contribution.contributor(:), testCase.PersonClass)
            testCase.verifyClass(contribution.contributor(1), testCase.PersonClass)
            testCase.verifyEqual([contribution.contributor.givenName], ["Ada", "Alan"])
        end

        function testEmptyListIsTheEmptySet(testCase)
            contribution = openminds.core.Contribution();

            testCase.verifyEmpty(contribution.contributor)
            testCase.verifyTrue(openminds.utility.isMixedInstance(contribution.contributor))
        end

        function testHeterogeneousElementIsTheInstance(testCase)
            contribution = testCase.contributionWith(testCase.personAndOrganization());

            testCase.verifyClass(contribution.contributor(1), testCase.PersonClass)
            testCase.verifyClass(contribution.contributor(2), testCase.OrganizationClass)
            testCase.verifyEqual(contribution.contributor(1).givenName, "Ada")
            testCase.verifyEqual(contribution.contributor(2).name, "Bletchley Park")
        end

        function testHeterogeneousSelectionStaysASet(testCase)
            contribution = testCase.contributionWith(testCase.personAndOrganization());

            testCase.verifyTrue(openminds.utility.isMixedInstance(contribution.contributor(1:2)))
            testCase.verifyLength(contribution.contributor(1:2), 2)
        end

        function testHeterogeneousElementMethodIsTheInstanceMethod(testCase)
            contribution = testCase.contributionWith(testCase.personAndOrganization());

            testCase.verifyEqual(contribution.contributor(2).getTypeIRI(), ...
                openminds.core.Organization.X_TYPE)
        end

        function testScalarPropertyIndexesAsTheInstance(testCase)
            datasetVersion = openminds.core.DatasetVersion();
            datasetVersion.digitalIdentifier = openminds.core.DOI( ...
                "identifier", "https://doi.org/10.1234/abc");

            testCase.verifyClass(datasetVersion.digitalIdentifier(1), "openminds.core.digitalidentifier.DOI")
            testCase.verifyEqual(datasetVersion.digitalIdentifier.identifier, ...
                "https://doi.org/10.1234/abc")
        end

        function testForLoopYieldsInstances(testCase)
            contribution = testCase.contributionWith(testCase.personAndOrganization());

            classes = strings(1, 0);
            for instance = contribution.contributor
                classes(end+1) = class(instance); %#ok<AGROW>
            end
            testCase.verifyEqual(classes, [testCase.PersonClass, testCase.OrganizationClass])
        end
    end

    methods (Test) % Assigning
        function testAppendingAnotherTypeToHomogeneousList(testCase)
            contribution = testCase.contributionWith(testCase.twoPersons());

            contribution.contributor(end+1) = openminds.core.Organization("name", "Bletchley Park");
            testCase.verifyLength(contribution.contributor, 3)
            testCase.verifyClass(contribution.contributor(3), testCase.OrganizationClass)
        end

        function testAppendingToEmptyProperty(testCase)
            contribution = openminds.core.Contribution();

            contribution.contributor(end+1) = openminds.core.Person("givenName", "Ada");
            testCase.verifyLength(contribution.contributor, 1)
            testCase.verifyClass(contribution.contributor(1), testCase.PersonClass)
        end

        function testConcatenatingSetAndInstance(testCase)
            contribution = testCase.contributionWith(testCase.twoPersons());

            contribution.contributor = [contribution.contributor, ...
                openminds.core.Organization("name", "Bletchley Park")];
            testCase.verifyLength(contribution.contributor, 3)
        end

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

        function testDeletingAnElement(testCase)
            contribution = testCase.contributionWith(testCase.twoPersons());

            contribution.contributor(1) = [];
            testCase.verifyLength(contribution.contributor, 1)
            testCase.verifyEqual(contribution.contributor.givenName, "Alan")
        end

        function testElementOfOneSetIsAcceptedByAnother(testCase)
            source = testCase.contributionWith(testCase.personAndOrganization());
            target = openminds.core.Contribution();

            target.contributor = source.contributor(2);
            testCase.verifyClass(target.contributor(1), testCase.OrganizationClass)
        end

        function testTypeNotAllowedIsRefused(testCase)
            contribution = openminds.core.Contribution();

            testCase.verifyError(@() assignAt(contribution, 1, openminds.core.Subject()), ...
                ?MException)
        end

        function testGapInListIsRefused(testCase)
            contribution = testCase.contributionWith(testCase.twoPersons());

            testCase.verifyError(@() assignAt(contribution, 5, openminds.core.Person("givenName", "Grace")), ...
                'openMINDS:MixedTypeSet:GapInList')
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
            testCase.verifySameHandle(eventData.NewValue(1), person)
            testCase.verifySameHandle(eventData.IsPropertyOf, contribution)
        end

        function testAssignmentThroughLinkReportedByLinkedInstance(testCase)
            person = openminds.core.Person("givenName", "Ada");
            contribution = testCase.contributionWith(person);
            receivedByParent = testCase.listenTo(contribution, 'PropertyWithLinkedInstanceChanged');
            receivedByPerson = testCase.listenTo(person, 'InstanceChanged');

            contribution.contributor.givenName = "Grace";

            testCase.verifyEmpty(receivedByParent())
            eventData = receivedByPerson();
            testCase.assertNotEmpty(eventData)
            testCase.verifyEqual(eventData.OldValue, "Ada")
            testCase.verifyEqual(eventData.NewValue, "Grace")
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

function assignAt(contribution, index, instance)
    contribution.contributor(index) = instance;
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
