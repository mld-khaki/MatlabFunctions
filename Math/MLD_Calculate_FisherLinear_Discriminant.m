function fld = MLD_Calculate_FisherLinear_Discriminant(data1,data2)
% Assuming data1 and data2 are your two classes data
% They are NxD matrices where N is the number of instances and D is the number of dimensions (features)
mean1 = mean(data1);
mean2 = mean(data2);

% Between class scatter
Sb = (mean2 - mean1)' * (mean2 - mean1);

% Within class scatter
Sw = cov(data1) + cov(data2);

% Calculate Fisher's Linear Discriminant
fld = trace(Sb) / trace(Sw);
