
format = struct('SampleRate', 6000);


function [phaseStep]=calculatePhaseStep(frequency)
    
    phaseStep = 2 * %pi * frequency / format.SampleRate;

endfunction


function [y]=generateComplexSin(n, frequency)
    
    phase = 0;
    
    phaseStep = calculatePhaseStep(frequency);
    
    period = 2 * %pi;
    
    for i = 1:n
        
        y(i) = complex(cos(phase), sin(phase));
        
        phase = phase + phaseStep;
        
        if phase > period then
            
            phase = phase - period;
        end
    end
    
endfunction


function [y]=complexHeterodyne(x, frequency)
    
    phase = 0;
    
    phaseStep = calculatePhaseStep(frequency);
    
    period = 2 * %pi;
    
    for i = 1:size(x, '*')
        
        I = real(x(i));
        Q = imag(x(i));
        
        newI = I * cos(phase) - Q * sin(phase);
        newQ = I * sin(phase) + Q * cos(phase);
        
        y(i) = complex(newI, newQ);
        
        phase = phase + phaseStep;
        
        if phase > period then
            
            phase = phase - period;
        end
    end
    
endfunction
