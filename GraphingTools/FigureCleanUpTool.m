clc

Path = "c:\Thesis\TexWorkspace2\Images\LSTM\";
FileExt = "png";

Files = dir(Path + "*." + FileExt);

for mCtr = 1:length(List)
    if Files(mCtr).name == "." || Files(mCtr).name == "..", continue;end
    MLD_FigSaver_RemoveBorders(Path,Files(mCtr).name);
end