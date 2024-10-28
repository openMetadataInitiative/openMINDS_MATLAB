function pvl = propertyValueListWithNestedEmbeddings()

    % Create a StringProperty

    % Create a NumericalProperty

    % Create a QuantitativeValue
    
    stringValue = openminds.core.research.StringProperty('name', 'MyParameter', 'value', 'A');

    ageUnit = openminds.controlledterms.UnitOfMeasurement('day');
    qvA = openminds.core.miscellaneous.QuantitativeValue('unit', ageUnit, 'value', 5);

    numberValue = openminds.core.research.NumericalProperty('name', 'AgeParameter', 'value', qvA);
    
    pvl = openminds.core.research.PropertyValueList('propertyValuePair', {stringValue, numberValue});
    
    disp(pvl)
end
