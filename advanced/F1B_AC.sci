//
// Автокорреляционный демодулятор
//


//
// Автокорреляционный деректор
//
// Постоянная времени T равна длине волны в отсчетах
//
function [y]=autoCorrelator(x, T)
    
    for i=1:size(x, '*')
        
        if i > T then
            
            y(i) = real(x(i-T)) * imag(x(i)) - imag(x(i-T)) * real(x(i));
        else
            
            y(i) = 0;
        end
    end
    
endfunction


//
// Скользящее среднее
//
// Постоянная времени T равна длине посылки в отсчетах
//
function [y]=movingAverage(x, T)
    
    s = 0;
        
    for i=1:size(x, '*')
        
        if i > T then
            
            s = s - x(i-T) + x(i);
        end
            
        y(i) = s;
    end
    
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
// Автокорреляционный демодулятор F1B
//
function [y]=F1B_AC(x, baudrate, frequencyDistance)
    
    // Автокорреляционный детектор
    
    a = autoCorrelator(x, format.SampleRate / frequencyDistance);
    
    // Скользящее среднее
    
    m = movingAverage(a, format.SampleRate / baudrate);
    
    // Детектор знака
    
    y = signDetector(m);
    
endfunction
