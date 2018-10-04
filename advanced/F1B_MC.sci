//
// Взаимокорреляционный демодулятор
//

exec F1B_Regenerator.sci


//
// Этот метод возвращает магнитуду фильтра на указанной частоте
//
function [mag, index]=getMag(h, frequency)
    
    n = 2000;
    
    [w, fr] = frmag(h, n);
    
    index = frequency / format.SampleRate * n * 2;
    
    mag = w(index);
    
endfunction


//
// Этот метод подбирает оптимальную частоту среза для фильтра так,
// чтобы его импульсная характеристика были минимальна на
// указанной частоте. Длина фиксирована.
//
// Метод возвращает передаточную функцию и частоту среза.
//
function [w, f]=designChannelFIR(frequency, n)
    
    f = frequency;
    
    fspace = linspace(0.5, 0.25, 100) .* frequency;
    
    minMag = 1000000;
    
    for i = 1:length(fspace)
        
        t = fspace(i);
        
        h = ffilt("lp", n, t / format.SampleRate);
        
        [mag, index] = getMag(h, frequency);
        
        if mag < minMag then
            
            f = t; minMag = mag;
        end
    end
    
    w = ffilt("lp", n, f / format.SampleRate);
    
endfunction


//
// Детектор знака
//
function [y]=signDetector(x)

    r = 0;
        
    for i=1:size(x, '*')
        
        if x(i) > 0.000001 then
            
            r = 1;
        end
        
        if x(i) < -0.000001 then
            
            r = 0;
        end
            
        y(i) = r;
    end
    
endfunction


//
// Взаимокорреляционный демодулятор F1B
//
function [y, data]=F1B_MC(x, baudrate, frequencyDistance)
    
    // Переносим частоты нажатия и отжатия на 0
    
    f1 = complexHeterodyne(x, -frequencyDistance / 2);
    f0 = complexHeterodyne(x,  frequencyDistance / 2);
    
    // Рассчитываем канальный фильтр
    
    bitLength = calculateBitLength(baudrate);
    
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
    
    data = '';
    
    for i = 1:size(pos, '*')
        
        data = data + string( y( pos(i) ) );
    end
    
    //printf("Demodulation result: %s\n", data);
    
endfunction
