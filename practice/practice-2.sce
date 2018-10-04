sampleRate = 48000;

simulationTimeSec = 0.002;

t = 0:1:(simulationTimeSec * sampleRate);

phaseFactor = 2 * %pi / sampleRate;

A = 1;
F = 1000;

y = complex(A * cos(phaseFactor * F * t), A * sin(phaseFactor * F * t));

scf();
clf();

plot(real(y), 'b');
plot(imag(y), 'r');
