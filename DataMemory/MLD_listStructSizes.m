function [varNames, varSizes] = MLD_listStructSizes(s, prefix, doPlot)
    if nargin < 2
        prefix = 's';
    end

    if nargin < 3
        doPlot = false;
    end

    % Check if the input is a struct
    if ~isstruct(s)
        error('Input must be a struct.');
    end

    fields = fieldnames(s);
    varNames = "";
    varSizes = [];

    for iCtr = 1:length(fields)
        field = fields{iCtr};
        value = s.(field);
        sizeValue = numel(value);

        % Store the variable name and size for plotting
        varNames(iCtr) = strrep(string([prefix '.' field]),"_","\_");
        varSizes(iCtr) = sizeValue;

        % Print the variable name and size
        sizeStr = num2str(sizeValue);
        disp([prefix '.' field ': ' sizeStr]);

        % Recursively list sizes if the field is also a struct
        if isstruct(value)
            [subVarNames, subVarSizes] = MLD_listStructSizes(value, [prefix '.' field], false);
            varNames = [varNames, subVarNames];
            varSizes = [varSizes, subVarSizes];
        end
    end

    if doPlot
        figure;
        pltVarSizes = varSizes >= 0.25*nanmean(varSizes);
        bar(varSizes(pltVarSizes));
        
        set(gca, 'XTickLabel', varNames(pltVarSizes), 'XTick', 1:numel(varNames(pltVarSizes)));
        xlabel('Number of Elements');
        title('Variable Sizes in Struct');
    end

    if nargout > 0
        varargout{1} = varNames;
        varargout{2} = varSizes;
    end
end
