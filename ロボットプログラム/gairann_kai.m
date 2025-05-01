clear;
load('data5_final.mat');
load('kinnji_keisuu_finger.mat');
load('kinnji_keisuu_arm.mat');
load("vars.mat", 'fM',  'fH', 'fP1', 'fP2', 'fP3');
k11 = ARMkeisuu(1,1);
k21 = ARMkeisuu(1,2);
k31 = ARMkeisuu(1,3);
k41 = ARMkeisuu(1,4);
k12 = FINkeisuu(1,1);
k22 = FINkeisuu(1,2);
k32 = FINkeisuu(1,3);
k42 = FINkeisuu(1,4);

    g = 9.8;    % システムパラメータ
    lg1 = 0.08;  lg2 = 0.08;    lg3=0.035;%重心までの距離
    lg4 = 0.025;   lg5=0.025;
    m1 = 0.35;   m2 = 0.35;     m3 = 0.35;%質量
    m4 = 0.13;   m5 = 0.13;     m6 = 0.13;
    m7 = 0.15;   m8 = 0.15;     m9 = 0.15;
    l1 = 0.16;   l2 = 0.16;     l3 = 0.17;%長さ
    l4 = 0.06;     l5 = 0.06;
    Ixx1 = m1*l1^2/12;   Iyy1 = m1*l1^2/12;   Izz1 = m1*l1^2/12;%重心点周りの慣性モーメント
    Ixx2 = m2*l2^2/12;   Iyy2 = m2*l2^2/12;   Izz2 = m2*l1^2/12;
    Ixx3 = m3*l3^2/12;   Iyy3 = m3*l3^2/12;   Izz3 = m3*l3^2/12;
    Ixx4 = m4*l4^2/12;   Iyy4 = m5*l4^2/12;   Izz4 = m6*l4^2/12;
    Ixx5 = m7*l5^2/12;   Iyy5 = m8*l5^2/12;   Izz5 = m9*l5^2/12;
    dx =0.04; dy = 0.05;
data1=[];
for x=2:1:386 %データ読み取り数によって変更
    
    d0hat = [1;1;1;1;1;1;1;1;1];
    TT = 0.3;
    dt = (data(x,1)-data(x-1,1));
    theta1 = data(x,10)*pi/180-data(x,19)*pi/180; 
    theta2 = data(x,9)*pi/180-data(x,18)*pi/180;  
    theta3 = data(x,8)*pi/180-data(x,17)*pi/180;  
    theta4 = data(x,3)*pi/180-data(x,12)*pi/180;
    theta5 = data(x,5)*pi/180+data(x,14)*pi/180;
    theta6 = data(x,7)*pi/180-data(x,16)*pi/180;  
    theta7 = data(x,2)*pi/180-data(x,11)*pi/180;  
    theta8 = data(x,4)*pi/180+data(x,13)*pi/180;
    theta9 = data(x,6)*pi/180-data(x,15)*pi/180;

    % theta = [data(x,19); data(x,18); data(x,17); data(x,12); data(x,14); data(x,16); data(x,11); data(x,13); data(x,15)]*pi/180; %リンクの角度
     % theta = [0; 0; 0; data(x,12); data(x,14); data(x,16); data(x,11); data(x,13); data(x,15)]*pi/180;
    theta = [theta1; theta2; theta3; theta4; theta5; theta6; theta7; theta8; theta9];
     % Theta2 = (fff(x,5)*0.088-96)*pi/180;
    dtheta = (pi*theta)/(dt*180); %リンクの角速度
    % dTheta2 = pi/180*(fff(x,5)-fff(x-1,5))/dt;
    M = fM(theta);
    M = subs(M);
    H= fH(theta,dtheta);
    H= subs(H);
    deg1 = abs(theta1)*180/pi;%リンクの角度変化
    deg2 = abs(theta2)*180/pi;
    deg3 = abs(theta3)*180/pi;
    deg4 = abs(theta4)*180/pi;
    deg5 = abs(theta5)*180/pi;
    deg6 = abs(theta6)*180/pi;
    deg7 = abs(theta7)*180/pi;
    deg8 = abs(theta8)*180/pi;
    deg9 = abs(theta9)*180/pi;
    % deg1 = abs(data(x,19));  %リンクの角度変化
    % deg2 = abs(data(x,18));
    % deg3 = abs(data(x,17));
    % deg4 = abs(data(x,12));
    % deg5 = abs(data(x,14));
    % deg6 = abs(data(x,16));
    % deg7 = abs(data(x,11));
    % deg8 = abs(data(x,13));
    % deg9 = abs(data(x,15));
  

    tau1 = k11*[deg1.^3; deg2.^3; deg3.^3]+k21*[deg1.^2; deg2.^2; deg3.^2]+k31*[deg1; deg2;deg3]+k41;
    tau2 = k12*[deg4.^3; deg5.^3; deg6.^3; deg7.^3; deg8.^3; deg9.^3]+k22*[deg4.^2; deg5.^2; deg6.^2; deg7.^2; deg8.^2; deg9.^2]+k32*[deg4; deg5; deg6; deg7; deg8; deg9]+k42;
    tau = [tau1; tau2];

    PP1 = fP1(theta);
    PP2 = fP2(theta);
    PP3 = fP3(theta);
    PP = [PP1, PP2, PP3];

    PP(:,1:3:7)=[];

    PPP = pinv(PP);

    d0hatdot = (-M\(tau-H)-(dtheta/TT)-d0hat)/TT;
    d0hat = d0hat + d0hatdot*dt;
    dhat = d0hat +dtheta/TT;

    f = PPP*(M*dhat);   f = simplify(f);



    data1 = [data1; data(x,1), data(x,20),f',tau',theta'];
end

kai1=data1(:,3)+data1(:,5);
kai1(193)=(kai1(192)+kai1(194))/2;

kai2=data1(:,7);
kai2(193)=(kai2(192)+kai2(194))/2;

% figure(1);clf;hold('on');
% plot(data1(:,1), data1(:,2),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)

figure(2);clf;hold('on');
plot(data1(:,1), data1(:,2),"LineWidth",2,"Color","r");
plot(data1(:,1), kai1(:,1),"LineWidth",2,"Color","b");
plot(data1(:,1), -kai2(:,1),"LineWidth",2,"Color","g");
fontsize(16,"points")
xlabel('Time[s]','FontSize',16)
ylabel('Force[N]','FontSize',16)
% figure(3);clf;hold('on');
% plot(data1(:,1), data1(:,3)+data1(:,5),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)
% figure(4);clf;hold('on');
% plot(data1(:,1), data1(:,7),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)


% figure(5);clf;hold('on');
% plot(data1(:,1), data1(:,2),"LineWidth",2,"Color","r");
% plot(data1(:,1), data1(:,3)+data1(:,5)+data1(:,7),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)
% figure(5);clf;hold('on');
% plot(data1(:,1), data1(:,9)+data1(:,10)+data1(:,11)+data1(:,14)+data1(:,17),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)
% figure(6);clf;hold('on');
% plot(data1(:,1), data1(:,9)+data1(:,10)+data1(:,11)+data1(:,13)+data1(:,16),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)


% figure(7);clf;hold('on');
% plot(data1(:,1), data1(:,8),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)

% figure(2);clf;hold('on');
% plot(data1(:,1), data1(:,3),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)
% figure(3);clf;hold('on');
% plot(data1(:,1), data1(:,4),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)


% figure(6);clf;hold('on');
% plot(data1(:,1), data1(:,18),"LineWidth",2,"Color","r"); %1
% plot(data1(:,1), data1(:,19),"LineWidth",2,"Color","b"); %2
% plot(data1(:,1), data1(:,20),"LineWidth",2,"Color","g"); %3
% plot(data1(:,1), data1(:,21),"LineWidth",2,"Color","c"); %4
% plot(data1(:,1), data1(:,22),"LineWidth",2,"Color","m"); %5
% plot(data1(:,1), data1(:,23),"LineWidth",2,"Color","y"); %6
% plot(data1(:,1), data1(:,24),"LineWidth",2,"Color","k"); %7
% plot(data1(:,1), data1(:,25),"LineWidth",2,"Linestyle","--"); %8
% plot(data1(:,1), data1(:,26),"LineWidth",2,"Linestyle","-."); %9
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)


% figure(5);clf;hold('on');
% plot(data1(:,1), data1(:,6),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)
% figure(6);clf;hold('on');
% plot(data1(:,1), data1(:,7),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)
% figure(7);clf;hold('on');
% plot(data1(:,1), data1(:,8),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)

% figure(8);clf;hold('on');
% plot(data(:,1), (data(:,3)+data(:,4))/30,"LineWidth",2,"Color","b");
% legend('Measured','Estimated','fontsize',16,'location','southeast')
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)
% fontsize(16,"points")
% hold off
% figure(8);clf;hold('on');
% plot(data1(:,1), 50*data1(:,4)-data1(:,5),"LineWidth",2,"Color","r");
% fontsize(16,"points")
% xlabel('Time[s]','FontSize',16)
% ylabel('Force[N]','FontSize',16)