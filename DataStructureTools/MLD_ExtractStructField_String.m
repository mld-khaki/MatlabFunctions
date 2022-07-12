function Array = MLD_ExtractStructField_String(myStruct,FieldName)
Type =-1;
try
    for mCtr=1:length(myStruct)
        if (Type == -1 && isstring(myStruct(mCtr).(FieldName)) || iscategorical(myStruct(mCtr).(FieldName)))...
                || Type == 1 
            Type = 1;
            if mCtr==1 
                if isstring(myStruct(mCtr).(FieldName))
                    Array = "";
                    Array(1,length(myStruct)) = "";
                elseif iscategorical(myStruct(mCtr).(FieldName))
                    Array = categorical(1,length(myStruct));
                end
			end
			if  isempty(myStruct(mCtr).(FieldName)) 
                continue;
			elseif iscategorical(myStruct(mCtr).(FieldName)) 
				if isundefined(myStruct(mCtr).(FieldName))
					continue;
				end
			end
            Array(mCtr) = myStruct(mCtr).(FieldName);
        elseif Type == -1 || Type == 2
            Type = 2;
            if mCtr==1
                Array = [];
            end
            if isstring(myStruct(mCtr).(FieldName))
                Array(mCtr) = myStruct(mCtr).(FieldName);
            elseif  isempty(myStruct(mCtr).(FieldName)) || ...
                    nansum(isnan(myStruct(mCtr).(FieldName)))>0
                Array(mCtr) = "";
            end
        end
    end
catch ME
    rethrow(ME);
end
end
