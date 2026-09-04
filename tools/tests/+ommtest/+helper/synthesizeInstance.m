function [instance, report] = synthesizeInstance(className, options)
%synthesizeInstance Create an openMINDS instance populated with test values
%
%   instance = ommtest.helper.synthesizeInstance(className) creates an
%   instance of the given openMINDS type and populates every public
%   property with a deterministic, schema-valid value. Linked and embedded
%   properties are populated with synthesized instances of an allowed type.
%
%   [instance, report] = ommtest.helper.synthesizeInstance(className)
%   additionally returns a report struct describing which properties were
%   populated and which were skipped, with the reason for each skip.
%
%   instance = ommtest.helper.synthesizeInstance(className, Name=Value)
%   specifies additional options.
%
%   Input Arguments:
%     className - Full MATLAB class name of an openMINDS type, e.g.
%                 "openminds.core.actors.Person".
%
%   Name-Value Arguments:
%     LinkDepth - Number of levels of linked and embedded instances to
%                 populate. At depth 0 those properties are left empty.
%                 (Default: 1)
%
%   Output Arguments:
%     instance - A populated instance of the requested type.
%     report   - Struct with fields Populated and Skipped. Skipped is a
%                struct array with fields Property, Reason and Category.
%                Category is one of "PatternConstrained", "NoCandidate",
%                "ValidatorRejected" or "LinkDepth".
%
%   Values are chosen by property *kind* (string, datetime, numeric,
%   linked, embedded) rather than by property name, so this function does
%   not need updating when the openMINDS model adds, moves, or removes
%   types and properties. Cardinality and numeric bounds are read from the
%   property validators. A property whose validators reject every candidate
%   value is skipped and recorded in the report rather than raising, so a
%   newly introduced validator degrades coverage instead of breaking the
%   test suite.
%
%   Known gap: properties validated against a regular expression, such as
%   the identifier of a DOI, are skipped. Generating a string to match an
%   arbitrary pattern is out of scope; string round-tripping is covered by
%   the many unconstrained string properties.
%
%   See also openminds.meta.fromClassName

    arguments
        className (1,1) string
        options.LinkDepth (1,1) double {mustBeNonnegative, mustBeInteger} = 1
    end

    instance = feval(className);
    report = struct("Populated", string.empty, "Skipped", emptySkipStruct());
    report = populateProperties(instance, className, options.LinkDepth, report);
end

function report = populateProperties(instance, className, linkDepth, report)
% Populate every public property of instance with a synthesized value.

    metaType = openminds.meta.fromClassName(char(className));

    for propertyName = metaType.PropertyNames
        isLinked = metaType.isPropertyWithLinkedType(propertyName);
        isEmbedded = metaType.isPropertyWithEmbeddedType(propertyName);

        if (isLinked || isEmbedded) && linkDepth == 0
            report = addSkip(report, propertyName, "Link depth exhausted", "LinkDepth");
            continue
        end

        metaProperty = getMetaProperty(className, propertyName);
        validatorText = getValidatorText(metaProperty);
        numItems = requiredItemCount(metaType, propertyName, validatorText);

        if isLinked
            allowedTypes = string(metaType.listLinkedTypesForProperty(propertyName));
            candidates = synthesizeInstanceValues(allowedTypes, linkDepth, numItems);
        elseif isEmbedded
            allowedTypes = string(metaType.listEmbeddedTypesForProperty(propertyName));
            candidates = synthesizeInstanceValues(allowedTypes, linkDepth, numItems);
        else
            candidates = synthesizePrimitiveValues(metaProperty, validatorText, propertyName, numItems);
        end

        [wasAssigned, reason] = tryAssign(instance, propertyName, candidates);
        if wasAssigned
            report.Populated(end+1) = propertyName;
        else
            report = addSkip(report, propertyName, reason, ...
                skipCategory(validatorText, candidates));
        end
    end
end

function values = synthesizePrimitiveValues(metaProperty, validatorText, propertyName, numItems)
% Return an ordered list of candidate values for a non-linked property.
%
%   Each list candidate is followed by a scalar fallback, so a cardinality
%   constraint this function did not anticipate degrades to a populated
%   scalar rather than a skipped property.

    valueClass = "";
    if ~isempty(metaProperty.Validation) && ~isempty(metaProperty.Validation.Class)
        valueClass = string(metaProperty.Validation.Class.Name);
    end

    switch valueClass
        case "string"
            % Distinct values, because list properties commonly require
            % unique items.
            values = {@() propertyName + "_" + string(1:numItems), ...
                      @() propertyName + "_1"};

        case "datetime"
            if any(contains(validatorText, "mustBeValidTime"))
                values = {@() repmat(datetime(-1, 1, 1, 12, 30, 0), 1, numItems), ...
                          @() datetime(-1, 1, 1, 12, 30, 0)};
            else
                % A date-only datetime satisfies mustBeValidDate; offset
                % each item so unique-item validators are satisfied too.
                values = {@() datetime(2024, 1, 1) + caldays(0:numItems-1), ...
                          @() datetime(2024, 1, 1)};
            end

        case {"int64", "int32", "double", "single"}
            firstValue = numericStartValue(validatorText);
            values = {@() cast(firstValue:firstValue+numItems-1, valueClass), ...
                      @() cast(firstValue, valueClass)};

        case "logical"
            values = {@() true(1, numItems), @() true};

        otherwise
            % A property may be typed as an openMINDS type without being
            % registered in LINKED_PROPERTIES or EMBEDDED_PROPERTIES, so
            % fall back to synthesizing an instance of the declared class.
            if valueClass ~= "" && isOpenMindsType(valueClass)
                values = {@() synthesizeInstanceArray(valueClass, 1, numItems), ...
                          @() synthesizeInstanceArray(valueClass, 1, 1)};
            else
                values = {};
            end
    end
end

function tf = isOpenMindsType(className)
    metaClass = meta.class.fromName(className);
    tf = ~isempty(metaClass) && ~metaClass.Abstract ...
        && any(ismember(superclasses(className), {'openminds.Node'}));
end

function values = synthesizeInstanceValues(allowedTypes, linkDepth, numItems)
% Build candidate instance arrays from the first few allowed types.
%
%   Trying more than one allowed type matters because the first candidate
%   may be abstract or may itself fail to synthesize. Each candidate is an
%   array of numItems instances, followed by a scalar fallback.

    values = {};
    numCandidateTypes = min(3, numel(allowedTypes));

    for i = 1:numCandidateTypes
        thisType = allowedTypes(i);

        metaClass = meta.class.fromName(thisType);
        if isempty(metaClass) || metaClass.Abstract
            continue
        end

        values{end+1} = @() synthesizeInstanceArray(thisType, linkDepth, numItems); %#ok<AGROW>
        if numItems > 1
            values{end+1} = @() synthesizeInstanceArray(thisType, linkDepth, 1); %#ok<AGROW>
        end
    end
end

function instances = synthesizeInstanceArray(className, linkDepth, numItems)
% Create an array of distinct instances of the given type.

    if isControlledTerm(className)
        instanceNames = cachedInstanceNames(className);
        instances = arrayfun( ...
            @(i) controlledTermInstance(className, instanceNames, i), ...
            1:numItems, "UniformOutput", false);
    else
        instances = arrayfun( ...
            @(~) ommtest.helper.synthesizeInstance(className, "LinkDepth", linkDepth-1), ...
            1:numItems, "UniformOutput", false);
    end

    instances = [instances{:}];
end

function instance = controlledTermInstance(className, instanceNames, index)
% Create a controlled term instance from one of its controlled instances.

    if isempty(instanceNames)
        instance = feval(className);
        return
    end

    % Pick distinct names where possible, so unique-item validators pass.
    name = instanceNames(min(index, numel(instanceNames)));
    instance = ommtest.helper.controlledInstance(className, name);
end

function instanceNames = cachedInstanceNames(className)
% Controlled instance names for a type, cached for the MATLAB session.
%
%   listInstances reads the controlled instance library, which is far too
%   expensive to repeat for every synthesized instance.

    persistent nameCache
    if isempty(nameCache)
        nameCache = dictionary(string.empty, cell.empty);
    end

    if ~isKey(nameCache, className)
        nameCache(className) = {feval(sprintf("%s.listInstances", className))};
    end

    instanceNames = nameCache{className};
end

function tf = isControlledTerm(className)
    superclassNames = superclasses(className);
    tf = any(ismember(superclassNames, ...
        {'openminds.internal.mixin.HasControlledInstance', ...
         'openminds.base.ControlledTerm'}));
end

function [wasAssigned, reason] = tryAssign(instance, propertyName, candidates)
% Assign the first candidate value the property's validators accept.
%
%   Candidates are thunks rather than values, so only the candidates
%   actually needed are constructed. Building every candidate up front
%   would synthesize whole instance trees that are then discarded.

    wasAssigned = false;
    reason = "No candidate value for this property type";

    for i = 1:numel(candidates)
        try
            instance.(propertyName) = candidates{i}();
            wasAssigned = true;
            reason = "";
            return
        catch ME
            reason = string(ME.message);
        end
    end
end

function numItems = requiredItemCount(metaType, propertyName, validatorText)
% Determine how many items to synthesize for a property.
%
%   Scalar properties always get one item. List properties get two, so
%   that array handling is exercised, unless a min or max length validator
%   requires otherwise.

    if metaType.isPropertyValueScalar(propertyName)
        numItems = 1;
        return
    end

    numItems = 2;

    minLength = extractValidatorBound(validatorText, "mustBeMinLength");
    if ~isnan(minLength)
        numItems = max(numItems, minLength);
    end

    maxLength = extractValidatorBound(validatorText, "mustBeMaxLength");
    if ~isnan(maxLength)
        numItems = min(numItems, maxLength);
    end

    numItems = max(numItems, 1);
end

function startValue = numericStartValue(validatorText)
% First value satisfying the numeric range validators of a property.

    lowerBound = 1;

    inclusiveLower = extractValidatorBound(validatorText, "mustBeGreaterThanOrEqual");
    if ~isnan(inclusiveLower)
        lowerBound = max(lowerBound, inclusiveLower);
    end

    exclusiveLower = extractValidatorBound(validatorText, "mustBeGreaterThan");
    if ~isnan(exclusiveLower)
        lowerBound = max(lowerBound, exclusiveLower + 1);
    end

    upperBound = Inf;

    inclusiveUpper = extractValidatorBound(validatorText, "mustBeLessThanOrEqual");
    if ~isnan(inclusiveUpper)
        upperBound = min(upperBound, inclusiveUpper);
    end

    exclusiveUpper = extractValidatorBound(validatorText, "mustBeLessThan");
    if ~isnan(exclusiveUpper)
        upperBound = min(upperBound, exclusiveUpper - eps(exclusiveUpper));
    end

    startValue = lowerBound;

    % A default lower bound of 1 can exceed a tight upper bound, as for a
    % scale factor constrained to be less than 1. Fall back to the middle
    % of the permitted range.
    if startValue > upperBound
        startValue = upperBound / 2;
    end
end

function bound = extractValidatorBound(validatorText, validatorName)
% Extract the numeric bound from a validator such as mustBeMinLength(x,2).
%
%   mustBeGreaterThan is a prefix of mustBeGreaterThanOrEqual, so the
%   pattern requires the argument separator immediately after the name.

    bound = NaN;
    pattern = validatorName + "\([^,()]+,\s*(-?[\d.]+)\s*\)";

    for i = 1:numel(validatorText)
        token = regexp(validatorText(i), pattern, "tokens", "once");
        if ~isempty(token)
            bound = str2double(token(1));
            return
        end
    end
end

function validatorText = getValidatorText(metaProperty)
% Return the validator functions of a property as text, for inspection.

    validatorText = string.empty;
    if isempty(metaProperty.Validation)
        return
    end

    validatorFunctions = metaProperty.Validation.ValidatorFunctions;
    validatorText = strings(1, numel(validatorFunctions));
    for i = 1:numel(validatorFunctions)
        validatorText(i) = string(func2str(validatorFunctions{i}));
    end
end

function metaProperty = getMetaProperty(className, propertyName)
    metaClass = meta.class.fromName(className);
    propertyNames = string({metaClass.PropertyList.Name});
    metaProperty = metaClass.PropertyList(propertyNames == propertyName);
end

function category = skipCategory(validatorText, candidates)
% Classify why a property could not be populated.
%
%   Distinguishing a property this function is not designed to satisfy
%   from one that failed unexpectedly lets callers tell a genuine
%   regression from a documented limitation.

    if any(contains(validatorText, "mustMatchPattern"))
        % Generating a string to satisfy an arbitrary regular expression
        % is out of scope for this synthesizer.
        category = "PatternConstrained";
    elseif isempty(candidates)
        category = "NoCandidate";
    else
        category = "ValidatorRejected";
    end
end

function report = addSkip(report, propertyName, reason, category)
    report.Skipped(end+1) = struct( ...
        "Property", propertyName, ...
        "Reason", reason, ...
        "Category", category);
end

function S = emptySkipStruct()
    S = struct("Property", {}, "Reason", {}, "Category", {});
end
