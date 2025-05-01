
clear;

mpsse = py.MPSSEMultiCh.MPSSEMultiCh('./libMPSSE.dll');
mpsse.showDevices();
mpsse.openChannel(0, 3e5, 1, 0);
ch1 = mpsse.openChannelFromSerial('ZZZZ', 1e6, 1, 0);
ch2 = mpsse.openChannelFromSerial('CCCC', 1e6, 1, 0);
cs = [0;1;2;3;4;5;6;7;8];
aeat6012 = classAeat6012(mpsse);

 p0 = aeat6012.readAsFloat(ch1,cs);
 p1 = aeat6012.readAsFloat(ch2,cs);
 t=5;
 w=1;
 aaa=[];
  for v=1:w:30
      aaa = (aeat6012.readAsFloat(ch1, cs)-p0);
      bbb = (aeat6012.readAsFloat(ch2, cs)-p0);
      pause(t/30);
      disp(aaa);
      disp(bbb)
      % aaa = [aaa; aeat6012.readAsFloat(ch, cs)];
  end
   % save("aaa", "aaa");
% disp(aeat6012.readAsDigit(ch, cs));
% disp(aeat6012.readAsFloat(ch, cs));
% disp(aeat6012.readAsDigitAtOnce(ch, [0;1;2;3;4;5;6;7])');
% disp(aeat6012.readAsFloatAtOnce(ch, [0;1;2;3;4;5;6;7])');

% tic;
% for ii=1:5
%     aeat6012.readAsDigitAtOnce(ch, (0:7)');
% end
% toc
mpsse.closeChannel(ch1);
mpsse.closeChannel(ch2);


