function Out = isnampty(Input)
    if isempty(Input)
        Out = 1;
    elseif isnan(Input)
        Out = 1;
    else
        Out = 0;
    end

end