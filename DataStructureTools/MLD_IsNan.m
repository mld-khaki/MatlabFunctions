function out = MLD_IsNan(Input)
if iscell(Input)
    if length(Input) > 1
        out = false;
        return
    end
end
out=zeros(size(Input));
if iscell(Input)
    for i=1:length(Input)
        out(i+1) = MLD_IsNan(Input{i});
    end
    out(1) = 0;
    for i=1:length(Input)
        out(1) = out(1) || out(i+1);
    end
    out = out(1);
elseif ischar(Input)
    if isempty(Input)
        out = 1;
    else
        out = 0;
    end
elseif isstring(Input)
    if ismissing(Input)
        out = 1;
    elseif isempty(Input{1})
        out = 1;
    else
        out = 0;
    end
elseif iscategorical(Input)
    Out = 0;
else
    out = isnan(Input);
end
