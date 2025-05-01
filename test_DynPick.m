clear;

dpick = py.DynPick.DynPick('COM6'); % ポート番号は適宜変更すること

dpick.show_firmware_version();
dpick.show_sensitivity();
disp(string(dpick.read_temperature())+'(deg C)');

data = dpick.read_once();
disp(double(data));
disp("[N], [Nm]");

dpick.start_continuous_read();
tic;

t=5;
w=1;
aaa=[];
for v=1:w:30 % ii=1:1000 
    data = dpick.read_continuous();
    pause(t/(30/w));
    aaa = [aaa; double(data)];
end
toc
save("aaa", "aaa");
% disp(double(data));
% disp("[N], [Nm]");
