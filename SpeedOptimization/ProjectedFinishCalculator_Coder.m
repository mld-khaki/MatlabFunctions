function [ FinishMessage ] = ProjectedFinishCalculator_Coder( InputToc, CurrentRecord, MaxRecordsCount, StartingRecord )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        if nargin <= 3
            StartingRecord = 1;
        end
        PassedTime = InputToc;
        TotalDuration = (MaxRecordsCount*PassedTime)/(CurrentRecord-StartingRecord+1);
        
        
		FinishMessage = sprintf([   '\n\tPercentage = %5.2f%%, Record Number = %u' ...
                                    '\tTime per account = %6.3f mSec -- ' ... 
									'\n\tPassed Time = \t\t%s '...
                                    '\n\tRemaining time = \t%s' ...
                                    '\n\tTotal duration = \t%s'],...
            100*CurrentRecord/MaxRecordsCount , CurrentRecord,...
            1000*PassedTime/(CurrentRecord-StartingRecord+1),...
			GenerateTotalDurationStr(PassedTime),...
            GenerateTotalDurationStr((MaxRecordsCount-CurrentRecord)*PassedTime/(CurrentRecord-StartingRecord+1)),...
            GenerateTotalDurationStr(TotalDuration)...
            );

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
                Output = [Output sprintf('%2u %s%s, ',TotalTime,Strings{ctr},TimeSingle)];
            end
            TempDur = TempDur - TotalTime*prod(Multipliers(ctr:end));
        end
    end
end

