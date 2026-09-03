function value = parseIsoDateTime(text)
%parseIsoDateTime Read ISO 8601 text as datetime values
%
%   value = parseIsoDateTime(text) reads a date, "2024-03-05", or a
%   date-time, "2023-02-07T16:00:00", with or without a fractional second
%   and with or without a UTC offset such as "+00:00" or "Z". A value with
%   an offset is returned in UTC; a value without one has no time zone.
%
%   Text in another form is read the way datetime reads it on its own, so
%   a file written by an earlier release of this toolbox, which used the
%   default datetime display format, still loads.
%
%   Input Arguments:
%     text - string array of ISO 8601 date or date-time text.
%
%   Output Arguments:
%     value - datetime array, same size as text.
%
%   See also openminds.internal.utility.formatIsoDateTime

    arguments
        text string
    end

    value = arrayfun(@parseOne, text);
end

function value = parseOne(text)

    % Tried in order; a format with an offset sets the time zone so the
    % offset is applied rather than ignored.
    isoFormats = [ ...
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX", ...
        "yyyy-MM-dd'T'HH:mm:ssXXX", ...
        "yyyy-MM-dd'T'HH:mm:ss.SSSSSS", ...
        "yyyy-MM-dd'T'HH:mm:ss", ...
        "yyyy-MM-dd"];

    for isoFormat = isoFormats
        try
            if endsWith(isoFormat, "XXX")
                value = datetime(text, "InputFormat", isoFormat, "TimeZone", "UTC");
            else
                value = datetime(text, "InputFormat", isoFormat);
            end
        catch
            value = NaT; % Not this format, try the next
        end

        if ~isnat(value)
            return
        end
    end

    value = datetime(text);
end
