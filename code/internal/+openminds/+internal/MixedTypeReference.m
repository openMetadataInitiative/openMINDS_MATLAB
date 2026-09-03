classdef MixedTypeReference < openminds.abstract.Schema
% MixedTypeReference - Reference type for when the actual type is not known

    properties (Access = protected)
        Required = string.empty
    end

    properties (Constant, Hidden)
        X_TYPE = "Reference"
    end

    properties (Access = private)
        ALLOWED_TYPES
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct()
        EMBEDDED_PROPERTIES = struct()
    end

    methods
        function obj = MixedTypeReference(identifier)
            arguments
                identifier (1,1) string {mustBeNonzeroLengthText}
            end
            obj@openminds.abstract.Schema(struct.empty, 'id', identifier)
        end
    end

    methods
        function tf = isReference(~)
            tf = true;
        end
    end

    methods (Hidden, Access = protected) % CustomDisplay - Method implementation
            
        function str = getHeader(obj)
            str = getHeader@matlab.mixin.CustomDisplay(obj);

            if isscalar(obj)
                str = insertBefore(str, 'with', sprintf('(%s) ', obj.id));
            end
        end

        function annotation = getAnnotation(~, ~)
            annotation = '';
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.REFERENCE_DISPLAY_LABEL;
        end
    end
end
