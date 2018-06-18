clear;

%% change here for your data
center_wavelength = 650;
time_range = 50;

%% main script
[FileName, PathName, FilterIndex] = uigetfile('*img.dat');
FullPath = [PathName '/' FileName];
z = dlmread(FullPath);


wl = linspace(507.8667, 794.3751, 640);
wl = wl + center_wavelength - 650;% need check
time = linspace(0, 50.0111, 480);% need check

raw = zeros(size(z) + [2 1]);
raw(3:end,2:end) = z;
raw(3:end,1) = time;
raw(1,2:end) = 0;
raw(2,2:end) = wl;
dlmwrite([FileName '.PLdat'],raw);

