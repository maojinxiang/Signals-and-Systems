function fw = sig_spec_w(t,ft,dt,w)
%t为时间向量
%ft为待计算频谱的时域信号
%dt为时域信号的采样间隔
%w为待观察的以rad/s为单位的频率向量
%fw为相应频率的频谱值

%对每一个频率点计算频谱
fw = zeros(size(w));
for i = 1:length(w)
fw(i)=sum(ft.*exp(-j.*w(i).*t).*dt);
end

end