function s = MLD_removeFieldsStartingWith(s, InpStr)
% data.Inp_a = ones(10, 10);
% data.b.subfield1 = zeros(5, 5);
% data.b.Inp_subfield2 = 2;
% data.b.c.Inp_d = 3;
% data.b.c.e = 4;
%
% cleaned_data = MLD_removeFieldsStartingWith(data, 'Inp_');

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
