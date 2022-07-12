function Out = MLD_CiteNrm(CiteCount,PublishYear)
CurYear = year(now);

Out = round(CiteCount / log10(CurYear+10-PublishYear));
if Out > 100
    Out = ceil(Out/100)*100;
else
    Out = ceil(Out/10)*10;
end
end