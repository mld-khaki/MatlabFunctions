function Out = Make_RowMatrix(Input1)
if size(Input1,1) < size(Input1,2)
	Out = Input1;
else
	Out = Input1';
end
end
