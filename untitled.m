% DTMF信号数字振荡器设计与实现
clc, clear, close all;

% 基础参数设置
fs = 8000;                 % 采样频率(Hz)，符合ITU标准
Ts = 1/fs;                 % 采样间隔(s)
dt = Ts;                   % 频谱计算采样间隔
t = 0:Ts:0.05;             % DTMF信号持续时间50ms
f_range = 500:0.01:2000;   % 频谱分析频率范围(Hz)

% 初始化激励信号（单位脉冲）
xn = zeros(size(t));
xn(1) = 1;                  % 数字振荡器的激励信号δ(k)

% DTMF频率定义（按ITU标准）
LFZ = [697, 770, 852, 941]; % 行低频组(Hz)
HFZ = [1209, 1336, 1477];   % 列高频组(Hz)，注意文档中HFZ第三个值应为1477

% 按键-频率映射表（矩阵形式，对应文档code矩阵）
key_matrix = ['1','2','3','A';
              '4','5','6','B';
              '7','8','9','C';
              '*','0','#','D'];

% 输入4位号码（含有效性验证）
key = input('please input 4-digit key (0~9, *, #): ','s');
while length(key) ~= 4
    key = input('Error: Please input exactly 4 digits: ','s');
end

% 静音间隔点数（150ms静音，符合ITU标准）
N = round(0.15/Ts);
y = [];                      % 存储所有DTMF信号（含静音间隔）
detected_digits = '';        % 存储频谱分析解码的数字

% 生成并分析每位号码的DTMF信号
for i = 1:length(key)
    curr_key = key(i);
    fL = 0; fH = 0;
    
    % 1. 查找当前按键对应的频率（优化映射逻辑）
    [row, col] = find(key_matrix == curr_key);
    if ~isempty(row)
        fL = LFZ(row);
        fH = HFZ(col);
    else
        % 处理非法按键（如输入A-D）
        warning(['Unknown key: ', curr_key, ' - using default frequency']);
        fL = LFZ(1);
        fH = HFZ(1);
    end
    
    % 2. 设计数字振荡器系数
    wL = 2*pi*fL/fs;           % 低频归一化角频率
    wH = 2*pi*fH/fs;           % 高频归一化角频率
    
    % 低频振荡器系数
    A1 = -2*cos(wL);
    B1 = 1;
    C1 = sin(wL);
    
    % 高频振荡器系数
    A2 = -2*cos(wH);
    B2 = 1;
    C2 = sin(wH);
    
    % 系统函数系数
    AZL = [1, A1, B1];        % 低频振荡器分母系数
    BZL = [0, C1, 0];         % 低频振荡器分子系数
    AZH = [1, A2, B2];        % 高频振荡器分母系数
    BZH = [0, C2, 0];         % 高频振荡器分子系数
    
    % 3. 生成DTMF信号
    yn1 = filter(BZL, AZL, xn);  % 低频信号
    yn2 = filter(BZH, AZH, xn);  % 高频信号
    yn_DTMF = yn1 + yn2;         % 双音叠加
    
    % 4. 添加静音间隔
    xz = [yn_DTMF, zeros(1, N)];
    y = [y, xz];
    
    % 5. 频谱分析
    Fjf = spect_f(t, yn_DTMF, dt, f_range);
    
    % 6. 绘制频谱图并标注峰值频率
    subplot(2, 2, i);
    plot(f_range, abs(Fjf));
    grid on;
end