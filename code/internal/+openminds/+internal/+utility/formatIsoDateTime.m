function text = formatIsoDateTime(value, options)
%formatIsoDateTime Write datetime values as ISO 8601 text
%
%   text = formatIsoDateTime(value) writes each datetime as a date-time,
%   "2023-02-07T16:00:00". A value with a time zone carries its offset,
%   "2023-02-07T16:00:00+00:00", and a value with a fractional second
%   carries six decimals. A value without a time zone is written without
%   an offset. This is the form the reference implementation reads and
%   writes.
%
%   text = formatIsoDateTime(value, DateOnly=true) writes each value as a
%   date, "2024-03-05".
%
%   Input Arguments:
%     value - datetime array.
%
%   Output Arguments:
%     text - string array, same size as value.
%
%   See also openminds.internal.utility.parseIsoDateTime

    arguments
        value datetime
        options.DateOnly (1,1) logical = false
    end

    if options.DateOnly
        value.Format = "yyyy-MM-dd";
    else
        secondsFormat = "ss";
        if any(mod(second(value), 1) ~= 0, "all")
            secondsFormat = "ss.SSSSSS";
        end

        offsetFormat = "";
        if ~isempty(value.TimeZone)
            offsetFormat = "xxx"; % +HH:mm, and +00:00 rather than Z
        end

        value.Format = "yyyy-MM-dd'T'HH:mm:" + secondsFormat + offsetFormat;
    end

    text = string(value);
end
