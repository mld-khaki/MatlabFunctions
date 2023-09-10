function s = MLD_removeFieldsStartingWith(s, InpStr)
    % Check if the input is a struct
    if ~isstruct(s)
        error('Input must be a struct.');
    end

    fields = fieldnames(s);

    for i = 1:length(fields)
        field = fields{i};
        value = s.(field);

        % If the field name starts with InpStr, remove it
        if startsWith(lower(field), lower(InpStr))
            s = rmfield(s, field);
            continue; % No need to check this field's contents
        end

        % Recursively remove fields if the current field is also a struct
        if isstruct(value)
            s.(field) = MLD_removeFieldsStartingWith(value, InpStr);
        end
    end
end
