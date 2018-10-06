sampleRate = 48000;

simulationTimeSec = 0.002;

t = 0:1:(simulationTimeSec * sampleRate);

phaseFactor = 2 * %pi / sampleRate;

A = 1;
F = 1000;

y = complex(A * cos(phaseFactor * F * t), A * sin(phaseFactor * F * t));

nSamples = size(t, '*');

z = fft(y) / nSamples;

f = sampleRate / N * (0:nSamples / 2);

nFrequencies = min(10, size(f, '*'));

scf();
clf();

subplot(2,1,1);
plot(real(y), 'b');
plot(imag(y), 'r');

subplot(2,1,2);
plot(f(1:nFrequencies), abs(z(1:nFrequencies)));
