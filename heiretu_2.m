%% メインスクリプト: parallel_dynamixel_control.m
clear;
dyn = classPyDynamixel('COM13', 1e6);
DXL_IDs = [7;8;9];
dyn.setRecommendedValue(DXL_IDs);

mpsse = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
% mpsse2 = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
% mpsse3 = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
% mpsse1.showDevices();
% mpsse2.showDevices();
% mpsse1.openChannel(0, 3e5, 1, 0);
% mpsse2.openChannel(0, 3e5, 1, 0);
% ch1 = mpsse1.openChannelFromSerial('AAAA', 5e5, 1, 0);
ch = mpsse.openChannelFromSerial('BBBB', 5e5, 1, 0);
% ch3 = mpsse3.openChannelFromSerial('CCCC', 5e5, 1, 0);
% cs1 = [0;1;2];
cs = [0;1;2];
% cs3 = [0;1;2];

% dpick = py.DynPick.DynPick('COM4'); % ポート番号は適宜変更すること

% dpick.show_firmware_version();
% dpick.show_sensitivity();
% dpick.start_continuous_read();

% testReadWritePosition(dyn1,dyn2, DXL_IDs1,DXL_IDs2);
% testReadWritePosition(mpsse1, mpsse2, ch1, ch2, cs1, cs2, dyn1, dyn2, DXL_IDs1, DXL_IDs2);
testReadWritePosition(mpsse, ch,  cs,  dyn, DXL_IDs);
dyn.delete();
% dyn2.delete();

function testReadWritePosition(mpsse, ch,  cs,  dyn, DXL_IDs)
    len1 = length(DXL_IDs);
    % len2 = length(DXL_IDs2);
    dyn.writeTorqueEnable(DXL_IDs, 0*ones(len1,1));
    dyn.writeOperatingMode(DXL_IDs, 3*ones(len1,1));
    dyn.writeTorqueEnable(DXL_IDs, 1*ones(len1,1));
    % dyn2.writeTorqueEnable(DXL_IDs2, 0*ones(len2,1));
    % dyn2.writeOperatingMode(DXL_IDs2, 3*ones(len2,1));
    % dyn2.writeTorqueEnable(DXL_IDs2, 1*ones(len2,1));
    aeat6012 = classAeat6012(mpsse);
    % aeat60122 = classAeat6012(mpsse2);
    % aeat60123 = classAeat6012(mpsse3);

    dw = 1;
    % deg1 = 40;
    % deg2 = 90;
    deg3 = [-50;90];   %目標位置
    wid = 100;
    % FIN = [];
    ARM = [];
    enc = [];
    % enc_2 = [];
    % enc_3 = [];
    % sen = [];
    tt = [];
    dt=[];
    yyy = [2048;2048;2048];
    

    dyn.writeGoalPosition(DXL_IDs, yyy);
    pause(0.1)
    p0 = aeat6012.readAsDigitAtOnce(ch,cs)';
    % p0_2 = aeat60122.readAsDigitAtOnce(ch2,cs2)';
    % p0_3 = aeat60123.readAsDigitAtOnce(ch3,cs3)';
    % s0 = double(dpick.read_continuous());
    % disp(p0_1*0.088)
    % disp(p0_2*0.088)
    r= rateControl(20);
    
    tic;

% 並列プールの初期化
pool = gcp('nocreate');
if isempty(pool)
    pool = parpool('local', 2); % 2つのワーカーを起動
end

% 1. Dynamixelモーター制御ループを非同期で実行
f1 = parfeval(@motor_control_loop, 0);

% 2. データ取得ループを非同期で実行
f2 = parfeval(@data_acquisition_loop, 0);

disp('両方のループが実行中です。Ctrl+Cで終了します。');

% 必要に応じてメインスレッド側で待機や他の処理
pause(30); % 例: 30秒間実行

% 両方のループを終了させる
cancel(f1);
cancel(f2);

%% モーター制御ループ関数
function motor_control_loop()
    loopRate = 0.05;  % 20Hz
    try
        while true
            tic;
            % ここにモーター制御処理（ダミー）
            disp(['[モーター制御] ', datestr(now, 'HH:MM:SS.FFF')]);
            elapsed = toc;
            if elapsed < loopRate
                pause(loopRate - elapsed);
            end
        end
    catch
        disp('モーター制御ループ終了');
    end
end

%% データ取得ループ関数
function data_acquisition_loop()
    loopRate = 0.1;  % 10Hz
    try
        while true
            tic;
            % ここにデータ取得処理（ダミー）
            disp(['[データ取得] ', datestr(now, 'HH:MM:SS.FFF')]);
            elapsed = toc;
            if elapsed < loopRate
                pause(loopRate - elapsed);
            end
        end
    catch
        disp('データ取得ループ終了');
    end
end


