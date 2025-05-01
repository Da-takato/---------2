clear;

% --- 初期化 ---
dyn = classPyDynamixel('COM13', 1e6);
DXL_IDs = [7;8;9];
dyn.setRecommendedValue(DXL_IDs);

mpsse = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
ch = mpsse.openChannelFromSerial('BBBB', 5e5, 1, 0);
cs = [0;1;2];

% --- 並列プールのセットアップ ---
pool = gcp('nocreate');
if isempty(pool)
    pool = parpool(2); % 2ワーカー
end

% --- 並列実行 ---
wid = 100;
deg3 = [-50;90];

% ハンド制御周期: 20Hz, データ取得周期: 50Hz 例
handRate = 20;    % Hz
dataRate = 50;    % Hz

fHand = parfeval(pool, @handControlFunc, 1, dyn, DXL_IDs, deg3, wid, handRate);
fData = parfeval(pool, @dataAcqFunc, 1, mpsse, ch, cs, wid, dataRate);

% --- 結果取得 ---
handResult = fetchOutputs(fHand);
dataResult = fetchOutputs(fData);

% --- 終了処理 ---
dyn.delete();
mpsse.closeChannel(ch);

% --- データ保存やプロット ---
% handResult, dataResult を使って処理

% --- 関数定義 ---
function ARM = handControlFunc(dyn, DXL_IDs, deg3, wid, rateHz)
    ARM = [];
    yyy = [2048;2048;2048];
    dyn.writeGoalPosition(DXL_IDs, yyy);
    pause(0.1)
    r = rateControl(rateHz);
    tic;
    reset(r);
    for w = 0:1:wid
        angle = deg3*w/wid;
        dyn.writeGoalPosition([7;8], [2048;2048]+angle/0.088);
        ARM = [ARM; dyn.readPresentPosition(DXL_IDs)'];
        waitfor(r);
    end
end

function enc = dataAcqFunc(mpsse, ch, cs, wid, rateHz)
    enc = [];
    aeat6012 = classAeat6012(mpsse);
    p0 = aeat6012.readAsDigitAtOnce(ch,cs)';
    r = rateControl(rateHz);
    reset(r);
    for w = 0:1:wid
        enc = [enc; aeat6012.readAsDigitAtOnce(ch, cs)'-p0];
        waitfor(r);
    end
end
