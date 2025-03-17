function [hdr, records] = MLD_edfreadUntilDone_v4p6(fname, varargin)
% Read European Data Format file into MATLAB
%
% [hdr, record] = edfread(fname)
%         Reads data from ALL RECORDS of file fname ('*.edf'). Header
%         information is returned in structure hdr, and the signals
%         (waveforms) are returned in structure record, with waveforms
%         associated with the records returned as fields titled 'data' of
%         structure record.
%
%         Not Supported in Mex!
% [...] = edfread(fname, 'assignToVariables', assignToVariables)
%         If assignToVariables is true, triggers writing of individual
%         output variables, as defined by field 'labels', into the caller
%         workspace.
%
% [...] = edfread(...,'desiredSignals',desiredSignals)
%         Allows user to specify the names (or position numbers) of the
%         subset of signals to be read. |desiredSignals| may be either a
%         string, a cell array of comma-separated strings, or a vector of
%         numbers. (Default behavior is to read all signals.)
%         E.g.:
%         data = edfread(mydata.edf,'desiredSignals','Thoracic');
%         data = edfread(mydata.edf,'desiredSignals',{'Thoracic1','Abdominal'});
%         or
%         data = edfread(mydata.edf,'desiredSignals',[2,4,6:13]);
%
% FORMAT SPEC: Source: http://www.edfplus.info/specs/edf.html SEE ALSO:
% http://www.dpmi.tu-graz.ac.at/~schloegl/matlab/eeg/edf_spec.htm
%
% The first 256 bytes of the header record specify the version number of
% this format, local patient and recording identification, time information
% about the recording, the number of data records and finally the number of
% signals (ns) in each data record. Then for each signal another 256 bytes
% follow in the header record, each specifying the type of signal (e.g.
% EEG, body temperature, etc.), amplitude calibration and the number of
% samples in each data record (from which the sampling frequency can be
% derived since the duration of a data record is also known). In this way,
% the format allows for different gains and sampling frequencies for each
% signal. The header record contains 256 + (ns * 256) bytes.
%
% Following the header record, each of the subsequent data records contains
% 'duration' seconds of 'ns' signals, with each signal being represented by
% the specified (in the header) number of samples. In order to reduce data
% size and adapt to commonly used software for acquisition, processing and
% graphical display of polygraphic signals, each sample value is
% represented as a 2-byte integer in 2's complement format. Figure 1 shows
% the detailed format of each data record.
%
% DATA SOURCE: Signals of various types (including the sample signal used
% below) are available from PHYSIONET: http://www.physionet.org/
%
%
% % EXAMPLE 1:
% % Read all waveforms/data associated with file 'ecgca998.edf':
%
% [header, recorddata] = edfread('ecgca998.edf');
%
% % EXAMPLE 2:
% % Read records 3 and 5, associated with file 'ecgca998.edf':
%
% header = edfread('ecgca998.edf','AssignToVariables',true);
% % Header file specifies data labels 'label_1'...'label_n'; these are
% % created as variables in the caller workspace.
%
% Upgraded to coder compatible m-file 4/4/2023 by Milad Khaki, Ph.D.
% milad.khaki@gmail.com
%
%
% Coded 8/27/09 by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% Copyright 2009 - 2012 MathWorks, Inc.
%
% Modifications:
% 5/6/13 Fixed a problem with a poorly subscripted variable. (Under certain
% conditions, data were being improperly written to the 'records' variable.
% Thanks to Hisham El Moaqet for reporting the problem and for sharing a
% file that helped me track it down.)
%
% 5/22/13 Enabled import of a user-selected subset of signals. Thanks to
% Farid and Cindy for pointing out the deficiency. Also fixed the import of
% signals that had "bad" characters (spaces, etc) in their names.
%
% 10/30/14 Now outputs frequency field directly, and (thanks to Olga Imas
% for the suggestion.)

% HEADER RECORD
% 8 ascii : version of this data format (0)
% 80 ascii : local patient identification
% 80 ascii : local recording identification
% 8 ascii : startdate of recording (dd.mm.yy)
% 8 ascii : starttime of recording (hh.mm.ss)
% 8 ascii : number of bytes in header record
% 44 ascii : reserved
% 8 ascii : number of data records (-1 if unknown)
% 8 ascii : duration of a data record, in seconds
% 4 ascii : number of signals (ns) in data record
% ns * 16 ascii : ns * label (e.g. EEG FpzCz or Body temp)
% ns * 80 ascii : ns * transducer type (e.g. AgAgCl electrode)
% ns * 8 ascii : ns * physical dimension (e.g. uV or degreeC)
% ns * 8 ascii : ns * physical minimum (e.g. -500 or 34)
% ns * 8 ascii : ns * physical maximum (e.g. 500 or 40)
% ns * 8 ascii : ns * digital minimum (e.g. -2048)
% ns * 8 ascii : ns * digital maximum (e.g. 2047)
% ns * 80 ascii : ns * prefiltering (e.g. HP:0.1Hz LP:75Hz)
% ns * 8 ascii : ns * nr of samples in each data record
% ns * 32 ascii : ns * reserved

% DATA RECORD
% nr of samples[1] * integer : first signal in the data record
% nr of samples[2] * integer : second signal
% ..
% ..
% nr of samples[ns] * integer : last signal

TypeNum = 1;
if nargin > 5
    error('EDFREAD: Too many input arguments.');
end

if ~nargin
    error('EDFREAD: Requires at least one input argument (filename to read).');
end

[fid] = fopen(fname,'r');
if fid == -1
    error("File opening failed")
end

assignToVariables = 0; %Default
targetSignals = []; %Default
for iCtr = 1:2:numel(varargin)
    switch lower(varargin{iCtr})
        case 'assigntovariables'
            assignToVariables = varargin{iCtr+1};
        case 'targetsignals'
            targetSignals = varargin{iCtr+1};
        case 'customstring'
            CustomString = varargin{iCtr+1};
        otherwise
            error('EDFREAD: Unrecognized parameter-value pair specified. Valid values are ''assignToVariables'' and ''targetSignals''.')
    end
end

max_hdr_ns = 256;

hdr_ver        = str2double(char(fread(fid,8)'));
hdr_patientID  = fread(fid,80,'*char')';
hdr_recordID   = fread(fid,80,'*char')';
hdr_startdate  = fread(fid,8,'*char')';% (dd.mm.yy)
hdr_starttime  = fread(fid,8,'*char')';% (hh.mm.ss)
hdr_bytes      = str2double(fread(fid,8,'*char')');
reserved       = fread(fid,44);
hdr_records    = str2double(fread(fid,8,'*char')');
hdr_duration   = str2double(fread(fid,8,'*char')');
% Number of signals
hdr_ns    = str2double(fread(fid,4,'*char')');
hdr_label = cell(1,hdr_ns);
hdr_transducer = hdr_label;
hdr_units      = hdr_label;
hdr_prefilter   = hdr_label;

hdr_physicalMin = zeros(1,hdr_ns);
hdr_physicalMax = zeros(1,hdr_ns);
hdr_digitalMin  = zeros(1,hdr_ns);
hdr_digitalMax  = zeros(1,hdr_ns);
hdr_samples     = zeros(1,hdr_ns);


for iCtr = 1:hdr_ns
	hdr_label{iCtr} = regexprep(fread(fid,16,'*char')','\W','');
end

% This denotes that the elements each have a fixed-size first dimension
% and variable-size second dimension with an upper bound of 16.


if isempty(targetSignals)
    targetSignals = 1:numel(hdr_label);
elseif iscell(targetSignals)||ischar(targetSignals)
    targetSignals = find(ismember(hdr_label, local_RemoveNonWordChars(targetSignals)));
    %         regexprep(targetSignals,'\W','')));
end
if isempty(targetSignals)
    error('EDFREAD: The signal(s) you requested were not detected.')
end

for iCtr = 1:hdr_ns
    hdr_transducer{iCtr} = fread(fid,80,'*char')';
end
% Physical dimension
for iCtr = 1:hdr_ns
    hdr_units{iCtr} = fread(fid,8,'*char')';
end
% Physical minimum
for iCtr = 1:hdr_ns
    hdr_physicalMin(iCtr) = str2double(fread(fid,8,'*char')');
end
% Physical maximum
for iCtr = 1:hdr_ns
    hdr_physicalMax(iCtr) = str2double(fread(fid,8,'*char')');
end
% Digital minimum
for iCtr = 1:hdr_ns
    hdr_digitalMin(iCtr) = str2double(fread(fid,8,'*char')');
end
% Digital maximum
for iCtr = 1:hdr_ns
    hdr_digitalMax(iCtr) = str2double(fread(fid,8,'*char')');
end
for iCtr = 1:hdr_ns
    hdr_prefilter{iCtr} = fread(fid,80,'*char')';
end
for iCtr = 1:hdr_ns
    hdr_samples(iCtr) = str2double(fread(fid,8,'*char')');
end
reserved = '';
for iCtr = 1:hdr_ns
    reserved    = fread(fid,32,'*char')';
end
hdr_label = hdr_label(targetSignals);

hdr_label = regexprep(hdr_label,'\W','');
% hdr_label = local_RemoveNonWordChars(hdr_label);

% hdr_units = regexprep(hdr_units,'\W','');
hdr_units = local_RemoveNonWordChars(hdr_units);


hdr_frequency = hdr_samples./hdr_duration;
disp('Step 1 of 2: Reading requested records. (This may take a few minutes.)...');
if nargout > 1 || assignToVariables
    % Scale data (linear scaling)
    scalefac = local_bytefunc((hdr_physicalMax - hdr_physicalMin)./(hdr_digitalMax - hdr_digitalMin),TypeNum);
    dc = local_bytefunc(hdr_physicalMax - scalefac .* hdr_digitalMax,TypeNum);
    
    % RECORD DATA REQUESTED
%     tmpdata = zeros(hdr_records,hdr_ns,max(hdr_samples));
	tmpdata = struct;
    org_hdr_rec = hdr_records;
    hdr_records = 1e10; %Read a maximum of 1e10 records
    dataExists = true;
    StartTic = tic;
    CurrentTic = StartTic;
    
    MaskVect = ismember(1:hdr_ns,targetSignals);
    for recnum = 1:hdr_records
        if ~dataExists,break,end
        if toc(CurrentTic) > 5
            clc;
            CurrentTic = tic;
            OutStr = local_MLD_ProjectedFinishCalculator(toc(StartTic), recnum, org_hdr_rec, 1);
            fprintf("\nImporting file = <%s>,\nMax record count = %u, <%s>",fname,org_hdr_rec,CustomString);    
            fprintf('\n%s',OutStr);
        end
        tempvar = fread(fid,sum(hdr_samples),'int16');
        EndInd = 0;
        for iCtr = 1:hdr_ns
            BegInd = EndInd+1;
            EndInd = BegInd+hdr_samples(iCtr)-1;
            % Read or skip the appropriate number of data points
            if MaskVect(iCtr) == 1
                % Use a cell array for DATA because number of samples may vary
                % from sample to sample
%                 ftell(fid)
                if isempty(tempvar)
                    dataExists = false;
                    hdr_records = (recnum-1);
                    break
                else
					tmpdata(recnum).data{iCtr} = tempvar(BegInd:EndInd)* scalefac(iCtr) + dc(iCtr);
                end
            else
%                 fread(fid,hdr_samples(iCtr)*2);
%                 fseek(fid,hdr_samples(iCtr)*2,0);
            end
        end
    end
	hdr_units = hdr_units(targetSignals);
	hdr_physicalMin = hdr_physicalMin(targetSignals);
	hdr_physicalMax = hdr_physicalMax(targetSignals);
	hdr_digitalMin = hdr_digitalMin(targetSignals);
	hdr_digitalMax = hdr_digitalMax(targetSignals);
	hdr_prefilter = hdr_prefilter(targetSignals);
	hdr_transducer = hdr_transducer(targetSignals);

    [~,TypeStr] = local_bytefunc(0,TypeNum);
%     records = zeros(numel(hdr_label), hdr_samples(1)*hdr_records,TypeStr);
	records = zeros(numel(hdr_label), hdr_samples(1)*hdr_records,TypeStr);
    % NOTE: 5/6/13 Modified for loop below to change instances of hdr_samples to
    % hdr_samples(ii). I think this underscored a problem with the reader.
    
    fprintf('\nStep 2 of 2: Parsing data...\n');
    recnum = 1;
	for iCtr = 1:hdr_ns
		if MaskVect(iCtr) == 1
			offset = 1;
			for jCtr = 1:hdr_records
				try
					records(recnum, offset : offset + hdr_samples(iCtr) - 1) = tmpdata(jCtr).data{iCtr};
				end
				offset = offset + hdr_samples(iCtr);
			end
			recnum = recnum + 1;
		end
	end
    hdr_ns = numel(hdr_label);
    hdr_samples = hdr_samples(1,targetSignals);
%     records = records(targetSignals,:);
    
    if assignToVariables
        for ii = 1:numel(hdr_label)
            try
                eval(['assignin(''caller'',''',hdr_label{ii},''',record(ii,:))'])
            end
        end
        % Uncomment this line to duplicate output in a single matrix
        % ''record''. (Could be memory intensive if dataset is large.)
        records = [];% No need to output record data as a matrix?
    end
end
fclose(fid);

% hdr_units2 = hdr_units(targetSignals);
% hdr_physicalMin = hdr_physicalMin(targetSignals);
% hdr_physicalMax = hdr_physicalMax(targetSignals);
% hdr_digitalMin = hdr_digitalMin(targetSignals);
% hdr_digitalMax = hdr_digitalMax(targetSignals);
% hdr_prefilter2  = hdr_prefilter(targetSignals);
% hdr_transducer2 = hdr_transducer(targetSignals);
% hdr_label2      = hdr_label(targetSignals);

hdr = struct(...
    'bytes',        hdr_bytes,...
    'digitalMax',   hdr_digitalMax,...
    'digitalMin',   hdr_digitalMin,...
    'duration',     hdr_duration,...
    'frequency',    hdr_frequency,...
    'label',        {hdr_label},...
    'ns',           hdr_ns,...
    'patientID',    hdr_patientID,...
    'physicalMin',  hdr_physicalMin,...
    'physicalMax',  hdr_physicalMax,...
    'prefilter',	{hdr_prefilter},...
    'recordID',		hdr_recordID,...
    'records',		hdr_records,...
    'samples',		hdr_samples,...
    'startdate',	hdr_startdate,...
    'starttime',	hdr_starttime,...
    'transducer',	{hdr_transducer},...
    'units',		{hdr_units},...
    'ver',			hdr_ver,...
    'reserved',		reserved);

% HEADER


end
function Out = local_RemoveNonWordChars(Inp)
Out = Inp;
if iscell(Inp)
    for q3Ctr=1:length(Inp)
        Out{q3Ctr} = local1_RemoveNonWordChars(Inp{q3Ctr});
    end
else
    Out = local1_RemoveNonWordChars(Inp);
end
end

function Out = local1_RemoveNonWordChars(Inp)
Chars = '!@#$%^&*()_+={}[]|\:;"<>,./?~ ';
Out = Inp;
for qCtr=Chars
    Out = regexprep(Out,'\W','');
end
end

function [ FinishMessage ] = local_MLD_ProjectedFinishCalculator( InputToc, CurrentRecord, MaxRecordsCount, StartingRecord )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin <= 3
    StartingRecord = 1;
end
PassedTime = InputToc;
TotalDuration = (MaxRecordsCount*PassedTime)/(CurrentRecord-StartingRecord+1);


timeRemaining = seconds((MaxRecordsCount-CurrentRecord)*PassedTime/(CurrentRecord-StartingRecord+1));
FinishMessage = sprintf(['\n\tCompleted percentage = %5.2f%%, Record Number = %u' ...
    '\tTime per record = %6.3f mSec -- ' ...
    '\n\tPassed Time = \t\t%s '...
    '\n\tRemaining time = \t%s' ...
    '\n\tTotal duration = \t%s'], ...
    100*CurrentRecord/MaxRecordsCount, uint64(CurrentRecord), ...
    1000*PassedTime/(CurrentRecord-StartingRecord+1), ...
    GenerateTotalDurationStr(PassedTime), ...
    GenerateTotalDurationStr(timeRemaining), ...
    GenerateTotalDurationStr(TotalDuration) ...
    );


    function Output = GenerateTotalDurationStr(TotalDur)
        Strings = {'Month','Day','Hour','Minute','Second'};
        Multipliers = [30*24*60*60, 24*60*60, 60*60, 60, 1];
        Output = '';
        TempDur = TotalDur;
        for ctr = 1:length(Multipliers)
            TotalTime = floor(TempDur / (Multipliers(ctr)));
            if isduration(TotalTime)
                TotalTimeNum = seconds(TotalTime);
            else
                TotalTimeNum = TotalTime;
            end
            if TotalTimeNum > 0
                if TotalTimeNum == 1
                    TimeSingle = '';
                else
                    TimeSingle = 's';
                end
                Output = [Output, sprintf('%2u %s%s, ',uint64(TotalTimeNum),Strings{ctr},TimeSingle)];
            end
            TempDur = TempDur - TotalTimeNum * Multipliers(ctr);
        end
    end

end

function [Out,TypeStr] = local_bytefunc(Inp,Type)
if Type == 0
    Out = single(Inp);
    TypeStr = 'single';
else
    Out = double(Inp);
    TypeStr = 'double';
end
end