//
// Тест демодулятора F1B
//

exec SP.sci
exec F1B.sci
exec F1B_MC.sci


// Исходный сигнал

baudrate = 50;

frequencyDistance = 100;

//x = generateTelegraph(0, baudrate, frequencyDistance, '101011100');

[x, sourceData] = generateTelegraph(100 * calculateBitLength(baudrate), baudrate, frequencyDistance, '*');

printf("Source data     : %s\n", sourceData);


// Демодулируем его

[y, demodulatedData] = F1B_MC(x, baudrate, frequencyDistance);

printf("Demodulated data: %s\n", demodulatedData);


// Считаем количество ошибок

n = length(sourceData) - 1;

e = 0;

for i = 1:n
    
    if part(demodulatedData, i) <> part(sourceData, i) then
        
        e = e + 1;
    end
end

// Считаем вероятность ошибки

p = e / n;

printf('Error rate = %f; test length = %d\n', p, n);
