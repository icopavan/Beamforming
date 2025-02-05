% Determine the Allan Variance from recorded frequency data

%
% Use the phase to perform Allan variance estimation using the formula:
% Allan[k]=(1/(2k^2tau_0(N-2k))sumn=0toN-2k-1(x[n+2k]-2x[n+k]+x[n])^2


% Known Parameters:
% fs - sampling frequency
% largebuffer - the buffer with data recorded at fs

%clear;
%clc;
%load('recording2.mat');
%L = 3650000; %= length(largebuffer); % number of frequency estimations
%

Lf = 600000;
fc = 900e6; %nominal carrier frequency (900MHz)
%t0=0.512;
t0=0.001;
N = Lf;
%x=randn(1204,1);

%q1=zeros(1,7);
%for iteration = 1%:7
    sumx=0;
    x=DELnm(1,:); %unwrap(p_mat(:,iteration))/(2*pi*fc);
    for k = 1:N/3
        n=3;
        while n*k<N
            sumx = sumx+(x(n*k)-2*x((n-1)*k)+x((n-2)*k))^2;
            n=n+1;
        end
        Allanv_phase(k) = sumx/(2*(k*t0)^2*n);
        k
    end
    %dfit = polyfitn(timevec,Allanv_phase(iteration,:),'constant, x^-1');
    %q1(iteration) = dfit.Coefficients(2);
%end
timevec=t0*(1:N/3);

figure
loglog(timevec,Allanv_phase(1:N/3));

xdata = timevec;%tau;
ydata = Allanv_phase(1:length(xdata));%sigma;

A = [1./xdata; xdata./3]'; %create the A vector for parameters

q12 = inv(A'*A)*A'*(ydata)'; % compute the least squares matrix fit
% for iteration = 1:7
%      dfit = polyfitn(timevec,Allanv_phase(iteration,:),'constant, x^-1');
%     q1(iteration) = dfit.Coefficients(2);
% end

% % Fit data to a curve of the form q1/x
% dfit = polyfitn(timevec,Allanv,'constant, x^-1');
% q1 = dfit.Coeffcients(2);
% 
% xlabel('Tau (sec)')
% ylabel('{\sigma_v}^2');
