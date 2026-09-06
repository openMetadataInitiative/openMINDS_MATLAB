function str = getValueRangeString(minValue, maxValue, minValueUnit, maxValueUnit)
% getValueRangeString - Format a quantitative value range with units.
    
    minValueUnit = getUnitName(minValueUnit);
    maxValueUnit = getUnitName(maxValueUnit);

    if minValueUnit == maxValueUnit
        if minValueUnit == ""
            str = sprintf('%d-%d', minValue, maxValue);
        else
            str = sprintf('%d-%d %s', minValue, maxValue, pluralizeUnit(minValueUnit));
        end
    else
        str = sprintf('%s - %s', ...
            formatValueWithUnit(minValue, minValueUnit), ...
            formatValueWithUnit(maxValue, maxValueUnit));
    end
end

function unitName = getUnitName(unit)
% getUnitName - Name of a unit, empty when the property holds no unit
    if isa(unit, 'openminds.controlledterms.UnitOfMeasurement')
        if isempty(unit)
            unitName = "";
            return
        end
        unit = unit.name;
    end

    unitName = string(unit);
    if ismissing(unitName)
        unitName = "";
    end
end

function str = formatValueWithUnit(value, unitName)
% formatValueWithUnit - One end of the range, with its unit if it has one
    if unitName == ""
        str = sprintf('%d', value);
    else
        if value ~= 1
            unitName = pluralizeUnit(unitName);
        end
        str = sprintf('%d %s', value, unitName);
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
