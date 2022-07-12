function OutStr = MLD_LeftAlignedString(InpStr,StringSpace)
OutStr = InpStr;

if length(InpStr{1}) < StringSpace
    OutStr = OutStr + char(ones(1,StringSpace - length(InpStr{1}) + 1)*char(' ')) ;
end
end