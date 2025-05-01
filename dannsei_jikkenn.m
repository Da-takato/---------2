clear;

dyn = classPyDynamixel('COM6', 1e6); % (COM port, Baud)
dpick = py.DynPick.DynPick('COM4'); % ポート番号は適宜変更すること
mpsse = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
mpsse.showDevices();
DXL_IDs = 0;
dyn.setRecommendedValue(DXL_IDs);
dpick.show_firmware_version();
dpick.show_sensitivity();
disp(string(dpick.read_temperature())+'(deg C)');

mpsse.openChannel(0, 3e5, 1, 0);
ch = mpsse.openChannelFromSerial('FTHX5SLJ', 1e6, 1, 0);
cs = 0;     %確認

    
dpick.start_continuous_read();

testReadWritePosition(mpsse, ch, cs, dpick, dyn, DXL_IDs);
% testReadWriteVelocity(dyn, DXL_IDs);
% testReadWriteCurrent(dyn, DXL_IDs);
% testReadSettings(dyn, DXL_IDs);
 
dyn.delete();

function testReadWritePosition(mpsse, ch, cs, dpick, dyn, DXL_IDs)
    len = length(DXL_IDs);
    dyn.writeTorqueEnable(DXL_IDs, 0*ones(len,1));
    dyn.writeOperatingMode(DXL_IDs, 3*ones(len,1));
    dyn.writeTorqueEnable(DXL_IDs, 1*ones(len,1));
    aeat6012 = classAeat6012(mpsse);

    p0 = aeat6012.readAsFloat(ch,cs);

    t=8;
    w=1;
    deg=50;
    aaa=[];
    bbb=[];
    ccc=[];
    tt=[];
    tic;
    for v=0:w:deg
        dyn.writeGoalPosition(DXL_IDs, ((v+180)/0.088)*ones(len,1));
        data = dpick.read_continuous();
        aaa = [aaa; dyn.readPresentPosition(DXL_IDs)];
        bbb = [bbb; aeat6012.readAsFloat(ch, cs)-p0];
        ccc = [ccc; double(data)];
        tt = [tt; toc];
        pause(t/(deg/w));
    end
    for v=deg:-w:0
        dyn.writeGoalPosition(DXL_IDs, ((v+180)/0.088)*ones(len,1));
        data = dpick.read_continuous();
        pause(t/(deg/w));
        aaa = [aaa; dyn.readPresentPosition(DXL_IDs)];
        bbb = [bbb; aeat6012.readAsFloat(ch, cs)-p0];
        ccc = [ccc; double(data)];
        tt = [tt; toc];

    end
    for v=-0:-w:-deg
        dyn.writeGoalPosition(DXL_IDs, ((v+180)/0.088)*ones(len,1));
        data = dpick.read_continuous();
        pause(t/(deg/w));
        aaa = [aaa; dyn.readPresentPosition(DXL_IDs)];
        bbb = [bbb; aeat6012.readAsFloat(ch, cs)-p0];
        ccc = [ccc; double(data)];
        tt = [tt; toc];

    end
    for v=-deg:w:0
        dyn.writeGoalPosition(DXL_IDs, ((v+180)/0.088)*ones(len,1));
        data = dpick.read_continuous();
        pause(t/(deg/w));
        aaa = [aaa; dyn.readPresentPosition(DXL_IDs)];
        bbb = [bbb; aeat6012.readAsFloat(ch, cs)-p0];
        ccc = [ccc; double(data)];
        tt = [tt; toc];

    end
   
    www=[tt,aaa,bbb,ccc];
    save("ARM2", "www");
    x=www(:,3);
    y=www(:,9);
    plot(x,y,'-','color',"b","LineWidth",2)
    % P=polyfit(x,y,3)
    % ppp=[]
    % ppp=[ppp,P]
    % hold on
    % x2=(180-www(:,2)*0.088);
    % y2=polyval(P,x2);
    % plot(x2,y2,'-','color',"r","LineWidth",2)
    % hold off
    
    % tic; 
    % fprintf('read: %.3f(ms)\n', toc*1e3);
    % disp(a);
    % tic;
    % dyn.writeGoalPosition(DXL_IDs, 0*ones(len,1));
    % fprintf('write: %.3f(ms)\n', toc*1e3);
    % pause(1.0);
    % tic;
    % a = dyn.readPresentPosition(DXL_IDs);
    % fprintf('read: %.3f(ms)\n', toc*1e3);
    % disp(a);

    dyn.writeTorqueEnable(DXL_IDs, zeros(len,1));
end



function testReadWriteVelocity(dyn, DXL_IDs)
    len = length(DXL_IDs);
    dyn.writeTorqueEnable(DXL_IDs, 0*ones(len,1));
    dyn.writeOperatingMode(DXL_IDs, 1*ones(len,1));
    dyn.writeTorqueEnable(DXL_IDs, 1*ones(len,1));
    
    dyn.writeGoalVelocity(DXL_IDs, 200*ones(len,1));
    pause(1.0);
    tic;
    a = dyn.readPresentVelocity(DXL_IDs);
    fprintf('read: %.3f(ms)\n', toc*1e3);
    disp(a);
    tic;
    dyn.writeGoalVelocity(DXL_IDs, -200*ones(len,1));
    fprintf('write: %.3f(ms)\n', toc*1e3);
    pause(1.0);
    tic;
    a = dyn.readPresentVelocity(DXL_IDs);
    fprintf('read: %.3f(ms)\n', toc*1e3);
    disp(a);
    
    dyn.writeTorqueEnable(DXL_IDs, zeros(len,1));
end

function testReadWriteCurrent(dyn, DXL_IDs)
    len = length(DXL_IDs);
    dyn.writeTorqueEnable(DXL_IDs, 0*ones(len,1));
    dyn.writeOperatingMode(DXL_IDs, 0*ones(len,1));
    dyn.writeTorqueEnable(DXL_IDs, 1*ones(len,1));
    
    dyn.writeGoalCurrent(DXL_IDs, 100*ones(len,1));
    pause(1.0);
    tic;
    a = dyn.readPresentCurrent(DXL_IDs);
    fprintf('read: %.3f(ms)\n', toc*1e3);
    disp(a);
    tic;
    dyn.writeGoalCurrent(DXL_IDs, -100*ones(len,1));
    fprintf('write: %.3f(ms)\n', toc*1e3);
    pause(1.0);
    tic;
    a = dyn.readPresentCurrent(DXL_IDs);
    fprintf('read: %.3f(ms)\n', toc*1e3);
    disp(a);
    
    dyn.writeTorqueEnable(DXL_IDs, zeros(len,1));
end

function testReadSettings(dyn, DXL_IDs)
    disp(dyn.readReturnDelayTime(DXL_IDs)');
    disp(dyn.readDriveMode(DXL_IDs)');
    disp(dyn.readOperatingMode(DXL_IDs)');
    disp(dyn.readTorqueEnable(DXL_IDs)');
    disp(dyn.readLED(DXL_IDs)');
    disp(dyn.readStatusReturnLevel(DXL_IDs)');
end