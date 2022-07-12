function Out = MLD_GenerateUIDFromRecord(Input)

CityStr = ItemCleanup(Input.City,4);
ItemStr = ItemCleanup(Input.ItemNum,4);
ItemSec = ItemCleanup(Input.Section,4);
TenderContract = ItemCleanup(Input.Contract,10);
ItemPrice = ItemCleanup(Input.UnitPrice,4);
ItemQuantity = ItemCleanup(Input.EstimatedQuantity,3);

ItemDesc = '';
for iCtr=1:length(Input.DescWords)
    if isempty(Input.DescWords{iCtr}),continue;end
    ItemDesc = [ItemDesc MLD_StripCell(Input.DescWords{iCtr}(1))];
end

Out = [CityStr ItemStr ItemSec TenderContract ItemPrice ItemQuantity ItemDesc];
end

function OutStr = ItemCleanup(InpStr,Len)
OutStr = InpStr;

if iscategorical(OutStr)
    OutStr = cellstr(OutStr);
    OutStr = OutStr{1};
elseif isnumeric(OutStr)
    OutStr = num2str(OutStr);
end

RemChars = {'.',' '};

for iCtr=1:length(RemChars)
    OutStr(OutStr == RemChars{iCtr}) = '';
end

Con = '_';
for iCtr=1:Len
    Con = [Con '_'];
end

OutStr = [OutStr Con];

OutStr = OutStr(1:Len-1);
OutStr = [OutStr '_'];
end