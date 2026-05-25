function Fjf = spect_f(t,ft,dt,f)
%t为时间向量
%ft为待计算频谱的时域信号
%dt为时域信号的采样间隔
%f为待观察的以HZ为单位的频率向量
%Fjf为相应频率的频谱值

%对每一个频率点计算频谱
Fjf = zeros(size(f));
for i = 1:length(f)
Fjf(i)=sum(ft.*exp(-j*2*pi.*f(i).*t).*dt);
end

end




