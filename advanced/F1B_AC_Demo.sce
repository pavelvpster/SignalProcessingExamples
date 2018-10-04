//
// Демонстрация автокорреляционного демодулятора F1B
//

exec SP.sci
exec F1B.sci
exec F1B_AC.sci
exec F1B_Regenerator2.sci

// Количество отсчетов

n = 6000;

// Генерируем исходный сигнал

baudrate = 50;

frequencyDistance = 100;

x = generateTelegraph(n, baudrate, frequencyDistance, '.');


// Автокорреляционный детектор

a = autoCorrelator(x, format.SampleRate / frequencyDistance);

// Скользящее среднее

m = movingAverage(a, format.SampleRate / baudrate);

// Детектор знака

y = signDetector(m);


// Дифференциатор

d = differentiator(y);

// Осциллятор

o = ocsillator(d);

plot(o);



// Расчитываем спектры

spX = fft(x);

// Вектор частот

f = format.SampleRate * (0:(n/2-1)) / n;

// Количество отсчетов для построения

T = format.SampleRate / 5;

// Количество частот для построения

F = 500;

// Строим графики

scf();
clf();

subplot(4,2,1);
plot(real(x(1:T)), 'b');
plot(imag(x(1:T)), 'r');
xtitle("Исходный сигнал");

subplot(4,2,2);
plot(f(1:F), abs(spX(1:F)));
xtitle("Спектр исходного сигнала");

subplot(4,2,3);
plot(a(1:T), 'b');
xtitle("Автокорреляционный детектор");

subplot(4,2,5);
plot(m(1:T), 'b');
xtitle("Скользящее среднее");

subplot(4,2,7);
plot(y(1:T), 'b');
set(gca(), 'data_bounds', matrix([1, T, -0.1, 1.1],2,-1));
xtitle("Результат");
