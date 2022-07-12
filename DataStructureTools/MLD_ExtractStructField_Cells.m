function Array = MLD_ExtractStructField_Cells(myStruct,FieldName)
for mCtr=1:length(myStruct)
	if mCtr==1
		Array = {};
	end
	if  isempty(myStruct(mCtr).(FieldName)) || ...
			nansum(MLD_IsNan(myStruct(mCtr).(FieldName)))>0
		Array{mCtr} = '';
	else
		Array{mCtr} = myStruct(mCtr).(FieldName);
	end
end
end
