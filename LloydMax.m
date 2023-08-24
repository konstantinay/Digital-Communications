function [xq, centers, D] = LloydMax(x, N, min_value, max_value)

[s, ~] = size(x);

%periorismos ths dynamikhs perioxhs toy shmatos(theloume peperasmeno shma)
if min(x) < min_value
    for i=1:s
        if x(i) < min_value
            x(i) = min_value;
        end
    end
end
if max(x) > max_value
    for i=1:s
        if x(i) > max_value
            x(i) = max_value;
        end
    end
end

%ypologizoyme to vhma kvantismou step kai ta kentra 
%opws ston omoiomorfo kvantisth
levels = 2^N;
step = (max_value - min_value) / levels; 
centers = [];
centers(1) = max_value - (step/2);
for i=2:levels
    centers(i) = centers(i-1) - step;
end

%ftiaxnoume th seira poy emfanizontai ta kentra kai prosthetoyme ta min,max
%values
centers = flip(centers);
centers = [min_value centers max_value];

%mesh paramorfwsh
D = [0 1];

%ylopoioume me vash ton algorithmo pou dinetai sthn ekfwnhsh
%epilegetai e = 10^-10
k=1;
sqnr = [];
n = 2;
while abs(D(n) - D(n-1)) >= 10^-10 
    %arxikopoihsh
    xq = [];
    qerror = 0;
    counted   = zeros(length(centers));
    cond_mean = zeros(length(centers));

    %ypologizoume ta oria twn zwnwn kvantismou wste na einai sto meso twn epipedwn
    %kvantismou
    T = [];
    T(1) = min_value;
    for i=2:(length(centers)-1)
        T(i) = (centers(i) + centers(i+1))/2;
    end
    T(i+1) = max_value;
    
    %gia to shma
    for i=1:s
        %me vash tis perioxes
        for j=1:(length(T)-2)
            if T(j) < x(i) && x(i) <= T(j+1)
                %to kvantismeno
                xq(i) = centers(j+1);
                %kanoyme accumulate to sfalma kvantishs gia na ypologisoyme
                %th mesh paramorfwsh parakatw
                qerror = qerror + abs(centers(j+1) - x(i));
                %pros8etoyme se ka8e metavlhth diasthmatos ta x 
                %poy antistoixisthkan se auth prokeimenou na vroume ta nea 
                %kentroeidh parakatw 
                cond_mean(j+1) = cond_mean(j+1) + x(i);
                counted(j+1)   = counted(j+1) + 1;
            end
        end
        %elaxisth timh
        if x(i) == T(1)
            xq(i) = centers(2);
            qerror = qerror + abs(centers(2) - x(i));
            cond_mean(2) = cond_mean(2) + x(i);
            counted(2) = counted(2) + 1;
        end
    end
    avg_distortion = qerror/s;
    
    D = [D avg_distortion];
    n = n + 1;

    %ypologizoume ta nea kentra gia tis zwnes
    for j=2:(length(centers)-1)
        if counted(j) ~= 0
            centers(j) = cond_mean(j)/counted(j);
        end
    end
    
    qnoise = mean((x - xq').^2);
    sqnr(k) = 10*log10(mean(x.^2)/qnoise);
    k=k+1;
end

%SQNR
figure;
plot(sqnr,'-b','LineWidth',2);
title(['PCM,N = ',num2str(N),'bits']);
ylabel('SQNR(db)')
xlabel('Iterations')

%Entropia
xx = unique(xq);
[elem, ~] = hist(xq,xx);
prob = elem/length(xq);     
Entropia = -prob*log2(prob)';
fprintf('H entropia gia N = %d einai %d \n',N,Entropia);

xq = xq';
end