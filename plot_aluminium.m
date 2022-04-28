%% This MATLAB file plot ceramic stress strain diagram of ceramic and find the modulus of elasticity and yield strength. 
close all ; clear all ; clc 
PVC_dat = readtable('aluminium sample_1.csv');
lo = 17.55 ;
strain = PVC_dat.CompressiveDisplacement./lo ; 


do = 11.86*10^-3 ;
S = pi*do^2/4;
stress = PVC_dat.PrimaryForceMeasurement*1e-3./S ;

figure(1) 
plot(strain,stress,'bo-','Linewidth',1)
xlabel('strain(mm/mm)','Fontsize',20)
ylabel('stress(MPa)','Fontsize',20)
title('Aluminum stress-strain ','Fontsize',30)
grid on 

figure(2) 
plot(strain,stress,'bo-','Linewidth',1)
xlabel('strain(mm/mm)','Fontsize',20)
ylabel('stress(MPa)','Fontsize',20)
title('Aluminum stress-strain ','Fontsize',30)
grid on 
ylim([0 200])
xlim([0 0.05])



%linear regression to find Modulus of Elasticity 
start = 1 ; 
while strain(start)< 0.006
    start = start +1 ; 
end
stop = 1 ; 
while strain(stop)< 0.016
    stop = stop +1 ; 
end


xdata = strain(start:stop); 
ydata = stress(start:stop);

A=[sum(xdata.^2) sum(xdata);
    sum(xdata) length(xdata)];

C=[sum(xdata.*ydata);
    sum(ydata)];

vec=inv(A)*C;

a=vec(1);
b=vec(2);

x=linspace(-xdata(end)*0.05,xdata(end)*1.3);
y=a*x+b;

hold on 
plot(x,y,'r-','Linewidth',2) 
plot(x+0.002,y,'-','Linewidth',2)
plot_yield_point( 0.02098 , 161.7)

ydatamean = mean(ydata) ; 
sum_residual = sum((a.*xdata+b-ydata).^2); 
sum_tot = sum((ydata-ydatamean).^2);
R_square =  1 -  sum_residual/sum_tot
x = 0.225;
annotation('doublearrow',[x x+0.03 ],[0.2 0.2 ])
text(0.006,18,'0.002','FontSize',15)
legend('aluminum stress-strain','Modulus of elasticity line', ' strain line', 'Yield strength')
 set(gca,'fontsize',20)

  fprintf('The Modulus of Elasticity is %8.4f GPa\n',a/1000);
 
 
function plot_yield_point(x,y)
    plot(x,y,'ro','MarkerSize',10,'MarkerFaceColor','r')
    plot([0 x x],[y y 0],'k-.')
end

