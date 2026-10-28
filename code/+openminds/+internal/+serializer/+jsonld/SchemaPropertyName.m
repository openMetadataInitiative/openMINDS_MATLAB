classdef SchemaPropertyName
% SchemaPropertyName - Carry a schema property name through a MATLAB struct
%
%   A schema may spell a property name in a way that is not a valid MATLAB
%   identifier, such as "z-stepSize". The generated type class then
%   declares the property under a valid name and records the schema name in
%   its PROPERTY_NAME_MAP constant. A document must use the schema name,
%   but the structs a document is built from cannot hold it as a field
%   name.
%
%   The name is therefore carried as a placeholder field name that is a
%   valid identifier, and restored in the JSON text once the struct is
%   encoded. This mirrors how the vocabulary IRI of an expanded property
%   name is carried.
%
%   Static methods:
%       toPlaceholder    - Placeholder field name for a schema name
%       fromPlaceholder  - Schema name a placeholder stands for
%       isPlaceholder    - Whether a field name is a placeholder
%       restoreInJson    - Replace every placeholder key in JSON text
%
%   See also openminds.introspection.MetaType,
%   openminds.internal.serializer.JsonLdSerializer

    properties (Constant, Access = private)
        PLACEHOLDER_PREFIX = "SCHEMA_NAME_"

        % A code point is written with this many hex digits. A MATLAB
        % char is a UTF-16 unit, which always fits.
        CODE_POINT_DIGITS = 4
    end

    methods (Static)
        function placeholder = toPlaceholder(schemaName)
        % toPlaceholder - Placeholder field name for a schema name
        %
        %   Every character that is not a letter or a digit is written as
        %   its code point in hex between underscores. The underscore is
        %   escaped as well, so a placeholder decodes to one name only.

            arguments
                schemaName (1,1) string
            end

            import openminds.internal.serializer.jsonld.SchemaPropertyName

            characters = char(schemaName);
            encoded = strings(1, numel(characters));
            for i = 1:numel(characters)
                if SchemaPropertyName.isPlainCharacter(characters(i))
                    encoded(i) = characters(i);
                else
                    encoded(i) = sprintf('_%0*X_', ...
                        SchemaPropertyName.CODE_POINT_DIGITS, double(characters(i)));
                end
            end

            placeholder = SchemaPropertyName.PLACEHOLDER_PREFIX + strjoin(encoded, "");
        end

        function schemaName = fromPlaceholder(placeholder)
        % fromPlaceholder - Schema name a placeholder stands for

            arguments
                placeholder (1,1) string
            end

            import openminds.internal.serializer.jsonld.SchemaPropertyName

            assert(SchemaPropertyName.isPlaceholder(placeholder), ...
                'openMINDS:SchemaPropertyName:NotAPlaceholder', ...
                '"%s" is not a schema property name placeholder.', placeholder)

            body = extractAfter(placeholder, SchemaPropertyName.PLACEHOLDER_PREFIX);

            escapePattern = sprintf('_([0-9A-F]{%d})_', SchemaPropertyName.CODE_POINT_DIGITS);
            escapes = unique(string(regexp(body, escapePattern, 'match')));
            for escape = escapes
                codePoint = hex2dec(extractBetween(escape, 2, strlength(escape) - 1));
                body = replace(body, escape, string(char(codePoint)));
            end

            schemaName = body;
        end

        function tf = isPlaceholder(fieldName)
        % isPlaceholder - Whether a field name is a placeholder

            arguments
                fieldName string
            end

            tf = startsWith(fieldName, ...
                openminds.internal.serializer.jsonld.SchemaPropertyName.PLACEHOLDER_PREFIX);
        end

        function jsonText = restoreInJson(jsonText)
        % restoreInJson - Replace every placeholder key in JSON text
        %
        %   Only names in property-key position are rewritten: a
        %   placeholder is preceded by the opening quote of the key, or by
        %   the vocabulary IRI in expanded form, and followed by the
        %   closing quote and a colon. A string value never sits in that
        %   position.

            arguments
                jsonText (1,1) string
            end

            import openminds.internal.serializer.jsonld.SchemaPropertyName

            if ~contains(jsonText, SchemaPropertyName.PLACEHOLDER_PREFIX)
                return
            end

            % Single-quoted so the double quotes delimiting a JSON key can
            % be written literally in the pattern.
            keyPattern = sprintf('(?<=["/])%s[A-Za-z0-9_]+(?="\\s*:)', ...
                SchemaPropertyName.PLACEHOLDER_PREFIX);
            placeholders = unique(string(regexp(jsonText, keyPattern, 'match')));

            for placeholder = placeholders
                placeholderPattern = sprintf('(?<=["/])%s(?="\\s*:)', ...
                    regexptranslate('escape', placeholder));
                replacement = SchemaPropertyName.asReplacementText( ...
                    SchemaPropertyName.fromPlaceholder(placeholder));
                jsonText = regexprep(jsonText, placeholderPattern, replacement);
            end
        end
    end

    methods (Static, Access = private)
        function text = asReplacementText(text)
        % Escape a name for use as a regexprep replacement, where a dollar
        % sign introduces a token and a backslash an escape.
            text = replace(text, ["\", "$"], ["\\", "\$"]);
        end

        function tf = isPlainCharacter(character)
        % A character that is written as it is: an ASCII letter or digit.
            tf = ismember(character, ['A':'Z', 'a':'z', '0':'9']);
        end
    end
end
