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
    
    % loop_time = 0.05;
    reset(r);
    for w=0:dw:wid
    % finifh_time = 
        angle = deg3*w/wid;
        dyn.writeGoalPosition([7;8], [2048;2048]+angle/0.088);
        % FIN = [FIN; dyn1.readPresentPosition(DXL_IDs1)'];
        ARM = [ARM; dyn.readPresentPosition(DXL_IDs)'];
        enc = [enc; aeat6012.readAsDigitAtOnce(ch, cs)'-p0];
        % enc_2 = [enc_2; aeat60122.readAsDigitAtOnce(ch2, cs2)'-p0_2];
        % enc_3 = [enc_3; aeat60123.readAsDigitAtOnce(ch3, cs3)'-p0_3];
        % sen = [sen; double(dpick.read_continuous())-s0];
        tt = [tt; toc];
        % pause(0.02)
        waitfor(r); 
    end 

        % disp(tt)
    dyn.writeTorqueEnable(DXL_IDs, zeros(len1,1));
    mpsse.closeChannel(ch);
    rennsyuu=[tt,  -(ARM*0.088-180), enc*0.088];  %[1 , 2-10 , 11-19]
    save("data_rennsyuu", "rennsyuu");


    % length(tt')
    for x = 1:length(tt)-1
        pt = (rennsyuu(x+1,1)-rennsyuu(x,1));
        dt = [dt;pt];
       
    end

 disp(dt)

  figure(1);clf;hold('on');
    plot(tt,rennsyuu(:,2),'-','color',"b","LineWidth",2)
    plot(tt,rennsyuu(:,3),'-','color',"r","LineWidth",2)
    plot(tt,rennsyuu(:,4),'-','color',"g","LineWidth",2)
    title("compare finger","FontSize",20)
    % hold on
    % legend('7','8','9',)
    % hold off
    
    tt(101,:)=[];

   figure(2);clf;hold('on');
    plot(tt,dt,'-','color',"b","LineWidth",2)
    title("compare finger","FontSize",20)
    hold off

end