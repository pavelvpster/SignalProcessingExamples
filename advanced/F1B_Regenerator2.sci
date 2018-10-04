//
// Регенератор F1B (вариант 2 для автокорреляционного демодулятора)
//


//
// Дифференциатор
//
function [y]=differentiator(x)
    
    y(1) = 0;
    
    for i = 2:size(x, '*')
        
        d = x(i-1) - x(i);
        
        if d == 0 then
            
            y(i) = 0;
        else
            
            y(i) = 1;
        end
    end
    
endfunction


//
// Осциллятор
//
function [y]=ocsillator(x)
    
    s = [ 0, 0 ];
    
    t = 0;
    
    k = [ 0.00158587, -1.95319316, 0.99682826 ];
    
    for i = 1:size(x, '*')
        
        s(1) = s(2);
        s(2) = t;
        
        t = k(1) * x(i) - k(2) * s(2) - k(3) * s(1);
        
        y(i) = t - s(1);
    end
    
endfunction


//
// Регенератор
//
function [y]=regenerator(x, bitLength, n)
    
    // Дифференциатор
    
    d = differentiator(x);
    
    // Осциллятор
    
    y = oscillator(d);
    
endfunction
