%数字振荡器产生4位号码各种对应的DTMF信号
clc,clear,close all;
fs=8000; %采样频率
Ts=1/fs; %采样间隔
f = 500:0.01:2000;
t=0:Ts:0.05; %传送过程中DTMF持续时间为50ms
xn = zeros(size(t));
xn(1)=1;
LFZ=[697 770 852 941]; %行低频对应的低频组
HFZ=[1209 1336 1447]; %列高频对应的高频组
code=['1','2','3','A';'4','5','6','B';'7','8','9','C';'*','0','#','D'];
key=input('please input key value,0~9 or # or *:','s'); %通过键盘连续输入4位号码
N=0.15/Ts; %号码之间的静音补零
y=[]; %记录所有所拨号码
for i=1:length(key)
    if(key(i)=='0')
        fL=LFZ(4);
        fH=HFZ(2);
    end
    if(key(i)=='1')
        fL=LFZ(1);
        fH=HFZ(1);
    end
    if(key(i)=='2')
        fL=LFZ(1);
        fH=HFZ(2);
    end
    if(key(i)=='3')
        fL=LFZ(1);
        fH=HFZ(3);
    end
    if(key(i)=='4')
        fL=LFZ(2);
        fH=HFZ(1);
    end
    if(key(i)=='5')
        fL=LFZ(2);
        fH=HFZ(2);
    end
    if(key(i)=='6')
        fL=LFZ(2);
        fH=HFZ(3);
    end
    if(key(i)=='7')
        fL=LFZ(3);
        fH=HFZ(1);
    end
    if(key(i)=='8')
        fL=LFZ(3);
        fH=HFZ(2);
    end
    if(key(i)=='9')
        fL=LFZ(3);
        fH=HFZ(3);
    end

    %数字振荡器的设计:即得到数字振荡器系统函数Hz的分母和分子多项式系统
    A1 = -2*cos(2*pi*fL/fs);
    B1 = 1;
    C1 = sin(2*pi*fL/fs);
    A2 = -2*cos(2*pi*fH/fs);
    B2 = 1;
    C2 = sin(2*pi*fH/fs);
    AZL = [1,A1,B1]; %低频振荡器Hz的分母多项式系数
    BZL = [0,C1,0]; %低频振荡器Hz的分子多项式系数
    AZH = [1,A2,B2]; %高频振荡器Hz的分母多项式系数
    BZH = [0,C2,0]; %高频振荡器Hz的分子多项式系数

    %DTMF信号y_DTMF的产生：由两个数字振荡器分别产生低频序列yn1和高频序列yn2
    yn1=filter(BZL,AZL,xn); %低频序列
    yn2=filter(BZH,AZH,xn); %高频序列
    yn_DTMF=yn1+yn2; %由高低频率构成的DTMF信号
    xz = [yn_DTMF,zeros(1,N)]; %两个号码之间的静音
    y=[y,xz];
    subplot(2,2,i);
    Fjf = spect_f(t,yn_DTMF,Ts,f);
    plot(f,abs(40*Fjf));
    grid on;
    title([key(i),'的频谱']);
end
sound(y,fs);







