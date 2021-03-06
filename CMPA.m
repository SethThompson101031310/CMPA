% Name: Seth Thompson
% Student Number: 101031310

close all
clear
clc

% March 6th PA: Device Compact Models

% 1) Generating data for Is, Ib, Vb, and Gp.

% Defining constants given in the PA handout
Is = 0.01e-12; % Amps
Ib = 0.1e-12; % Amps
Vb = 1.3; % Volts
Gp = 0.1; % Seinmens

% Creating V vector as described in the PA handout. 
V = linspace(-1.95,0.7,200);

% Creating an anonymous function for the *correct* current equation
Ifunc = @(v) Is*(exp((1.2*v)/0.025) - 1) + Gp*v - Ib*(exp((-1.2*(v + Vb))/0.025) - 1);

% Creatin a loop that will make an I vector
for n = 1:200
    I(n) = Ifunc(V(n));
end

% Using the rand vector to make the 'experimental noise'
Irand = I + I.*rand(1,200)*0.2;

% Plotting the data on linear axis
figure(1)
plot(V,I)
hold on
plot(V,Irand)
grid on
title({'I-V curves with no noise and 20% noise | LINEAR','Seth Thompson | 101031310'})
xlabel('Voltage (V)')
ylabel('Current (A)')
legend('No noise', '20% Noise')

% plotting the data with a logarithmic y axis
figure(2)
semilogy(V,abs(I))
hold on
semilogy(V,abs(Irand))
grid on
title({'I-V curves with no noise and 20% noise | LOG','Seth Thompson | 101031310'})
xlabel('Voltage (V)')
ylabel('Current (A)')
legend('No noise', '20% Noise')

% Using polyfit to get a solution
polySol4 = polyfit(V,Irand,4);
polySol8 = polyfit(V,Irand,8);

% using polyval to get answers to polysol's
polyAns4 = polyval(polySol4,V);
polyAns8 = polyval(polySol8,V);
% plotting the new solutions
figure(3)
plot(V,I)
hold on
plot(V,Irand)
grid on
plot(V,polyAns4)
plot(V,polyAns8)
title({'I-V curves with no noise and 20% noise, and polynomial fits | LINEAR','Seth Thompson | 101031310'})
xlabel('Voltage (V)')
ylabel('Current (A)')
legend('No noise', '20% Noise', '4th-order solution', '8th-order solution')

figure(4)
semilogy(V,abs(I))
hold on
semilogy(V,abs(Irand))
grid on
semilogy(V,abs(polyAns4))
semilogy(V,abs(polyAns8))
title({'I-V curves with no noise and 20% noise, and polynomial fits | LOG','Seth Thompson | 101031310'})
xlabel('Voltage (V)')
ylabel('Current (A)')
legend('No noise', '20% Noise', '4th-order solution', '8th-order solution')

% Solving using non-linear curve fitting

% Setting B and D to the values used in question 1
f1 = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)'); 
f1ans = fit(V',Irand',f1);

% Setting D to what it was in equation 1
f2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)'); 
f2ans = fit(V',Irand',f2);

% Setting none of the parameters equal to the values given in question 1.
f3 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)'); 
f3ans = fit(V',Irand',f3);

% making vectors that will hold the solutions for the curves
f1plot = f1ans(V);
f2plot = f2ans(V);
f3plot = f3ans(V);

% Plotting the results
figure(5)
plot(V,I)
hold on
plot(V,Irand)
grid on
plot(V,f1plot)
plot(V,f2plot)
plot(V,f3plot)
title({'I-V curves with no noise and 20% noise, and fitted coefficents | LINEAR','Seth Thompson | 101031310'})
xlabel('Voltage (V)')
ylabel('Current (A)')
legend('No noise', '20% Noise', 'B and D defined', 'D defined', 'none defined')

figure(6)
semilogy(V,abs(I))
hold on
semilogy(V,abs(Irand))
grid on
semilogy(V,abs(f1plot))
semilogy(V,abs(f2plot))
semilogy(V,abs(f3plot))
title({'I-V curves with no noise and 20% noise, and fitted coefficents | LOG','Seth Thompson | 101031310'})
xlabel('Voltage (V)')
ylabel('Current (A)')
legend('No noise', '20% Noise', 'B and D defined', 'D defined', 'none defined')

% Fitting using the neural net method

% Putting in provided code
inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net);
Inn = outputs;

% Plotting solution made from neural net method!
figure(7)
plot(V,I)
hold on
plot(V,Irand)
grid on
plot(V,Inn)
title({'I-V curves with no noise and 20% noise, neural net method | LINEAR','Seth Thompson | 101031310'})
xlabel('Voltage (V)')
ylabel('Current (A)')
legend('No noise', '20% Noise', 'Neural Net solution')

figure(8)
semilogy(V,abs(I))
hold on
semilogy(V,abs(Irand))
grid on
semilogy(V,abs(Inn))
title({'I-V curves with no noise and 20% noise, neural net method | LINEAR','Seth Thompson | 101031310'})
xlabel('Voltage (V)')
ylabel('Current (A)')
legend('No noise', '20% Noise', 'Neural Net solution')