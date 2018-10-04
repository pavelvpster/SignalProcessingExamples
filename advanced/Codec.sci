//
// Кодек
//


//
// Этот метод преобразует строку вида '1010101010' в соответствующий массив цифр (1 или 0)
//
function [a]=stringToArray(s)
    
    a = [];
    
    for i = 1:length(s)
        
        if part(s, i) == '1' then
            
            a = [a; 1];
            
            continue;
        end
        
        if part(s, i) == '0' then
            
            a = [a; 0];
            
            continue;
        end
        
        printf("Error! Wrong chracter at position %d.\n", i);
        return;
    end
    
endfunction


//
// Этот метод преобразует массив цифр (1 или 0) в строку.
//
function [s]=arrayToString(x)
    
    s = '';
    
    for i = 1:size(x, '*')
        
        if x(i) == 1 then
            
            s = s + '1';
            
            continue;
        end
        
        if x(i) == 0 then
            
            s = s + '0';
            
            continue;
        end
        
        printf("Error! Wrong value at position %d.\n", i);
        return;
    end
    
endfunction


//
// Таблица символов нашего кода
//

characters = [

    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    ' '
];

bits = [

    '00001',
    '00010',
    '00011',
    '00100',
    '00101',
    '00110',
    '00111',
    '01000',
    '01001',
    '01010',
    '01011',
    '01100',
    '01101',
    '01110',
    '01111',
    '10000',
    '10001',
    '10010',
    '10011',
    '10100',
    '10101',
    '10110',
    '10111',
    '11000',
    '11001',
    '11010',
    '11111'
];


//
// Этот метод кодирует один символ
//
function [data]=encodeOne(chr)
    
    data = '';
    
    for i = 1:size(characters, '*')
        
        if chr == characters(i) then
            
            data = bits(i);
            
            break;
        end
    end
    
endfunction


//
// Этот метод кодирует текст
//
function [data]=encodeText(text)
    
    data = '';
    
    for i = 1:length(text)
        
        chr = part(text, i);
        
        data = data + encodeOne(chr);
    end
    
endfunction


//
// Этот метод декодирует один символ
//
function [chr]=decodeOne(data)
    
    chr = '';
    
    for i = 1:size(bits, '*')
        
        if bits(i) == data then
            
            chr = characters(i);
            
            break;
        end
    end
    
endfunction


//
// Этот метод декодирует текст
//
function [text]=decodeText(data)
    
    text = '';
    
    pos = 1;
    
    for i = 1:length(data)
        
        chr = part(data, pos:(pos+5-1));
        
        pos = pos + 5;
        
        text = text + decodeOne(chr);
    end
    
endfunction
