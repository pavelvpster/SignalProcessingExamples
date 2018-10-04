sampleRate = 48000;

simulationTimeSec = 0.002;

t = 0:1:(simulationTimeSec * sampleRate);

phaseFactor = 2 * %pi / sampleRate;

A1 = 1;
F1 = 1000;

D = -2
A2 = (10 ^ (D / 20)) * A1;
F2 = 5000;

y = A1 * sin(phaseFactor * F1 * t) + A2 * sin(phaseFactor * F2 * t);

scf();
clf();

plot(y);
