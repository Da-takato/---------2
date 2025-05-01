clear;

syms g d0;  
m = sym('m%d', [9,1], 'positive');
l = sym('l%d', [6,1], 'positive');
lg = sym('lg%d', [6,1], 'positive');
Ixx = sym('Ixx%d',[1,5],'positive');
Iyy = sym('Iyy%d',[1,5],'positive');
Izz = sym('Izz%d',[1,5],'positive');
theta  = sym('theta%d', [9,1], 'real');
dtheta  = sym('dtheta%d', [9,1], 'real');


I1 = [Ixx(1), 0 ,   0;
        0 , Iyy(1), 0;
        0,    0, Izz(1)];
I2 = [Ixx(2), 0 ,   0;
        0 , Iyy(2), 0;
        0,    0, Izz(2)];
I3 = [Ixx(3), 0 ,   0;
        0 , Iyy(3), 0;
        0,    0, Izz(3)];
I4 = [Ixx(4), 0 ,   0;
        0 , Iyy(4), 0;
        0,    0, Izz(4)];
I5 = [Ixx(5), 0 ,   0;
        0 , Iyy(5), 0;
        0,    0, Izz(5)];


DH0 = [ 0 ,    pi/2,  0,        pi/2;
        0 ,    0,  0,        pi/2;    
        0 ,     0,    0,  -theta(1)];      % Link 1

DH1 = [ 0 ,    pi/2,  0,        pi/2;
        0 ,    0,  0,        pi/2;    
      -l(1),   0,    0,  -theta(1);       % Link 1
        0 ,    pi/2,  0,          0;      
        0 ,     0,    0,  -theta(2)];      % Link 2

DH2 = [ 0 ,    pi/2,  0,        pi/2;
        0 ,    0,  0,        pi/2;   
       -l(1),   0,    0,  -theta(1);       % Link 1
        0 ,    pi/2,  0,          0;         
       -l(2),   0,    0,  -theta(2);       % Link 2
        0 ,     0,    0,  -theta(3)];      % Link 3

DH31 = [0 ,    pi/2,  0,        pi/2;
        0 ,    0,  0,        pi/2;   
       -l(1),   0,    0,  -theta(1);       % Link 1
         0 ,   pi/2,  0,          0;      
       -l(2),   0,    0,  -theta(2);       % Link 2
       -l(3),   0,    0,  -theta(3);       % Link 3
        l(4),  pi/2,  0,       pi/2; 
         0 ,   pi/2,  0,          0;
         0 ,   pi/2,  d0,      pi/2;
         0 ,   pi/2,  0,          0;
         0 ,   pi/2,  0, -pi/4+theta(4)];  % Link 4
DH32 = [ 0 ,    pi/2,  0,        pi/2;
         0 ,    0,  0,        pi/2;   
        -l(1),   0,   0, -theta(1);        % Link 1
         0 ,   pi/2,  0,         0;      
       -l(2),   0,    0, -theta(2);        % Link 2
       -l(3),   0,    0, -theta(3);        % Link 3
        l(4),  pi/2,  0,      pi/2; 
         0 ,   pi/2,  0,         0;
         0 ,   pi/2, -d0,     pi/2;
         0 ,   pi/2,  0,        0;
         0 ,   pi/2,  0, -pi/4+theta(5)]; % Link 4
DH33 = [ 0 ,    pi/2,  0,        pi/2;
         0 ,    0,  0,        pi/2;    
        -l(1),   0,   0,  -theta(1);      % Link 1
         0 ,   pi/2,  0,          0;      
        -l(2),   0,   0,  -theta(2);      % Link 2
        -l(3),   0,   0,  -theta(3);      % Link 3
        -l(4), pi/2,  0,       pi/2;
         0 ,   pi/2,  0,          0;
         0 ,     0,   0,       pi/2;
         0 ,     0,   0, -pi/4+theta(6)]; % Link 4

DH41 = [ 0 ,    pi/2,  0,        pi/2;
         0 ,    0,  0,        pi/2;     
         -l(1),  0,    0,  -theta(1);      % Link 1
         0 ,   pi/2,  0,          0;      
       -l(2),   0,    0,  -theta(2);      % Link 2
       -l(3),   0,    0,  -theta(3);      % Link 3
        l(4),  pi/2,  0,       pi/2; 
         0 ,   pi/2,  0,          0;
         0 ,   pi/2,  d0,      pi/2;
         0 ,   pi/2,  0,          0;
       -l(5),  pi/2,  0, -pi/4+theta(4);  % Link 4
         0 ,   pi/2,  0,          0; 
         0 ,    0,   0,  -theta(7)];      % Link 5
DH42 = [ 0 ,    pi/2,  0,        pi/2;
         0 ,    0,  0,        pi/2;    
        -l(1),   0,    0,  -theta(1);      % Link 1
         0 ,   pi/2,  0,          0;      
       -l(2),   0,    0,  -theta(2);      % Link 2
       -l(3),   0,    0,  -theta(3);      % Link 3
        l(4),  pi/2,  0,       pi/2; 
         0 ,   pi/2,  0,          0;
         0 ,   pi/2, -d0,      pi/2;
         0 ,   pi/2,  0,          0;
       -l(5),  pi/2,  0, -pi/4+theta(5);  % Link 4
         0 ,   pi/2,  0,          0; 
         0 ,     0,   0,  -theta(8)];     % Link 5
DH43 = [ 0 ,    pi/2,  0,        pi/2;
         0 ,    0,  0,        pi/2;     
        -l(1),   0,   0,  -theta(1);      % Link 1
         0 ,   pi/2,  0,          0;      
        -l(2),   0,   0,  -theta(2);      % Link 2
        -l(3),   0,   0,  -theta(3);      % Link 3
        -l(4), pi/2,  0,       pi/2;
         0 ,   pi/2,  0,          0;
         0 ,     0,   0,       pi/2;
        -l(5),   0,   0, -pi/4+theta(6);  % Link 4
         0 ,     0,   0,   theta(9)];     % Link 5

T0 = eye(4);
T1 = eye(4);
T2 = eye(4);
T31 = eye(4);
T32 = eye(4);
T33 = eye(4);
T41 = eye(4);
T42 = eye(4);
T43 = eye(4);

% Initialize position vectors
positions0 = zeros(0, 3);  
positions1 = zeros(0, 3);  
positions2 = zeros(0, 3);
positions31 = zeros(0, 3);
positions32 = zeros(0, 3);
positions33 = zeros(0, 3);
positions41 = zeros(0, 3);
positions42 = zeros(0, 3);
positions43 = zeros(0, 3);

% Calculate positions
A_matrices0 = cell(size(DH0, 1), 1);
A_matrices1 = cell(size(DH1, 1), 1);
A_matrices2 = cell(size(DH2, 1), 1);
A_matrices31 = cell(size(DH31, 1), 1);
A_matrices32 = cell(size(DH32, 1), 1);
A_matrices33 = cell(size(DH33, 1), 1);
A_matrices41 = cell(size(DH41, 1), 1);
A_matrices42 = cell(size(DH42, 1), 1);
A_matrices43 = cell(size(DH43, 1), 1);



for i = 1:size(DH0, 1)
    A_matrices0{i} = DH_matrix(DH0(i, 1), DH0(i, 2), DH0(i, 3), DH0(i, 4));
end
for i = 1:size(DH1, 1)
    A_matrices1{i} = DH_matrix(DH1(i, 1), DH1(i, 2), DH1(i, 3), DH1(i, 4));
end
for i = 1:size(DH2, 1)
    A_matrices2{i} = DH_matrix(DH2(i, 1), DH2(i, 2), DH2(i, 3), DH2(i, 4));
end
for i = 1:size(DH31, 1)
    A_matrices31{i} = DH_matrix(DH31(i, 1), DH31(i, 2), DH31(i, 3), DH31(i, 4));
end
for i = 1:size(DH32, 1)
    A_matrices32{i} = DH_matrix(DH32(i, 1), DH32(i, 2), DH32(i, 3), DH32(i, 4));
end
for i = 1:size(DH33, 1)
    A_matrices33{i} = DH_matrix(DH33(i, 1), DH33(i, 2), DH33(i, 3), DH33(i, 4));
end
for i = 1:size(DH41, 1)
    A_matrices41{i} = DH_matrix(DH41(i, 1), DH41(i, 2), DH41(i, 3), DH41(i, 4));
end
for i = 1:size(DH42, 1)
    A_matrices42{i} = DH_matrix(DH42(i, 1), DH42(i, 2), DH42(i, 3), DH42(i, 4));
end
for i = 1:size(DH43, 1)
    A_matrices43{i} = DH_matrix(DH43(i, 1), DH43(i, 2), DH43(i, 3), DH43(i, 4));
end

% Compute overall transformation matrices
for i = 1:size(A_matrices0, 1)
    T0 = T0 * A_matrices0{i};
    pos0 = T0(1:3, 4)';  
    positions0 = [positions0; pos0];  
end

for i = 1:size(A_matrices1, 1)
    T1 = T1 * A_matrices1{i};
    pos1 = T1(1:3, 4)';  
    positions1 = [positions1; pos1];  
end

for i = 1:size(A_matrices2, 1)
    T2 = T2 * A_matrices2{i};
    pos2 = T2(1:3, 4)'; 
    positions2 = [positions2; pos2]; 
end

for i = 1:size(A_matrices31, 1)
    T31 = T31* A_matrices31{i};
    pos31 = T31(1:3, 4)';  
    positions31 = [positions31; pos31];  
end
for i = 1:size(A_matrices32, 1)
    T32 = T32 * A_matrices32{i};
    pos32 = T32(1:3, 4)';  
    positions32 = [positions32; pos32]; 
end
for i = 1:size(A_matrices33, 1)
    T33 = T33 * A_matrices33{i};
    pos33 = T33(1:3, 4)';  
    positions33 = [positions33; pos33];  
end

for i = 1:size(A_matrices41, 1)
    T41 = T41* A_matrices41{i};
    pos41 = T41(1:3, 4)';  
    positions41 = [positions41; pos41];  
end
for i = 1:size(A_matrices42, 1)
    T42 = T42 * A_matrices42{i};
    pos42 = T42(1:3, 4)';  
    positions42 = [positions42; pos42];  
end
for i = 1:size(A_matrices43, 1)
    T43 = T43 * A_matrices43{i};
    pos43 = T43(1:3, 4)'; 
    positions43 = [positions43; pos43]; 
end

% 回転行列
R0 = T0;
R0(4,:) = [];
R0(:,4) = [];
R1 = T1;
R1(4,:) = [];
R1(:,4) = [];
R2 = T2;
R2(4,:) = [];
R2(:,4) = [];
R31 = T31;
R31(4,:) = [];
R31(:,4) = [];
R32 = T32;
R32(4,:) = [];
R32(:,4) = [];
R33 = T33;
R33(4,:) = [];
R33(:,4) = [];
R41 = T41;
R41(4,:) = [];
R41(:,4) = [];
R42 = T42;
R42(4,:) = [];
R42(:,4) = [];
R43 = T43;
R43(4,:) = [];
R43(:,4) = [];

omega1 =     0    +  R0*[0;0;dtheta(1)];
omega2 =   omega1 +  R1*[0;0;dtheta(2)];
omega3 =   omega2 +  R2*[0;0;dtheta(3)];
omega41 =  omega3 + R31*[0;0;dtheta(4)];
omega42 =  omega3 + R32*[0;0;dtheta(5)];
omega43 =  omega3 + R33*[0;0;dtheta(6)];
omega51 = omega41 + R41*[0;0;dtheta(7)];
omega52 = omega42 + R42*[0;0;dtheta(8)];
omega53 = omega43 + R43*[0;0;dtheta(9)];

% 重心の位置ベクトル
r_H0 = T0 * [lg(1); 0; 0; 1];
r_H0(4,:) = [];
r_H1 = T1 * [lg(2); 0; 0; 1];
r_H1(4,:) = [];  
r_H2 = T2 * [lg(3); 0; 0; 1];
r_H2(4,:) = [];  
r_H31 = T31 * [lg(5); 0; 0; 1];
r_H31(4,:) = [];  
r_H32 = T32 * [lg(5); 0; 0; 1];
r_H32(4,:) = []; 
r_H33 = T33 * [lg(5); 0; 0; 1];
r_H33(4,:) = []; 
r_H41 = T41 * [lg(6); 0; 0; 1];
r_H41(4,:) = [];  
r_H42 = T42 * [lg(6); 0; 0; 1];
r_H42(4,:) = []; 
r_H43 = T43 * [lg(6); 0; 0; 1];
r_H43(4,:) = []; 

P41 = T41 * [l(6); 0; 0; 1];
P41(4,:) = [];  
P42 = T42 * [l(6); 0; 0; 1];
P42(4,:) = []; 
P43 = T43 * [l(6); 0; 0; 1];
P43(4,:) = []; 

% 3.8式のやつ
r1 = T41 * [l(6); 0; 0; 1];
r1(4,:) = []; 
r2 = T42 * [l(6); 0; 0; 1];
r2(4,:) = []; 
r3 = T43 * [l(6); 0; 0; 1];
r3(4,:) = []; 

% 重心の速度ベクトル
v_H0 = diff(r_H0, theta(1)) * dtheta(1);
v_H1 = diff(r_H1, theta(2)) * dtheta(2);
v_H2 = diff(r_H2, theta(3)) * dtheta(3);
v_H31 = diff(r_H31, theta(4)) * dtheta(4);
v_H32 = diff(r_H32, theta(5)) * dtheta(5);
v_H33 = diff(r_H33, theta(6)) * dtheta(6);
v_H41 = diff(r_H41, theta(7)) * dtheta(7);
v_H42 = diff(r_H42, theta(8)) * dtheta(8);
v_H43 = diff(r_H43, theta(9)) * dtheta(9);

% 平進の運動エネルギー
KT1 = 1/2 * m(1) * (v_H0.' * v_H0) + 1/2 * m(2) * (v_H1.' * v_H1) ...
+ 1/2 * m(3) * (v_H2.' * v_H2) + 1/2 * m(4) * (v_H31.' * v_H31)...
+ 1/2 * m(7) * (v_H41.' * v_H41);

KT2 =  1/2 * m(5) * (v_H32.' * v_H32)...
+ 1/2 * m(8) * (v_H42.' * v_H42);

KT3 = 1/2 * m(6) * (v_H33.' * v_H33)...
+ 1/2 * m(9) * (v_H43.' * v_H43);

KT = KT1+KT2+KT3;

 % disp(KT);


newomega1 =  R0.'*omega1;
newomega2 =  R1.'*omega2;
newomega3 =  R2.'*omega3;
newomega41 =  R31.'*omega41;
newomega42 =  R32.'*omega42;
newomega43 =  R33.'*omega43;
newomega51 =  R41.'*omega51;
newomega52 =  R42.'*omega52;
newomega53 =  R43.'*omega53;

% 平進の回転エネルギー
KR1 = 1/2*newomega1.'*I1*newomega1 + 1/2*newomega2.'*I2*newomega2 ...
      + 1/2*newomega3.'*I3*newomega3 + 1/2*newomega41.'*I4*newomega41 ...
      + 1/2*newomega51.'*I5*newomega51;
KR2 =  1/2*newomega42.'*I4*newomega42 ...
      + 1/2*newomega52.'*I5*newomega52;
KR3 =  1/2*newomega43.'*I4*newomega43 ...
      + 1/2*newomega53.'*I5*newomega53;

%KR = [KR1;KR2;KR3];

 % disp(KR);

%K = KT + KR;
K = KT + KR1+ KR2+ KR3;



 % disp(K);

% 重心の位置ベクトルのz成分
Z1 = v_H0(3);
Z2 = v_H1(3);
Z3 = v_H2(3);
Z41 = v_H31(3);
Z42 = v_H32(3);
Z43 = v_H33(3);
Z51 = v_H41(3);
Z52 = v_H42(3);
Z53 = v_H43(3);

% ポテンシャルエネルギー
U1 = m(1)*g*Z1 + m(2)*g*Z2 + m(3)*g*Z3 + m(4)*g*Z41 + m(7)*g*Z51;
U2 =m(5)*g*Z42 + m(8)*g*Z52;
U3 = m(6)*g*Z43 + m(9)*g*Z53;

U = U1+U2+U3;

%   disp(U);

L = K - U;

%    disp(L);

% ラグラジアン
% LL1 = K1 - U1;
% LL2 = K2 - U2;
% LL3 = K3 - U3;


L1 = jacobian(L,dtheta).';         L1 = simplify(L1);
M = jacobian(L1,dtheta);           M = simplify(M);
H = jacobian(L1,theta)*dtheta-jacobian(U,theta).';     H = simplify(H);
% dM1=funcMatDiff(M1, theta, dtheta);
 % disp(LL1);

% L1 = jacobian(K1,dtheta).';         L1 = simplify(L1);
% M1 = jacobian(L1,dtheta);           M1 = simplify(M1);
% H1 = jacobian(L1,theta)*dtheta-jacobian(U1,theta).';     H1 = simplify(H1);
% % dM1=funcMatDiff(M1, theta, dtheta);
P1 = jacobian(P41,theta);     
% % G1 = jacobian(U1,theta).';           G1 = simplify(G1);
% 
% L2 = jacobian(K2,dtheta).';         L2 = simplify(L2);
% M2 = jacobian(L2,dtheta);           M2 = simplify(M2);
% H2 = jacobian(L2,theta)*dtheta-jacobian(U2,theta).';     H2 = simplify(H2);
% % dM2=funcMatDiff(M2, theta, dtheta);
P2 = jacobian(P42,theta);     
% % G2 = jacobian(U2,theta).';           G2 = simplify(G2);
% 
% L3 = jacobian(K3,dtheta).';         L3 = simplify(L3);
% M3 = jacobian(L3,dtheta);           M3 = simplify(M3);
% H3 = jacobian(L3,theta)*dtheta-jacobian(U3,theta).';     H3 = simplify(H3);
% % dM3=funcMatDiff(M3, theta, dtheta);
P3 = jacobian(P43,theta);   
% % G3 = jacobian(U3,theta).';           G3 = simplify(G3);

    g = 9.8;    % システムパラメータ
    lg1 = 0.08;  lg2 = 0.08;    lg3=0.035;%重心までの距離
    lg4 = 0;  lg5 = 0.025;   lg6=0.025;
    m1 = 0.35;   m2 = 0.35;     m3 = 0.35;%質量
    m4 = 0.13;   m5 = 0.13;     m6 = 0.13;
    m7 = 0.15;   m8 = 0.15;     m9 = 0.15;
    l1 = 0.16;   l2 = 0.16;     l3 = 0.17;%長さ
    l4 = 0.05;   l5 = 0.06;     l6 = 0.06;
    Ixx1 = m1*l1^2/12;   Iyy1 = m1*l1^2/12;   Izz1 = m1*l1^2/12;%重心点周りの慣性モーメント
    Ixx2 = m2*l2^2/12;   Iyy2 = m2*l2^2/12;   Izz2 = m2*l1^2/12;
    Ixx3 = m3*l3^2/12;   Iyy3 = m3*l3^2/12;   Izz3 = m3*l3^2/12;
    Ixx4 = m4*l5^2/12;   Iyy4 = m5*l5^2/12;   Izz4 = m6*l5^2/12;
    Ixx5 = m7*l6^2/12;   Iyy5 = m8*l6^2/12;   Izz5 = m9*l6^2/12;
    d0 =0.04;

    K = subs(K);
    U = subs(U);
% 1
M = subs(M);
% fM = matlabFunction(M, 'vars', [Theta(1), Theta(2)]);
fM = matlabFunction(M, 'Vars', {theta});
% dM1 = subs(dM1);
% fdM1 = matlabFunction(dM1, 'Vars', {Theta; dTheta});
H = subs(H);
fH = matlabFunction(H, 'Vars', {theta; dtheta});
P1 = subs(P1);
fP1 = matlabFunction(P1, 'Vars', {theta; dtheta});
P2 = subs(P2);
fP2 = matlabFunction(P2, 'Vars', {theta; dtheta});
P3 = subs(P3);
fP3 = matlabFunction(P3, 'Vars', {theta; dtheta});

% % 2
% M2 = subs(M2);
% % fM = matlabFunction(M, 'vars', [Theta(1), Theta(2)]);
% fM2 = matlabFunction(M2, 'Vars', {theta});
% % dM2 = subs(dM2);
% % fdM2 = matlabFunction(dM2, 'Vars', {Theta; dTheta});
% H2 = subs(H2);
% fH2 = matlabFunction(H2, 'Vars', {theta; dtheta});
% P2 = subs(P2);
% fP2 = matlabFunction(P2, 'Vars', {theta; dtheta});
% 
% % 3
% M3 = subs(M3);
% % fM = matlabFunction(M, 'vars', [Theta(1), Theta(2)]);
% fM3 = matlabFunction(M3, 'Vars', {theta});
% % dM3 = subs(dM3);
% % fdM3 = matlabFunction(dM3, 'Vars', {Theta; dTheta});
% H3 = subs(H3);
% fH3 = matlabFunction(H3, 'Vars', {theta; dtheta});
% P3 = subs(P3);
% fP3 = matlabFunction(P3, 'Vars', {theta; dtheta});

save('vars.mat');

% disp(r_H43);

% Function to compute DH matrix
function A = DH_matrix(a, alpha, d, theta)
    A = [cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta);
         sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
         0, sin(alpha), cos(alpha), d;
         0, 0, 0, 1];
end

% function dfM1 = funcMatDiff( dM1, theta, dtheta )
% %funcMatDiff 行列の微分
% %   B: 微分対象の行列
% %   X: Bの引数
% %   dX: Bの引数の微分
%     n = size(dM1);
%     dfM1 = sym(zeros( n(1), n(2) ));
%     for ii=1:n(2)
%         dfM1(:,ii) = jacobian( dM1(:,ii), theta )*dtheta;
%     end
% end
% function dfM2 = funcMatDiff( dM2, theta, dtheta )
% %funcMatDiff 行列の微分
% %   B: 微分対象の行列
% %   X: Bの引数
% %   dX: Bの引数の微分
%     n = size(dM2);
%     dfM2 = sym(zeros( n(1), n(2) ));
%     for ii=1:n(2)
%         dfM2(:,ii) = jacobian( dM2(:,ii), theta )*dtheta;
%     end
% end
% function dfM3 = funcMatDiff( dM3, theta, dtheta )
% %funcMatDiff 行列の微分
% %   B: 微分対象の行列
% %   X: Bの引数
% %   dX: Bの引数の微分
%     n = size(dM3);
%     dfM3 = sym(zeros( n(1), n(2) ));
%     for ii=1:n(2)
%         dfM3(:,ii) = jacobian( dM3(:,ii), theta )*dtheta;
%     end
% end
