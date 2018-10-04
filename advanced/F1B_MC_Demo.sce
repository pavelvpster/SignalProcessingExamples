//
// Демонстрация взаимокорреляционного демодулятора F1B
//

exec SP.sci
exec F1B.sci
exec F1B_MC.sci


// Исходный сигнал

baudrate = 50;

frequencyDistance = 100;

sourceData = '101011100';

printf("Source data = %s\n", sourceData);

x = generateTelegraph(0, baudrate, frequencyDistance, sourceData);


// Переносим частоты нажатия и отжатия на 0

f1 = complexHeterodyne(x, -frequencyDistance / 2);
f0 = complexHeterodyne(x,  frequencyDistance / 2);

// Рассчитываем канальный фильтр

bitLength = format.SampleRate / baudrate;

[cw, cf] = designChannelFIR(frequencyDistance, bitLength * 1.2);

// Формируем каналы 1 и 0

c1 = abs(conv(cw, f1));
c0 = abs(conv(cw, f0));

// Рассчитываем их разность

d = c1 - c0;

// Рассчитываем фильтр манипуляции

dw = ffilt("lp", bitLength * 1.2, (baudrate / 2) / format.SampleRate);

// Применяем его к разности

m = conv(dw, d);

// В начале сигнал еще не установился

m = m(bitLength * 1.2 : size(m, '*'));

// Применяем детектор знака

y = signDetector(m);

// Регенератор

[r, pos] = regenerator(m, bitLength, 5);

receivedData = '';

for i = 1:size(pos, '*')
    
    receivedData = receivedData + string( y( pos(i) ) );
end

printf("Demodulation result = %s\n", receivedData);


// Строим график стробирующих импульсов

s = [];

for i = 1:size(m, '*')
    
    s(i) = 0;
end

for i = 1:size(pos, '*')
    
    s(pos) = 1;
end


// Строим импульсную характеристику канального фильтра

[cwm, cfr] = frmag(cw, 1000);

cfr2 = cfr .* format.SampleRate;

// Расчитываем спектры сигналов

spX  = fft(x);
spF1 = fft(f1);
spF0 = fft(f0);

// Готовим вектор частот

f = format.SampleRate * (0:(size(x, '*')/2-1)) / size(x, '*');

// Количество отсчетов для построения

T = min(1000, size(x, '*'));

// Строим графики

scf();
clf();

subplot(3,3,1);
plot(real(x(1:T)), 'b');
plot(imag(x(1:T)), 'r');
xtitle("Исходный сигнал");

subplot(3,3,2);
plot(f(1:100), abs(spX(1:100)));
xtitle("Спектр исходного сигнала");

subplot(3,3,3);
plot(r, 'b');
xtitle("Среднее значение регенератора");

subplot(3,3,4);
plot(real(f1(1:T)), 'b');
plot(imag(f1(1:T)), 'r');
xtitle("Нажатие на 0");

subplot(3,3,5);
plot(real(f0(1:T)), 'b');
plot(imag(f0(1:T)), 'r');
xtitle("Отжатие на 0");

subplot(3,3,6);
plot(f(1:50), abs(spF1(1:50)), 'b');
plot(f(1:50), abs(spF0(1:50)), 'r');
plot(cfr2(1:50), cwm(1:50) .* 500, 'g');
xtitle("Спектры каналов");

subplot(3,3,7);
plot(c1(1:T), 'b');
xtitle("Нажатие");

subplot(3,3,8);
plot(c0(1:T), 'b');
xtitle("Отжатие");

subplot(3,3,9);
plot(m(1:T), 'r');
plot(y(1:T), 'b');
plot(s(1:T), 'g');
set(gca(), 'data_bounds', matrix([1, T, -1.5, 1.5],2,-1));
xtitle("Манипуляция и результат");
