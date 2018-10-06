sampleRate = 48000;

simulationTimeSec = 0.002;

t = 0:1:(simulationTimeSec * sampleRate);

phaseFactor = 2 * %pi / sampleRate;

A = 1;
F = 1000;
W = 1000;

x = complex(A * cos(phaseFactor * F * t), A * sin(phaseFactor * F * t));

// sample-by-sample solution (non optimal)

phase = 0;
phaseStep = W * phaseFactor;

period = 2 * %pi;

for i = 1:size(x, '*')
    
    I = real(x(i));
    Q = imag(x(i));
    
    newI = I * cos(phase) - Q * sin(phase);
    newQ = I * sin(phase) + Q * cos(phase);
    
    y(i) = complex(newI, newQ);
    
    phase = phase + phaseStep;
    if phase > period then
        phase = phase - period;
    end
end

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
