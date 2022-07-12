function Output = MLD_PlotFFT(InputTimeData,SamplingFreq,FigHandle,Style)
%% Time specifications:
InputTimeData(isnan(InputTimeData)) = [];
dt = 1/SamplingFreq;                     % seconds per sample
StopTime = 1;                  % seconds
t = linspace(0,dt*length(InputTimeData),length(InputTimeData))';
N = size(t,1);
%% Sine wave:
Fc = 12;                       % hertz
x = cos(2*pi*Fc*t);
%% Fourier Transform:
InputFreqData = fftshift(fft(InputTimeData));
%% Frequency specifications:
dF = SamplingFreq/N;                      % hertz
f = -SamplingFreq/2:dF:SamplingFreq/2-dF;           % hertz
%% Plot the spectrum:
if nargin <= 2
    figure;
elseif FigHandle == -1
else
    figure(FigHandle);
end

if nargin < 4
    Style = 'b';
end

AmplitudeValues = (abs(InputFreqData)/N).^0.5;

plot(f,AmplitudeValues,Style);
xlabel('Frequency [Hz]');
title('Magnitude Response');
axis([0 dF*length(InputFreqData)/2 0 (max(AmplitudeValues)*1.05)]);
grid on;
end
