function totSize = MLD_GetSize(Var)
props = whos('Var');
totSize = props.bytes;
end