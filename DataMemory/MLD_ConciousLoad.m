function [Output] = MLD_ConciousLoad(InputVarName,VarPath)
if evalin('caller',['~exist(''' InputVarName ''',''var'')'])
	fprintf('\nReading %s variable...',InputVarName);
	evalin('base',['load(''' VarPath ''');']);
	fprintf('Done!\n');
else
	fprintf('\nvariable "%s" already exists in workspace!\n',InputVarName);
end
end
