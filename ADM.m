function xq = ADM(x)
    
    K = 1.5;
    d = zeros(length(x),1);
    d(1) = 0.1;
    
    %kwdikopoihths
    e(1) = x(1);
    b(1) = sign(e(1));
    e_q(1) = d(1) * b(1);
    xc(1) = e_q(1);
    
    %ylopoioume symfwna me tin ekfwnisi
    for n = 2:length(x)
        e(n) = x(n) - xc(n-1);
        b(n) = sign(e(n));
        
        if b(n) == b(n-1)
            d(n) = d(n-1)*K;
        else
            d(n) = d(n-1)/K;
        end
        
        e_q(n) = d(n) * b(n);
        xc(n) = xc(n-1) + e_q(n);
    end

    %apokwdikopoihths
    e_dec = b.*d';
    xq(1) = e_dec(1);
    for n = 2:length(x)
        xq(n) = e_dec(n) + xq(n-1);
    end
    xq = xq';
end