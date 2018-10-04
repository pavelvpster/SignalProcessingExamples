//
// Регенератор F1B
//


//
// Этот метод возвращает индекс максимального элемента вектора
//
function [index]=indexofMax(x)
    
    index = 0;
    
    maxX = 0;
    
    for i = 1:size(x, '*')
        
        if x(i) > maxX then
            
            index = i; maxX = x(i);
        end
    end
    
endfunction


//
// Этот метод сдвигает содержимое вектора на указанное смещение;
// длина вектора не изменяется; значения для которых нет данных,
// устанавливаются равными 0.
//
function [y]=shiftVector(x, d)
    
    y = [];
    
    for i = 1:size(x, '*')
        
        y(i) = 0;
    end
    
    for i = 1:size(x, '*')
        
        p = i + d;
        
        if p > 1 & p < size(y, '*') then
            
            y(p) = x(i);
        end
    end
    
endfunction


//
// Регенератор
//
function [y, pos]=regenerator(x, bitLength, n)
    
    // Инициализируем переменные
    
    y = [];
    
    for i = 1:bitLength
        
        y(i) = 0;
    end
    
    pos = [];
    
    a = 2 / (n + 1);
    
    // Регенератор
    
    i = 1;
    j = 1;
    
    while i < size(x, '*')
        
        // EWMA
        
        y(j) = (1-a) * y(j) + a * x(i) * x(i);
        
        i = i + 1;
        j = j + 1;
        
        if j > bitLength then
            
            j = 1;
            
            // Сохраняем положение максимума
            
            p = indexofMax(y);
            
            pos = [pos; (i - bitLength + p)];
            
            // Рассчитываем смещение максимума от центра посылки
            
            d = p - bitLength / 2;
            
            // printf('Bit finished at i = %d; displacement of max = %d\n', i, d);
            
            // Центрируем усредненный сигнал
            
            y = shiftVector(y, -d);
            
            i = i + d;
        end
    end
    
endfunction
