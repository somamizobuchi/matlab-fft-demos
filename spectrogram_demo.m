Fs = 44100;         % sampling frequency (Hz)
duration = 1;       % duration (sec)
N = Fs*duration;    % number of samples
t = (0:N-1)/Fs;     % time vector (sec)

fp = 440;
harmonics = [1 2 3];
amps = [0.3 0.2 0.1];
x = amps.*sin(2*pi*fp*harmonics.*t');
x_sum = sum(x, 2);      % Sum of the signals
x = reshape(x, [], 1);  % Continuous signal
% x = x + rand(size(x));
figure;
plot(x_sum);
%%
sound(x_sum, Fs);
pause(2);
sound(x, Fs);
%%
figure;
tl = tiledlayout(2, 1);
% fft
L = length(x);
X_fft = fft(x);
P_fft = (abs(2*X_fft(1:L/2+1)).^2);
f = Fs*(0:L/2)/L;
h1 = nexttile;
plot(f, P_fft, 'LineWidth', 1.5);
set(gca, 'LineWidth', 2, 'FontSize', 18);

% fft
L = length(x_sum);
X_fft = fft(x_sum);
P_fft = (abs(2*X_fft(1:L/2+1)).^2);
f = Fs*(0:L/2)/L;
h2 = nexttile;
plot(f, P_fft, 'LineWidth', 1.5);
set(gca, 'LineWidth', 2, 'FontSize', 18);

linkaxes([h1 h2], 'x');
xlim([0 1500]);
xlabel(tl, "Frequency (Hz)", 'FontSize', 18);
ylabel(tl, "|F(\omega)|", 'FontSize', 18);
%% Plot the spectrogram
nw = 3000;
figure;
spectrogram(x, hanning(nw), [], [], Fs, 'yaxis');
ylim([0 1.5]);
set(gca, 'FontSize', 18);
%% Let's look at the peak
[s, f, t] = spectrogram(x, hanning(nw), [], [], Fs, 'yaxis');
[~, midx] = max(abs(s), [], 1);

figure; plot(t, f(midx), 'o-');
title("Peak amplitude");
xlabel("time (sec)");
ylabel("frequency (Hz)");
%%
recObj = audiorecorder(Fs,16,1);
recDuration = 3;
disp("Begin speaking.")
recordblocking(recObj,recDuration);
disp("End of recording.")
play(recObj);
%% Let's look at the peak
nw = 10000;
[s, f, t] = spectrogram(getaudiodata(recObj), hanning(nw), [], [], recObj.SampleRate, 'yaxis');
[~, midx] = max(abs(s), [], 1);

figure;
tiledlayout(2, 1)

nexttile;
pcolor(t, f, pow2db(abs(s).^2));
ylim([0 2000]);
shading interp;
title("Spectrogram");
colormap hot;

fp = 440;
fharm = [1/2 1 2];
nexttile; plot(t, f(midx), 'o-');
yline(fp.*fharm);
title("Peak amplitude");
xlabel("time (sec)");
ylabel("frequency (Hz)");

%% Error
fp = 440;
fharm = [1/2 1 2 3];
score = min(sum(f(midx) - fp.*fharm, 1).^2 ./ length(t));
disp("Score: " + string(score));