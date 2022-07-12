function output = IfCond(Condition,TrueInput,FalseInput)
	if Condition
		output = TrueInput;
	else
		output = FalseInput;
	end
end