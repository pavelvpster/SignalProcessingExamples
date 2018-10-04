//
// Демонстрация гетеродина
//

exec SP.sci

// Количество отсчетов

n = 6000;

// Генерируем исходный сигнал sin частотой 100 Гц

x = generateComplexSin(n, 100);

// Сдвигаем частоту на +200 Гц

y = complexHeterodyne(x, 200);

// Расчитываем спектры

spX = fft(x);
spY = fft(y);

// Вектор частот

f = format.SampleRate * (0:(n/2-1)) / n;

// Количество частот

F = size(f, '*');

// Количество отсчетов для построения

T = format.SampleRate / 50;

// Количество частот для построения

F = 500;

// Строим графики

scf();
clf();

subplot(2,2,1);
plot(real(x(1:T)), 'b');
plot(imag(x(1:T)), 'r');
xtitle("Исходный сигнал");

subplot(2,2,2);
plot(f(1:F), abs(spX(1:F)));
xtitle("Спектр исходного сигнала");

subplot(2,2,3);
plot(real(y(1:T)), 'b');
plot(imag(y(1:T)), 'r");
xtitle("Обработанный сигнал");

subplot(2,2,4);
plot(f(1:F), abs(spY(1:F)));
xtitle("Спектр обработанного сигнала");
