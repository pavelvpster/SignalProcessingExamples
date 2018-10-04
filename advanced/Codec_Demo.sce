//
// Демонстрация кодека
//

exec Codec.sci


//
// Готовим данные:
//
// До начала сообщения нули; потом 10 бит точек для синхронизации;
// потом еще немного нулей; потом символы 'AAA' (начало текста);
// потом произвольный текст; потом символы 'ZZZ' (конец текста).
//

x = '0000000000' + '1010101010' + '0000000000' + encodeText('AAA HELLO WORLD ZZZ') + '0000000000';


// Декодируем

pos = 2;


// Детектор точек

p = 0;

while pos < length(x)
    
    b = part(x, pos-1);
    a = part(x, pos  );
    
    pos = pos + 1;
    
    if a <> b then
        
        p = p + 1;
        
        if p >= 10 then
            
            break;
        end
    end
end

if p < 10 then
    
    printf('Error! Synchronization failed.\n');
    return;
end

printf('Synchronized at %d\n', pos);


// Обнаруживаем начало текста

p = 0;

while pos < length(x)
    
    data = part(x, pos:(pos+5-1));
    
    chr = decodeOne(data);
    
    if chr == 'A' then
        
        pos = pos + 5;
        
        p = p + 1;
        
        if p >= 3 then
            
            break;
        end
    else
        
        pos = pos + 1;
        
        // Сброс, поскольку нужно точно 'AAA'
        
        p = 0;
    end
end

if p < 3 then
    
    printf('Error! Start not found.\n');
    return;
end

printf('Start found at %d\n', pos);


// Декудируем текст до конца текста

text = '';

p = 0;

while p < length(x)
    
    data = part(x, pos:(pos+5-1));
    
    chr = decodeOne(data);
    
    if chr == 'Z' then
        
        p = p + 1;
        
        if p >= 3 then
            
            break;
        end
    else
        
        // Сброс, поскольку нужно точно 'ZZZ'
        
        p = 0;
        
        // Сохраняем символ
        
        text = text + chr;
    end
    
    pos = pos + 5;
end

if p < 3 then
    
    printf('Error! Stop not found.\n');
    return;
end

printf('Stop found at %d\n', pos);


// Готово

printf('Decoded text: %s\n', text);
