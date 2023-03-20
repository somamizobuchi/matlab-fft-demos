w = 64;
X = zeros(w);
x = rescale(real(ifft2(fftshift(X))));

figure('Position', [0 0 1024 480]);
tiledlayout(1,2);
nexttile;
p_f = imshow(X, 'XData', -w/2+1:w/2, 'YData', -w/2+1:w/2);
title("f(x,y)", 'Interpreter','latex');
axis on;

nexttile;
p_x = imshow(x, 'XData', -w/2+1:w/2, 'YData', -w/2+1:w/2);
title("F(u,v)", 'Interpreter','latex');
axis on;
%% Correspondence in the frequency domain
for f = [-w/2+1:2:w/2 fliplr(-w/2:1:w/2-1)]
    X = zeros(w);
    X(w/2-f,w/2+1) = 1;
    p_f.CData = X;

    x = rescale(real(ifft2(fftshift(X))));
    p_x.CData = x;
    pause(0.1);
    drawnow;
end

for f = [-w/2+1:2:w/2 fliplr(-w/2:1:w/2-1)]
    X = zeros(w);
    X(w/2+1,w/2+f+1) = 1;
    p_f.CData = X;

    x = rescale(real(ifft2(fftshift(X))));
    p_x.CData = x;
    pause(0.1);
    drawnow;
end

r = w/4;
for theta = 0:pi/30:2*pi
    X = zeros(w);
    X(w/2-round(r.*sin(theta)),w/2+round(r.*cos(theta))) = 1;
    p_f.CData = X;

    x = rescale(real(ifft2(fftshift(X))));
    p_x.CData = x;
    pause(0.1);
    drawnow;
end

%%
im = im2gray(imread("cool.png"));

% fft2
IM = fftshift(fft2(im));
figure;
surf(abs(IM)); 
shading interp;
colorbar;
set(gca, 'ZScale', 'log');
%% Demo of incrementally adding frequencies
w = size(im, 1);
X_cum = zeros(size(im));

figure;
tl = tiledlayout(1, 2);

nexttile;
p_X = imshow(X_cum, 'XData', -w/2+1:w/2, 'YData', -w/2+1:w/2);
title("F(u, v)", 'Interpreter','latex');
axis on;

nexttile;
p_x = imshow(X_cum, 'XData', -w/2+1:w/2, 'YData', -w/2+1:w/2);
title("F(u, v)", 'Interpreter','latex');
axis on;

tltitle = title(tl, "N_{coeffs} = 0");

ii = spiral(width(IM));
i_rev = numel(im) - ii + 1;
for i = 1:numel(IM)
    tltitle.String = sprintf("N_{coeffs} = %d", i);
    X_cum(ii == i) = IM(ii == i);
    x = ifft2(fftshift(X_cum));
    if (mod(i, 10) == 0)
        p_X.CData = rescale(abs(X_cum));
        p_x.CData = rescale(real(x));
    %     pause(0.05);
        drawnow;
    end
end
%% Why Phase matters
% randomize the phase while keeping the amplitude constant
rndPhase = rand(size(IM)) * 2 * pi - pi;
X_rnd = abs(IM).*exp(1i*rndPhase);
X_rndM = rand(size(IM)).*exp(1i*angle(IM));

figure;
tiledlayout(3, 2, "TileSpacing","tight")
nexttile;
imshow(rescale(log(abs(IM))));
title("$| F(u, v) |$", "Interpreter","latex");
set(gca, 'FontSize', 18);

nexttile;
imshow(rescale(abs(im)));
title("f(x,y)", 'Interpreter','latex');
set(gca, 'FontSize', 18);

nexttile;
imshow(rescale(log(abs(X_rnd))));

nexttile;
imshow(rescale(real(ifft2(fftshift(X_rnd)))), 'XData', -w/2+1:w/2, 'YData', -w/2+1:w/2);
title("Phase randomized");
set(gca, 'FontSize', 18);

nexttile;
imshow(rescale(log(abs(X_rndM))));

nexttile;
imshow(rescale(real(ifft2(fftshift(X_rndM)))), 'XData', -w/2+1:w/2, 'YData', -w/2+1:w/2);
title("Amplitude randomized");
set(gca, 'FontSize', 18);
%%
im2 = im2gray(imread("happy.png"));
IM2 = fftshift(fft2(im2));

Mix1 = abs(IM) .* exp(1i.*angle(IM2));
Mix2 = abs(IM2) .* exp(1i.*angle(IM));
figure;
tiledlayout(2,2, "TileSpacing","tight");

nexttile;
imshow(im);
title("I_1");
set(gca, 'FontSize', 18);

nexttile;
imshow(im2);
title("I_2");
set(gca, 'FontSize', 18);

nexttile;
imshow(rescale(real(ifft2(fftshift(Mix1)))), 'XData', -w/2+1:w/2, 'YData', -w/2+1:w/2);
title("I_1\angle I_2");
set(gca, 'FontSize', 18);

nexttile;
imshow(rescale(real(ifft2(fftshift(Mix2)))), 'XData', -w/2+1:w/2, 'YData', -w/2+1:w/2);
title("I_2\angle I_3");
set(gca, 'FontSize', 18);
%%