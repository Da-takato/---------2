clear;
dyn = classPyDynamixel('COM3', 1e6); % (COM port, Baud)
% dpick = py.DynPick.DynPick('COM6'); % ポート番号は適宜変更すること
% mpsse = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
% mpsse.showDevices();
DXL_IDs = [1;2;3;4;5;6;7;8;9];           %確認
dyn.setRecommendedValue(DXL_IDs);
% dpick.show_firmware_version();
% dpick.show_sensitivity();
% disp(string(dpick.read_temperature())+'(deg C)');
% 
% mpsse.openChannel(0, 3e5, 1, 0);
% ch = mpsse.openChannelFromSerial('FTHX5SLJ', 1e6, 1, 0);    %確認
% cs = 0;     %確認
% 
% dpick.start_continuous_read();

% testReadWritePosition(mpsse, ch, cs, dpick, dyn, DXL_IDs);
testReadWritePosition(dyn, DXL_IDs); 
dyn.delete();
% function testReadWritePosition(mpsse, ch, cs, dpick, dyn, DXL_IDs)
function testReadWritePosition( dyn, DXL_IDs)
    len = length(DXL_IDs);
    dyn.writeTorqueEnable(DXL_IDs, 0*ones(len,1));
    dyn.writeOperatingMode(DXL_IDs, 3*ones(len,1));
    dyn.writeTorqueEnable(DXL_IDs, 1*ones(len,1));
    % aeat6012 = classAeat6012(mpsse);

    % p0 = aeat6012.readAsFloat(ch, cs);
    t=5;
    w1=[1,1,1,1,1,1];
    % w2=[0,0,0,0,0,0,1,-1,0];
    deg1=[45,45,45,45,45,45];
    % deg2=[0,0,0,0,0,0,90,-90,0];
    % motor_angle=[];
    % encoder_angle=[];
    % sensor=[];
    tt=[];
    tic;

    yyy=[2048;2048;2048;2048;2048;2048];
    for v=0:w1:deg1
       dyn.writeGoalPosition([1;2;3;4;5;6], yyy-v/0.088);
       % data = dpick.read_continuous();
       % motor_angle = [motor_angle; dyn.readPresentPosition(DXL_IDs)];
       % encoder_angle = [encoder_angle; aeat6012.readAsDigit(ch, cs)];
       % sensor = [sensor; double(data)];
       tt = [tt; toc];
       pause(t/(deg1/dw1));
    end
    % for v=deg1:w2:(deg1+deg2)
    %     dyn.writeGoalPosition(DXL_IDs,2048-v/0.088);
    %     % data = dpick.read_continuous();
    %     motor_angle = [motor_angle; dyn.readPresentPosition(DXL_IDs)];
    %     % encoder_angle = [encoder_angle; aeat6012.readAsDigit(ch, cs)];
    %     % sensor = [sensor; double(data)];
    %     tt = [tt; toc];
    %     pause(t/0.1);
    % end
    % for v=(deg1+deg2):-w2:deg1
    %     dyn.writeGoalPosition(DXL_IDs,2048-v/0.088);
    %     % data = dpick.read_continuous();
    %     motor_angle = [motor_angle; dyn.readPresentPosition(DXL_IDs)];
    %     % encoder_angle = [encoder_angle; aeat6012.readAsDigit(ch, cs)];
    %     % sensor = [sensor; double(data)];
    %     tt = [tt; toc];
    %     pause(t/0.1);
    % end
    % for v=deg1:-w1:0
    %     dyn.writeGoalPosition(DXL_IDs,2048-v/0.088);
    %     % data = dpick.read_continuous();
    %     motor_angle = [motor_angle; dyn.readPresentPosition(DXL_IDs)];
    %     % encoder_angle = [encoder_angle; aeat6012.readAsDigit(ch, cs)];
    %     % sensor = [sensor; double(data)];
    %     tt = [tt; toc];
    %     pause(t/0.1);
    % end
    dyn.writeTorqueEnable(DXL_IDs, zeros(len,1));
end



% function testReadWriteVelocity(dyn, DXL_IDs)
%     len = length(DXL_IDs);
%     dyn.writeTorqueEnable(DXL_IDs, 0*ones(len,1));
%     dyn.writeOperatingMode(DXL_IDs, 1*ones(len,1));
%     dyn.writeTorqueEnable(DXL_IDs, 1*ones(len,1));
% 
%     dyn.writeGoalVelocity(DXL_IDs, 200*ones(len,1));
%     pause(1.0);
%     tic;
%     a = dyn.readPresentVelocity(DXL_IDs);
%     fprintf('read: %.3f(ms)\n', toc*1e3);
%     disp(a);
%     tic;
%     dyn.writeGoalVelocity(DXL_IDs, -200*ones(len,1));
%     fprintf('write: %.3f(ms)\n', toc*1e3);
%     pause(1.0);
%     tic;
%     a = dyn.readPresentVelocity(DXL_IDs);
%     fprintf('read: %.3f(ms)\n', toc*1e3);
%     disp(a);
% 
%     dyn.writeTorqueEnable(DXL_IDs, zeros(len,1));
% end
% 
% function testReadWriteCurrent(dyn, DXL_IDs)
%     len = length(DXL_IDs);
%     dyn.writeTorqueEnable(DXL_IDs, 0*ones(len,1));
%     dyn.writeOperatingMode(DXL_IDs, 0*ones(len,1));
%     dyn.writeTorqueEnable(DXL_IDs, 1*ones(len,1));
% 
%     dyn.writeGoalCurrent(DXL_IDs, 100*ones(len,1));
%     pause(1.0);
%     tic;
%     a = dyn.readPresentCurrent(DXL_IDs);
%     fprintf('read: %.3f(ms)\n', toc*1e3);
%     disp(a);
%     tic;
%     dyn.writeGoalCurrent(DXL_IDs, -100*ones(len,1));
%     fprintf('write: %.3f(ms)\n', toc*1e3);
%     pause(1.0);
%     tic;
%     a = dyn.readPresentCurrent(DXL_IDs);
%     fprintf('read: %.3f(ms)\n', toc*1e3);
%     disp(a);
% 
%     dyn.writeTorqueEnable(DXL_IDs, zeros(len,1));
% end
% 
% function testReadSettings(dyn, DXL_IDs)
%     disp(dyn.readReturnDelayTime(DXL_IDs)');
%     disp(dyn.readDriveMode(DXL_IDs)');
%     disp(dyn.readOperatingMode(DXL_IDs)');
%     disp(dyn.readTorqueEnable(DXL_IDs)');
%     disp(dyn.readLED(DXL_IDs)');
%     disp(dyn.readStatusReturnLevel(DXL_IDs)');
% end
