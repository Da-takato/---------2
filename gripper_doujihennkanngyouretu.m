clear;

syms g dx dy ;  
m = sym('m%d', [9,1], 'positive');
l = sym('l%d', [5,1], 'positive');
lg = sym('lg%d', [5,1], 'positive');
Ixx = sym('Ixx%d',[1,5],'positive');
Iyy = sym('Iyy%d',[1,5],'positive');
Izz = sym('Izz%d',[1,5],'positive');
theta  = sym('theta%d', [9,1], 'real');
dtheta  = sym('dtheta%d', [9,1], 'real');

c1 = cos(theta(1));   s1 = sin(theta(1));
c2 = cos(theta(2));   s2 = sin(theta(2));
c3 = cos(theta(3));   s3 = sin(theta(3));
c4 = cos(pi/4+theta(4));   s4 = sin(pi/4+theta(4));
c5 = cos(pi/4+theta(5));   s5 = sin(pi/4+theta(5));
c6 = cos(pi/4+theta(6));   s6 = sin(pi/4+theta(6));
c7 = cos(theta(7));   s7 = sin(theta(7));
c8 = cos(theta(8));   s8 = sin(theta(8));
c9 = cos(theta(9));  s9 = sin(theta(9));

% 横y 縦z 奥行xとする
T1 = [c1, 0, s1;     %1
       0, 1,  0;
     -s1, 0, c1];

T2 = [1,  0,  0;     %2
      0, c2,-s2;
      0, s2, c2];

T3 = [1,  0,  0;     %3
      0, c3,-s3;
      0, s3, c3];

T4 = [1,  0,  0;     %黒
      0, c4,-s4;
      0, s4, c4];

T5 = [1,  0,  0;     %その隣
      0, c5,-s5;
      0, s5, c5];

T6 = [1,  0,  0;     %対角側
      0, c6,-s6;
      0, s6, c6];

T7 = [1,  0,  0;     %T4
      0, c7,-s7;
      0, s7, c7];

T8 = [1,  0,  0;     %T5
      0, c8,-s8;
      0, s8, c8];

T9 = [1,  0,  0;      %T6 
      0, c9,-s9;
      0, s9, c9];

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

R51 = [0;0;-l(5)];   Rg51 = [0;0;-lg(5)];
R52 = [0;0;-l(5)];   Rg52 = [0;0;-lg(5)];
R53 = [0;0;-l(5)];   Rg53 = [0;0;-lg(5)];

R41 = [0;0;-l(4)];   Rg41 = [0;0;-lg(4)];
R42 = [0;0;-l(4)];   Rg42 = [0;0;-lg(4)];
R43 = [0;0;-l(4)];   Rg43 = [0;0;-lg(4)];

R31 = [ dx; dy;-l(3)];   Rg3 = [0; 0;-lg(3)];
R32 = [-dx; dy;-l(3)];  
R33 = [  0;-dy;-l(3)];   


R2 = [0;0;-l(2)];   Rg2 = [0;0;-lg(2)];
R1 = [0;0;-l(1)];   Rg1 = [0;0;-lg(1)];




r1 = T1*Rg1;
r2 = T1*(T2*Rg2  +  R1);
r3 = T1*(T2*(T3*Rg3  +  R2)  +  R1);

r41 = T1*(T2*(T3*(T4*Rg41  + R31)  +  R2)  +  R1);
r51 = T1*(T2*(T3*(T4*(T7*Rg51  + R41)  + R31)  +  R2)  +  R1);
r511 = T1*(T2*(T3*(T4*(T7*R51  + R41)  + R31)  +  R2)  +  R1);

r42 = T1*(T2*(T3*(T5*Rg42  + R32)  +  R2)  +  R1);
r52 = T1*(T2*(T3*(T5*(T8*Rg52  + R42)  + R32)  +  R2)  +  R1);
r521 = T1*(T2*(T3*(T5*(T8*R52  + R42)  + R32)  +  R2)  +  R1);

r43 = T1*(T2*(T3*(T6*Rg43  + R33)  +  R2)  +  R1);
r53 = T1*(T2*(T3*(T6*(T9*Rg53  + R43)  + R33)  +  R2)  +  R1);
r531 = T1*(T2*(T3*(T6*(T9*R53  + R43)  + R33)  +  R2)  +  R1);

v_H0 = jacobian(r1, theta) * dtheta;
v_H1 = jacobian(r2, theta) * dtheta;
v_H2 = jacobian(r3, theta) * dtheta;
v_H31 = jacobian(r41, theta) * dtheta;
v_H32 = jacobian(r42, theta) * dtheta;
v_H33 = jacobian(r43, theta) * dtheta;
v_H41 = jacobian(r51, theta) * dtheta;
v_H42 = jacobian(r52, theta) * dtheta;
v_H43 = jacobian(r53, theta) * dtheta;

R_1 = T1;
R_2 = T1*T2;
R_3 = R_2*T3;
R_4 = R_3*T4;
R_5 = R_3*T5;
R_6 = R_3*T6;
R_7 = R_4*T7;
R_8 = R_5*T8;
R_9 = R_6*T9;

omega1 =     0    + R_1*[0;dtheta(1);0];
omega2 =   omega1 + R_2*[dtheta(2);0;0];
omega3 =   omega2 + R_3*[dtheta(3);0;0];
omega41 =  omega3 + R_4*[dtheta(4);0;0];
omega42 =  omega3 + R_5*[dtheta(5);0;0];
omega43 =  omega3 + R_6*[dtheta(6);0;0];
omega51 = omega41 + R_7*[dtheta(7);0;0];
omega52 = omega42 + R_8*[dtheta(8);0;0];
omega53 = omega43 + R_9*[dtheta(9);0;0];

newomega1 =  R_1'*omega1;
newomega2 =  R_2'*omega2;
newomega3 =  R_3'*omega3;
newomega41 = R_4'*omega41;
newomega42 = R_5'*omega42;
newomega43 = R_6'*omega43;
newomega51 = R_7'*omega51;
newomega52 = R_8'*omega52;
newomega53 = R_9'*omega53;


% 平進の運動エネルギー
KT1 = 1/2 * m(1) * (v_H0' * v_H0) + 1/2 * m(2) * (v_H1' * v_H1) ...
+ 1/2 * m(3) * (v_H2' * v_H2) + 1/2 * m(4) * (v_H31' * v_H31)...
+ 1/2 * m(7) * (v_H41' * v_H41);

KT2 =  1/2 * m(5) * (v_H32' * v_H32)...
+ 1/2 * m(8) * (v_H42' * v_H42);

KT3 = 1/2 * m(6) * (v_H33.' * v_H33)...
+ 1/2 * m(9) * (v_H43.' * v_H43);

KT = KT1+KT2+KT3;

% KT = simplify(KT);

% 平進の回転エネルギー
KR1 = 1/2*newomega1'*I1*newomega1 + 1/2*newomega2'*I2*newomega2 ...
      + 1/2*newomega3'*I3*newomega3 + 1/2*newomega41'*I4*newomega41 ...
      + 1/2*newomega51'*I5*newomega51;
KR2 =  1/2*newomega42'*I4*newomega42 ...
      + 1/2*newomega52'*I5*newomega52;
KR3 =  1/2*newomega43'*I4*newomega43 ...
      + 1/2*newomega53'*I5*newomega53;

K = KT + KR1+ KR2+ KR3;

% K = simplify(K);

Z1 = r1(3);
Z2 = r2(3);
Z3 = r3(3);
Z41 = r41(3);
Z42 = r42(3);
Z43 = r43(3);
Z51 = r51(3);
Z52 = r52(3);
Z53 = r53(3);

U1 = m(1)*g*Z1 + m(2)*g*Z2 + m(3)*g*Z3 + m(4)*g*Z41 + m(7)*g*Z51;
U2 = m(5)*g*Z42 + m(8)*g*Z52;
U3 = m(6)*g*Z43 + m(9)*g*Z53;

U = U1+U2+U3;

L = K - U;

L1 = jacobian(K,dtheta)';         L1 = simplify(L1);
M = jacobian(L1,dtheta);           M = simplify(M);
H = jacobian(L1,theta)*dtheta-jacobian(L,theta)';     H = simplify(H);

P1 = jacobian(r511,theta)';    
P2 = jacobian(r521,theta)';     
P3 = jacobian(r531,theta)';   

    g = 9.8;    % システムパラメータ
    lg1 = 0.08;  lg2 = 0.08;    lg3=0.035;%重心までの距離
    lg4 = 0.025;   lg5=0.025;
    m1 = 0.35;   m2 = 0.35;     m3 = 0.35;%質量
    m4 = 0.13;   m5 = 0.13;     m6 = 0.13;
    m7 = 0.15;   m8 = 0.15;     m9 = 0.15;
    l1 = 0.16;   l2 = 0.16;     l3 = 0.17;%長さ
    l4 = 0.06;     l5 = 0.06;
    Ixx1 = m1*l1^2/12;   Iyy1 = m1*l1^2/12;   Izz1 = m1*l1^2/12;%重心点周りの慣性モーメント
    Ixx2 = m2*l2^2/12;   Iyy2 = m2*l2^2/12;   Izz2 = m2*l2^2/12;
    Ixx3 = m3*l3^2/12;   Iyy3 = m3*l3^2/12;   Izz3 = m3*l3^2/12;
    Ixx4 = m4*l4^2/12;   Iyy4 = m5*l4^2/12;   Izz4 = m6*l4^2/12;
    Ixx5 = m7*l5^2/12;   Iyy5 = m8*l5^2/12;   Izz5 = m9*l5^2/12;
    dx =0.04; dy = 0.05;

    % lg3=0.035;
    K = subs(K);
    U = subs(U);

M = subs(M);
fM = matlabFunction(M, 'Vars', {theta});

H = subs(H);
fH = matlabFunction(H, 'Vars', {theta; dtheta});
P1 = subs(P1);
fP1 = matlabFunction(P1, 'Vars', {theta; dtheta});
P2 = subs(P2);
fP2 = matlabFunction(P2, 'Vars', {theta; dtheta});
P3 = subs(P3);
fP3 = matlabFunction(P3, 'Vars', {theta; dtheta});

save('vars.mat');