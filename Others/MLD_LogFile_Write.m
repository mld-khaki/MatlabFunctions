function Status = MLD_LogFile_Write(LogPath,Message,AddDate)
fileID = fopen(LogPath,'a+');

if fileID > 0
    if AddDate == true
        Message = [sprintf('%s : \t\t',datestr(now)),Message];
    end
    Message = strrep(Message,'\\','\');
    Message = strrep(Message,'\','\\');
    Message = [newline Message];
    fprintf(fileID,Message);
    fclose(fileID);
    Status = 1;
else
    Status = 0;
end
end