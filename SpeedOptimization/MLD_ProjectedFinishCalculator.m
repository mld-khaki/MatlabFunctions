function [ FinishInfo ] = MLD_ProjectedFinishCalculator( InputToc, CurrentRecord, MaxRecordsCount, StartingRecord )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        if nargin <= 3
            StartingRecord = 1;
        end
        PassedTime = InputToc;
        TotalDuration = (MaxRecordsCount*PassedTime)/(CurrentRecord-StartingRecord+1);
        
        
		FinishInfo = [];
        FinishInfo.Percentage = 100*CurrentRecord/MaxRecordsCount;
        FinishInfo.RecordNumber = CurrentRecord;
        FinishInfo.TimePerRecSec = PassedTime/(CurrentRecord-StartingRecord+1);
        FinishInfo.PassedTimeStr = GenerateTotalDurationStr(PassedTime);
        FinishInfo.ProjectedFinishStr = datestr(now+datenum(0,0,0,0,0,1)*(MaxRecordsCount-CurrentRecord)*PassedTime/(CurrentRecord-StartingRecord+1),'mm-dd HH:MM:SS');
        FinishInfo.TotalDuration = GenerateTotalDurationStr(TotalDuration);
        FinishInfo.RemainingTime = GenerateTotalDurationStr((MaxRecordsCount-CurrentRecord)*PassedTime/(CurrentRecord-StartingRecord+1));

    function Output = GenerateTotalDurationStr(TotalDur)
        Strings =     {'Month','Day','Hour','Minute','Second'};
        Multipliers = [   30  , 24  , 60   , 60     , 1      ]; 
    
        Output = '';
        TempDur = TotalDur;
        for ctr = 1:length(Multipliers)
% 			prod(Multipliers(ctr:end))
            TotalTime = floor(TempDur / prod(Multipliers(ctr:end)));
            if TotalTime > 0
                if TotalTime == 1
                    TimeSingle = '';
                else
                    TimeSingle = 's';
                end
                Output = [Output sprintf('%u %s%s, ',TotalTime,Strings{ctr},TimeSingle)];
            end
            TempDur = TempDur - TotalTime*prod(Multipliers(ctr:end));
        end
    end
end
