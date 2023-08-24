close all; clear; clc

Tsample = 1;
Tc = 4;
Tsymbol = 40;
fc = 1/Tc;
gpulse = sqrt(2/Tsymbol);

%pithanoi syndyasmoi M,A,gray code
cases = [4,1/sqrt(5),0; 4,1/sqrt(5),1; 8,1/sqrt(21),0; 8,1/sqrt(21),1];

for n=1:4
    %arxikopoihsh analoga thn periptwsh
    M = cases(n,1);
    A = cases(n,2);
    gc = cases(n,3);
    
    %orismos twn diadikwn psifiwn pou theloume na paragoume
    Lb = 10000*log2(M);
    xbits = randsrc(Lb,1,[0 1]);
    insignal = reshape(xbits,Lb/log2(M),log2(M));
    
    %arxikopoihsh eksodou
    outsignal = insignal*0;
    ybits = xbits*0;
    
    %mhkos
    N = Lb/log2(M);
    
    %shma eksodou
    s1 = zeros(Lb/log2(M)*40,1);

    %symvola 
    %xwris gray code
    if(gc==0 && M==4)
        symbols=[0 0 ; 0 1 ; 1 0 ; 1 1];
    elseif(gc==0 && M==8)
        symbols=[0 0 0 ; 0 0 1 ; 0 1 0 ; 0 1 1; 1 0 0 ; 1 0 1 ; 1 1 0; 1 1 1 ];
    %me gray code
    elseif(gc==1 && M==4)
        symbols=[0 0 ; 0 1 ; 1 1 ; 1 0];
    else
        symbols=[0 0 0 ; 0 0 1 ; 0 1 1 ; 0 1 0; 1 1 0 ; 1 1 1 ; 1 0 1; 1 0 0 ];
    end

    snrcount = 1; %snr counter gia ta plots

    for snr=0:2:20
        k = 1;
        %PAM diamorfosi
        for i=1:N
        %vriskoume to m pou antistoixei se kathe symvolo
            for j=1:M
                if (sum(insignal(i,:)==symbols(j,:))==log2(M))
                    m=j;
                end
            end
        %ypologismos tis ekpempomenis seiras s(t)
            for t=0:Tsymbol-1
                s1(k) = (2*m-1-M)*A*gpulse*cos(2*pi*fc*t);
                k = k + 1;
            end
        end
        
    %ypologismos thoryvoy kai prosthesi
    s2 = (1/(2*log2(M)))*10^(-snr/10);
    noise = sqrt(s2)*randn(N*40,1);
    r = noise + s1;
    
    %PAM apodiamorfosi
    k = 1;
    for i=1:N
    %ypologismos tou kathe symvolou
        for t=0:Tsymbol-1
            rr(t+1) = r(k)*gpulse*cos(2*pi*fc*t);
            k = k+1;
        end
        rsymbol = sum(rr);
    %apostasi kathe symvolou
        for m=1:M
            sm = (2*m-1-M)*A;
            dist(m) = sqrt(sum((rsymbol-sm).^2));
        end
    %demapper
        [mnm,l] = min(dist);
        outsignal(i,:) = symbols(l,:);
    end
    %ypologismos tou ber kai ser gia kathe snr 
    ybits = outsignal(:);
    if(gc == 0)
        ber(n,snrcount) = sum(abs(ybits-xbits))/Lb;
        ser(n,snrcount) = sum(abs(bi2de(outsignal)-bi2de(insignal)))/N;
    else
        %afou den theloume ser gia gray code
        ber(n,snrcount) = sum(abs(ybits-xbits))/Lb;
    end    
    snrcount = snrcount + 1;    
    end
end

%plots
figure(1)
snr = 0:2:20;
semilogy(snr,ber,'*-');
title('BER of 4-PAM and 8-PAM with & without gray code')
xlabel('SNR');
legend ({'4-PAM','4-PAM gc','8-PAM','8-PAM gc'},'Location','southwest')

figure(2)
snr = 0:2:20;
semilogy(snr,ser,'^-');
title('SER of 4-PAM and 8-PAM, no gray code')
xlabel('SNR');
legend ({'4-PAM','8-PAM'},'Location','southwest')
