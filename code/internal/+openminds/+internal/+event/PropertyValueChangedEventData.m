classdef PropertyValueChangedEventData < event.EventData
%PropertyValueChangedEventData Event data for change of property value of instance
    
    properties
        NewValue
        OldValue
        IsLinkedProperty = false
    end

    methods
        function obj = PropertyValueChangedEventData(newValue, oldValue, isLinkedProperty)
            if nargin < 3 || isempty(isLinkedProperty)
                isLinkedProperty = false;
            end
            obj.NewValue = newValue;
            obj.OldValue = oldValue;
            obj.IsLinkedProperty = isLinkedProperty;
        end
    end
end
