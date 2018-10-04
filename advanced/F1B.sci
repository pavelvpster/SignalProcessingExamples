//
// Телеграф
//


//
// Этот метод возвращает длину бита в отсчетах на указанной скорости
//
function [l]=calculateBitLength(baudrate)
    
    l = format.SampleRate / baudrate;
    
endfunction


//
// Модулятор F1B
//
// Если n равно 0, то генерируется сигнал длина которого соответствует последовательности;
// в противном случае последовательность повторяется до требуемой длины сигнала.
//
function [y, data]=generateTelegraph(n, baudrate, frequencyDistance, pattern)
    
    phase = 0;
    
    phaseStep = calculatePhaseStep(frequencyDistance / 2);
    
    period = 2 * %pi;
    
    bitLength = calculateBitLength(baudrate);
    
    if n == 0 then
        
        n = length(pattern) * bitLength;
    end
    
    bitSamples = 0;

    [bit, pos] = updateBit(1, pattern, 1);
    
    data = string(bit);
    
    // Генерируем сигнал
    
    for i = 1:n
        
        y(i) = complex(cos(phase), sin(phase));
        
        if bit == 1 then
            
            phase = phase + phaseStep;
        else
            
            phase = phase - phaseStep;
        end
        
        // Заворачиваем фазу
        
        if phase > period then
            
            phase = phase - period;
        end
        
        if phase < -period then
            
            phase = phase + period;
        end
        
        // Обновляем значение бита
        
        bitSamples = bitSamples + 1;
        
        if bitSamples == bitLength then
            
            bitSamples = 0;
            
            [bit, pos] = updateBit(bit, pattern, pos);
            
            data = data + string(bit);
        end
    end

endfunction


function [newBit, newPos]=updateBit(bit, pattern, pos)
    
    if pattern == '.' then
        
        if bit == 1 then
            
            newBit = 0;
        else
            
            newBit = 1;
        end
        
        newPos = 1;
        
        return;
    end
    
    if pattern == '*' then
        
        if rand() > 0.5 then
            
            newBit = 1;
        else
            
            newBit = 0;
        end
        
        newPos = 1;
        
        return;
    end
    
    if part(pattern, pos) == '1' then
        
        newBit = 1;
    else
        
        newBit = 0;
    end
    
    newPos = pos + 1;
    
    if newPos > length(pattern) then
        
        newPos = 1;
    end
    
endfunction
