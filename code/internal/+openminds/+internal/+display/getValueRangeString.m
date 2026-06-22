function str = getValueRangeString(minValue, maxValue, minValueUnit, maxValueUnit)
% getValueRangeString - Format a quantitative value range with units.
    
    if isa(minValueUnit, 'openminds.controlledterms.UnitOfMeasurement')
        minValueUnit = minValueUnit.name;
    end
    if isa(maxValueUnit, 'openminds.controlledterms.UnitOfMeasurement')
        minValueUnit = maxValueUnit.name;
    end
    
    minValueUnit = string(minValueUnit); maxValueUnit = string(maxValueUnit);

    if minValueUnit == maxValueUnit
        str = sprintf('%d-%d %s', minValue, maxValue, pluralizeUnit(minValueUnit));
    else
        if minValue ~= 1
            minValueUnit = pluralizeUnit(minValueUnit);
        end
        if maxValue ~= 1
            maxValueUnit = pluralizeUnit(maxValueUnit);
        end
        str = sprintf('%d %s - %d %s', minValue, minValueUnit, maxValue, maxValueUnit);
    end
end

function pluralUnitName = pluralizeUnit(unitName)
    % List of exceptions not guaranteed to be complete.
    switch unitName
        case {"hertz", "siemens"}
            pluralUnitName = unitName;
        case "degree Celsius"
            pluralUnitName = "degrees Celsius";
        otherwise
            pluralUnitName = unitName + "s";
    end
end
