clc,clear,close all;
dt=0.01;
t=-1:dt:1;
gt=1.*(t>=-0.5&t<=0.5);
dw=0.01;
w=-6*pi:dw:6*pi;
Gw = sig_spec_w(t,gt,dt,w);
subplot(211);
plot(t,gt);
title('门函数');
axis([-1,1,-0.1,1.1]);
subplot(212);
plot(w,abs(Gw)),grid on;
title('门函数的频谱')
xlabel('w'),ylabel('|G(w)|');
axis([min(w)-0.1,max(w)+0.1,min(abs(Gw))-0.1,max(abs(Gw))+0.1]);


