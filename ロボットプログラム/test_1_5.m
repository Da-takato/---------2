clear;
dyn = classPyDynamixel('COM3', 1e6); % (COM port, Baud)
% dpick = py.DynPick.DynPick('COM6'); % ポート番号は適宜変更すること
% mpsse = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
% mpsse.showDevices();
DXL_IDs = [1;2;3;4;5;6;7;8;9];
dyn.setRecommendedValue(DXL_IDs);
% dpick.show_firmware_version();
% dpick.show_sensitivity();
% disp(string(dpick.read_temperature())+'(deg C)');
% mpsse.openChannel(0, 3e5, 1, 0);
% ch = mpsse.openChannelFromSerial('FTHX5SLJ', 1e6, 1, 0);
% cs = 0;
    
% dpick.start_continuous_read();
% testReadWriteVelocity(dyn, DXL_IDs);   %速度コマンド用
testReadWritePosition(dyn, DXL_IDs); %力覚推定用
% testReadWritePosition(mpsse, ch, cs, dyn, DXL_IDs);
% testReadWritePosition(mpsse, ch, cs, dpick, dyn, DXL_IDs);
% testReadWriteVelocity(dyn, DXL_IDs);
% testReadWriteCurrent(dyn, DXL_IDs);
% testReadSettings(dyn, DXL_IDs);
 
dyn.delete();
function testReadWritePosition( dyn,DXL_IDs)
    len = length(DXL_IDs);
    dyn.writeTorqueEnable(DXL_IDs, 0*ones(len,1));
    dyn.writeOperatingMode(DXL_IDs, 3*ones(len,1));
    dyn.writeTorqueEnable(DXL_IDs, 1*ones(len,1));
    % aeat6012 = classAeat6012(mpsse);
    t=5;            %最終地点到達までの時間
    % w=1;
    dw1=[0.9,1,0.9,1,0.9,1,0,0,0];           %dw=[max(deg)/deg_i]
    deg1=[45,50,45,50,45,50,0,0,0];         %deg=[1,2,3,4,5,6]
    dw2=[1,-1];
    deg2=[90,-90];
    aaa=[];
    % bbb=[];
    % ccc=[];
    % ddd=[];
    tt=[];
    tic;
   
    yyy=[2048;2048;2048;2048;2048;2048;2048;2048;2048];
    for w=[0,0,0,0,0,0,0,0,0]:dw1:deg1
        dyn.writeGoalPosition([1;2;3;4;5;6], yyy-w/0.088);
        % data = dpick.read_continuous();
        aaa = [aaa; dyn.readPresentPosition(DXL_IDs)'];
        % bbb = [bbb; dyn.readPresentPosition(DXL_IDs)];
        % ccc = [ccc; dyn.readPresentPosition(DXL_IDs)];
        % bbb = [bbb; aeat6012.readAsDigitAtOnce(ch, cs)'];
        % ccc = [ccc; double(data)];
        tt = [tt; toc];
        pause(t/(deg1/dw1));
    end 
    for w=[0,0]:dw2:deg2
        dyn.writeGoalPosition([7;8],yyy-w/0.088);
        aaa = [aaa; dyn.readPresentPosition(DXL_IDs)'];
        tt = [tt; toc];
        pause(0.1);
    end
    for w=deg2:-dw2:[0,0]
        dyn.writeGoalPosition([7;8],yyy-w/0.088);
        aaa = [aaa; dyn.readPresentPosition(DXL_IDs)'];
        tt = [tt; toc];
        pause(0.1);
    end
    for w=deg1:-dw1:[0,0,0,0,0,0,0,0,0]
        dyn.writeGoalPosition([1;2;3;4;5;6], yyy-w/0.088);
        % data = dpick.read_continuous();
        aaa = [aaa; dyn.readPresentPosition(DXL_IDs)'];
        % bbb = [bbb; dyn.readPresentPosition([1])];
        % ddd = [ddd; aeat6012.readAsDigit(ch, cs)];
        % ccc = [ccc; double(data)];
        tt = [tt; toc];
        pause(t/(deg1/dw1));
    end
   
    % for v=-deg:w:0
    %     dyn.writeGoalPosition(DXL_IDs, ((v+180)/0.088)*ones(len,1));
    %     data = dpick.read_continuous();
    %     pause(t/(deg/w));
    %     aaa = [aaa; dyn.readPresentPosition(DXL_IDs)];
    %     bbb = [bbb; aeat6012.readAsDigit(ch, cs)];
    %     ccc = [ccc; double(data)];
    %     tt = [tt; toc];
    % end
    % 
    eee=[tt,aaa];
    % save("eee", "eee");
    dyn.writeTorqueEnable(DXL_IDs, zeros(len,1));
end
 