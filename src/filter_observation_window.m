function filtered = filter_observation_window(events, observationHours)
%FILTER_OBSERVATION_WINDOW Retain events from admission through cutoff.

arguments
    events table
    observationHours (1,1) double {mustBePositive}
end

required = ["charttime", "admittime"];
assert(all(ismember(required, string(events.Properties.VariableNames))), ...
    "Events table must contain charttime and admittime.");
assert(isdatetime(events.charttime) && isdatetime(events.admittime), ...
    "charttime and admittime must be datetime values.");

elapsed = hours(events.charttime - events.admittime);
keep = ~isnan(elapsed) & elapsed >= 0 & elapsed <= observationHours;
filtered = events(keep, :);
end
