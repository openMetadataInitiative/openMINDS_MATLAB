function collection = buildFixtureCollection()
%buildFixtureCollection Canonical instance graph used by the fixture tests
%
%   collection = ommtest.helper.buildFixtureCollection() returns a
%   collection covering the structural features that serialization has to
%   get right: a scalar string, a string list, a linked instance, an
%   embedded instance, a controlled instance reference, a date, and a
%   number.
%
%   Every instance is given an explicit identifier so the serialized
%   document is byte-for-byte reproducible. Without that, blank node
%   identifiers are random and no golden file could be compared.
%
%   This function is the single definition of the fixture content. The
%   golden files are generated from it by
%   ommtest.helper.regenerateFixtures, so refreshing fixtures after a model
%   version bump is one command plus a review of the diff.
%
%   Output Arguments:
%     collection - An openminds.Collection holding the fixture graph.
%
%   See also ommtest.helper.regenerateFixtures

    baseIRI = "https://openminds.om-i.org/instances/matlabTestFixture/";

    contactInformation = openminds.core.ContactInformation( ...
        'id', baseIRI + "contact-001");
    contactInformation.email = "ada@example.org";

    person = openminds.core.Person('id', baseIRI + "person-001");
    person.givenName = "Ada";
    person.familyName = "Lovelace";
    person.alternateName = ["A. Lovelace", "Ada L."];
    person.contactInformation = contactInformation;

    quantitativeValue = openminds.core.QuantitativeValue();
    quantitativeValue.value = 42;
    quantitativeValue.unit = ommtest.helper.controlledInstance( ...
        "openminds.controlledterms.UnitOfMeasurement", "day");

    specimenAge = openminds.core.SpecimenAge();
    specimenAge.age = quantitativeValue;
    specimenAge.reference = ommtest.helper.controlledInstance( ...
        "openminds.controlledterms.AgeReference", "birth");

    subjectState = openminds.core.SubjectState('id', baseIRI + "subjectState-001");
    subjectState.age = specimenAge;

    subject = openminds.core.Subject('id', baseIRI + "subject-001");
    subject.lookupLabel = "fixtureSubject";
    subject.species = ommtest.helper.controlledInstance( ...
        "openminds.controlledterms.Species", "Homo sapiens");
    subject.studiedState = subjectState;

    collection = openminds.Collection(person, subject);
end
