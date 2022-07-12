function [Out, Match] = MLD_StrCompareToChoices(InpStr,ChoicesSet,CaseSens,Alignment,Bidirectional)
% Bidirectional means InpStr = 'b21' and Choice = 'b21' returns true
%                also InpStr = 'b21.' and Choice = 'b21' returns true (even if we don't have b21.x)

if ~exist('CaseSens','var')
    CaseSens = false;
end
if ~exist('Bidirectional','var')
    Bidirectional = false;
end
if ~exist('Alignment','var')
    CaseSens = 'left';
else
    Alignment = lower(Alignment);
end

if CaseSens == false
    InpStr = lower(InpStr);
    for iCtr=1:length(ChoicesSet)
        ChoicesSet{iCtr} = lower(ChoicesSet{iCtr});
    end
end

Out = false;
Match = {};
for iCtr=1:length(ChoicesSet)
    CurrentChoice = ChoicesSet{iCtr};
    
    AlgnVectInp = 1:length(InpStr);
    AlgnVectChc = 1:length(CurrentChoice);
    if length(InpStr) > length(CurrentChoice)
        if Bidirectional == true 
            if strcmpi(Alignment,'left')
                AlgnVectInp = 1:length(CurrentChoice);
            elseif strcmpi(Alignment,'right')
                AlgnVectInp = length(InpStr)-length(CurrentChoice)+1:length(InpStr);
            end
            AlgnVectChc = 1:length(CurrentChoice);
        else
            continue;
        end
    else
        if strcmpi(Alignment,'left')
            AlgnVectChc = 1:length(InpStr);
        elseif strcmpi(Alignment,'right')
            AlgnVectChc = length(CurrentChoice)-length(InpStr)+1:length(CurrentChoice);
        end
        AlgnVectInp = 1:length(InpStr);
    end
    
    
    if strcmp(InpStr(AlgnVectInp),CurrentChoice(AlgnVectChc)) == 1
        Out = true;
        Match{end+1} = CurrentChoice;
    end
end
end
