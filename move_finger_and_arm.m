clear;
dyn1 = classPyDynamixel('COM6', 1e6);
dyn2 = classPyDynamixel('COM7', 1e6); % (COM port, Baud)
DXL_IDs1 = [1;2;3;4;5;6];
DXL_IDs2 = [7;8;9];
dyn1.setRecommendedValue(DXL_IDs1);
dyn2.setRecommendedValue(DXL_IDs2);

mpsse1 = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
mpsse2 = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
mpsse3 = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
% mpsse1.showDevices();
% mpsse2.showDevices();
% mpsse1.openChannel(0, 3e5, 1, 0);
% mpsse2.openChannel(0, 3e5, 1, 0);
ch1 = mpsse1.openChannelFromSerial('AAAA', 5e5, 1, 0);
ch2 = mpsse2.openChannelFromSerial('BBBB', 5e5, 1, 0);
ch3 = mpsse3.openChannelFromSerial('CCCC', 5e5, 1, 0);
cs1 = [0;1;2];
cs2 = [0;1;2];
cs3 = [0;1;2];

dpick = py.DynPick.DynPick('COM4'); % ポート番号は適宜変更すること
% dpick.show_firmware_version();
% dpick.show_sensitivity();
dpick.start_continuous_read();

% testReadWritePosition(dyn1,dyn2, DXL_IDs1,DXL_IDs2);
% testReadWritePosition(mpsse1, mpsse2, ch1, ch2, cs1, cs2, dyn1, dyn2, DXL_IDs1, DXL_IDs2);
testReadWritePosition(mpsse1, mpsse2, mpsse3, ch1, ch2, ch3, cs1, cs2, cs3, dpick, dyn1, dyn2, DXL_IDs1, DXL_IDs2);
dyn1.delete();
dyn2.delete();

function testReadWritePosition(mpsse1, mpsse2, mpsse3, ch1, ch2, ch3, cs1, cs2, cs3, dpick, dyn1, dyn2, DXL_IDs1, DXL_IDs2)
    len1 = length(DXL_IDs1);
    len2 = length(DXL_IDs2);
    dyn1.writeTorqueEnable(DXL_IDs1, 0*ones(len1,1));
    dyn1.writeOperatingMode(DXL_IDs1, 3*ones(len1,1));
    dyn1.writeTorqueEnable(DXL_IDs1, 1*ones(len1,1));
    dyn2.writeTorqueEnable(DXL_IDs2, 0*ones(len2,1));
    dyn2.writeOperatingMode(DXL_IDs2, 3*ones(len2,1));
    dyn2.writeTorqueEnable(DXL_IDs2, 1*ones(len2,1));
    aeat60121 = classAeat6012(mpsse1);
    aeat60122 = classAeat6012(mpsse2);
    aeat60123 = classAeat6012(mpsse3);

    dw = 1;
    deg1 = 40;
    deg2 = 90;
    deg3 = [-50;90];   %目標位置
    FIN = [];
    ARM = [];
    enc_1 = [];
    enc_2 = [];
    enc_3 = [];
    sen = [];
    tt = [];
    yyy = [2048;2048;2048;2048;2048;2048;2048;2048;2048];
    wid = 100;
    

    dyn1.writeGoalPosition(DXL_IDs1, yyy);
    pause(0.1)
    p0_1 = aeat60121.readAsDigitAtOnce(ch1,cs1)';
    p0_2 = aeat60122.readAsDigitAtOnce(ch2,cs2)';
    p0_3 = aeat60123.readAsDigitAtOnce(ch3,cs3)';
    s0 = double(dpick.read_continuous());
    % disp(p0_1*0.088)
    % disp(p0_2*0.088)
    tic;

    for w=0:dw:deg1
        dyn1.writeGoalPosition(DXL_IDs1, yyy-w/0.088);
        FIN = [FIN; dyn1.readPresentPosition(DXL_IDs1)'];
        ARM = [ARM; dyn2.readPresentPosition(DXL_IDs2)'];
        enc_1 = [enc_1; aeat60121.readAsDigitAtOnce(ch1, cs1)'-p0_1];
        enc_2 = [enc_2; aeat60122.readAsDigitAtOnce(ch2, cs2)'-p0_2];
        enc_3 = [enc_3; aeat60123.readAsDigitAtOnce(ch3, cs3)'-p0_3];
        sen = [sen; double(dpick.read_continuous())-s0];
        tt = [tt; toc];
        pause(0.05);
    end 
    for w=deg1:dw:deg2
        dyn1.writeGoalPosition([1;3;5], yyy-w/0.088);
        FIN = [FIN; dyn1.readPresentPosition(DXL_IDs1)'];
        ARM = [ARM; dyn2.readPresentPosition(DXL_IDs2)'];
        enc_1 = [enc_1; aeat60121.readAsDigitAtOnce(ch1, cs1)'-p0_1];
        enc_2 = [enc_2; aeat60122.readAsDigitAtOnce(ch2, cs2)'-p0_2];
        enc_3 = [enc_3; aeat60123.readAsDigitAtOnce(ch3, cs3)'-p0_3];
        sen = [sen; double(dpick.read_continuous())-s0];
        tt = [tt; toc];
        pause(0.05);
    end
    for w=0:dw:wid
        angle = deg3*w/wid;
        dyn2.writeGoalPosition([7;8], [2048;2048]+angle/0.088);
        FIN = [FIN; dyn1.readPresentPosition(DXL_IDs1)'];
        ARM = [ARM; dyn2.readPresentPosition(DXL_IDs2)'];
        enc_1 = [enc_1; aeat60121.readAsDigitAtOnce(ch1, cs1)'-p0_1];
        enc_2 = [enc_2; aeat60122.readAsDigitAtOnce(ch2, cs2)'-p0_2];
        enc_3 = [enc_3; aeat60123.readAsDigitAtOnce(ch3, cs3)'-p0_3];
        sen = [sen; double(dpick.read_continuous())-s0];
        tt = [tt; toc];
        pause(0.02)
    end
    pause(2)
    for w=wid:-dw:0
        angle = deg3*w/wid;
        dyn2.writeGoalPosition([7;8], [2048;2048]+angle/0.088);
        FIN = [FIN; dyn1.readPresentPosition(DXL_IDs1)'];
        ARM = [ARM; dyn2.readPresentPosition(DXL_IDs2)'];
        enc_1 = [enc_1; aeat60121.readAsDigitAtOnce(ch1, cs1)'-p0_1];
        enc_2 = [enc_2; aeat60122.readAsDigitAtOnce(ch2, cs2)'-p0_2];
        enc_3 = [enc_3; aeat60123.readAsDigitAtOnce(ch3, cs3)'-p0_3];
        sen = [sen; double(dpick.read_continuous())-s0];
        tt = [tt; toc];
        pause(0.02)
    end
    for w=deg2:-dw:deg1
        dyn1.writeGoalPosition([1;3;5], yyy-w/0.088);
        FIN = [FIN; dyn1.readPresentPosition(DXL_IDs1)'];
        ARM = [ARM; dyn2.readPresentPosition(DXL_IDs2)'];
        enc_1 = [enc_1; aeat60121.readAsDigitAtOnce(ch1, cs1)'-p0_1];
        enc_2 = [enc_2; aeat60122.readAsDigitAtOnce(ch2, cs2)'-p0_2];
        enc_3 = [enc_3; aeat60123.readAsDigitAtOnce(ch3, cs3)'-p0_3];
        sen = [sen; double(dpick.read_continuous())-s0];
        tt = [tt; toc];
        pause(0.05);
    end
    for w=deg1:-dw:0
        dyn1.writeGoalPosition(DXL_IDs1, yyy-w/0.088);
        FIN = [FIN; dyn1.readPresentPosition(DXL_IDs1)'];
        ARM = [ARM; dyn2.readPresentPosition(DXL_IDs2)'];
        enc_1 = [enc_1; aeat60121.readAsDigitAtOnce(ch1, cs1)'-p0_1];
        enc_2 = [enc_2; aeat60122.readAsDigitAtOnce(ch2, cs2)'-p0_2];
        enc_3 = [enc_3; aeat60123.readAsDigitAtOnce(ch3, cs3)'-p0_3];
        sen = [sen; double(dpick.read_continuous())-s0];
        tt = [tt; toc];
        pause(0.05);
    end
    dyn1.writeTorqueEnable(DXL_IDs1, zeros(len1,1));
    dyn2.writeTorqueEnable(DXL_IDs2, zeros(len2,1));
    mpsse1.closeChannel(ch1);
    mpsse2.closeChannel(ch2);
    mpsse3.closeChannel(ch3);
    data=[tt, -(FIN*0.088-180), -(ARM*0.088-180), enc_2*0.088, enc_1*0.088, enc_3*0.088 -sen(:,3)];  %[1 , 2-10 , 11-19]
    save("data5", "data");
    
    % figure1
    figure(1);clf;hold('on');
    plot(tt,data(:,2),'-','color',"b","LineWidth",2)
    title("motor angle","FontSize",20)
    hold on
    plot(tt,data(:,3),'-','color',"g","LineWidth",2)
    plot(tt,data(:,9),'-','color',"r","LineWidth",2)
    legend('joint1','joint2','arm joint')
    hold off

    % figure2
    figure(2);clf;hold('on');
    plot(tt,data(:,11),'-','color',"b","LineWidth",2)
    title("encoder angle","FontSize",20)
    hold on
    plot(tt,data(:,12),'-','color',"g","LineWidth",2)
    plot(tt,data(:,18),'-','color',"r","LineWidth",2)
    legend('joint1','joint2','arm joint')
    hold off

    % figure3
    figure(3);clf;hold('on');
    plot(tt,data(:,9),'-','color',"b","LineWidth",2)
    title("compare arm","FontSize",20)
    hold on
    plot(tt,data(:,18),'-','color',"r","LineWidth",2)
    legend('motor','encoder')
    hold off

    % figure4
    figure(4);clf;hold('on');
    plot(tt,data(:,2),'-','color',"b","LineWidth",2)
    title("compare finger","FontSize",20)
    hold on
    plot(tt,data(:,3),'-','color',"r","LineWidth",2)
    plot(tt,data(:,11),'-','color',"b","LineWidth",2)
    plot(tt,data(:,12),'-','color',"r","LineWidth",2)
    legend('motor1','motor2','encoder1','encoder2')
    hold off

    % figure5
    figure(5);clf;hold('on');
    plot(tt,data(:,20),'-','color',"r","LineWidth",2)
    title("sensor","FontSize",20)
    hold off
end
 