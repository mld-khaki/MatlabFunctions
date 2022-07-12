function OutMatrix = MLD_ExtractStructField_NumericArray(myStruct,FieldNames,FieldNumbers)
OutMatrix = zeros(length(myStruct),length(FieldNumbers));
for iCtr=1:length(FieldNumbers)
    OutMatrix(:,iCtr) = MLD_ExtractStructField(myStruct,FieldNames{FieldNumbers(iCtr)});
end
end
