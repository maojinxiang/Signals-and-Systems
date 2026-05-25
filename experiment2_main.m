clc,clear,close all;
dt=0.01;
t=-6*pi:dt:6*pi;
Sa_t=sinc(t/pi);
dw=0.01;
w=-6*pi:dw:6*pi;
Sa_w = sig_spec_w(t,Sa_t,dt,w);
subplot(411);
plot(t,Sa_t),grid on;
title('Sa函数');
subplot(412);
plot(w,abs(Sa_w)),grid on;
title('Sa函数的频谱')
xlabel('w'),ylabel('|Sa_w|');
axis([min(w)-0.1,max(w)+0.1,min(abs(Sa_w))-0.1,max(abs(Sa_w))+0.1]);
set(gca,'xtick',[-15:15]);
s_t=Sa_t.*cos(4.*t) + Sa_t.*cos(8.*t);
subplot(413);
plot(t,s_t),grid on;
title('FDM时域');
s_w=sig_spec_w(t,s_t,dt,w);
subplot(414);
plot(w,abs(s_w));
title('FDM频域')
axis([min(w)-0.1,max(w)+0.1,min(abs(s_w))-0.1,max(abs(s_w))+0.1]);
set(gca,'xtick',[-15:15]);
