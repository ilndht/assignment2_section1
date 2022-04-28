%% This file import data from the csv and plot it and also find the yield strength 
close all ; clear all ; clc 
PVC_dat = readtable('PVC sample_1.csv');
lo = 40.746;
strain = PVC_dat.CompressiveDisplacement./lo ; 
do = 20.87*10^-3 ; 
S = pi*do^2/4 ; 
stress = PVC_dat.PrimaryForceMeasurement*1e-3./S ; 


figure(1) 
plot(strain,stress,'g*-','Linewidth',2)
xlabel('strain(mm/mm)','Fontsize',20)
ylabel('stress(MPa)','Fontsize',20)
title('PVC stress-strain ','Fontsize',30)
grid on 



% get the yiled point 
figure(2) 
plot(strain,stress,'g*-','Linewidth',2)
xlabel('strain(mm/mm)','Fontsize',20)
ylabel('stress(MPa)','Fontsize',20)
title('PVC stress-strain ','Fontsize',30)
grid on 
ylim([0 90])
xlim([0 0.05])

%linear regression 
start = 1 ; 
while strain(start)< 0.007
    start = start +1 ; 
end
stop = 1 ; 
while strain(stop)< 0.035
    stop = stop +1 ; 
end


xdata = strain(start:stop); 
ydata = stress(start:stop);

A=[sum(xdata.^2) sum(xdata);
    sum(xdata) length(xdata)];

C=[sum(xdata.*ydata);
    sum(ydata)];

vec=inv(A)*C;

% get modulus of elasticity 
a=vec(1);
b=vec(2);

x=linspace(-xdata(end)*0.05,xdata(end)*1.3);
y=a*x+b;

hold on 
plot(x,y,'r-','Linewidth',2) 
plot(x+0.002,y,'-','Linewidth',2)
plot_yield_point( 0.039104 , 75.745)

ydatamean = mean(ydata) ; 
sum_residual = sum((a.*xdata+b-ydata).^2); 
sum_tot = sum((ydata-ydatamean).^2);
R_square =  1 -  sum_residual/sum_tot
x = 0.335;
annotation('doublearrow',[x x+0.03 ],[0.3 0.3 ])
text(0.013,18,'0.002','FontSize',15)
legend('PVC stress-strain','Modulus of elasticity line', ' strain line', 'Yield strength')
 set(gca,'fontsize',20)

 fprintf('The Modulus of Elasticity is %8.4f GPa\n',a/1000);
 
 
function plot_yield_point(x,y)
    plot(x,y,'ro','MarkerSize',10,'MarkerFaceColor','r')
    plot([0 x x],[y y 0],'k-.')
end