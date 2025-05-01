

clear;
syms g;     % 文字の定義
l = sym('l%d',     [2,1], 'positive');
m = sym('m%d',     [2,1], 'positive');
N = sym('N%d',     [2,1], 'positive');
J = sym('J%d',     [2,1], 'positive');
Theta  = sym( 'Theta%d', [2,1], 'real');
dTheta = sym('dTheta%d', [2,1], 'real');
Tau    = sym(   'Tau%d', [2,1], 'real');

P = cell(2,1);  % 重心位置
P{1} = l(1)*[ cos(Theta(1)); sin(Theta(1)) ];
P{2} = N(1)*[ cos(Theta(1)); sin(Theta(1)) ] + l(2)*[ cos(Theta(1)+Theta(2)); sin(Theta(1)+Theta(2)) ];
P{2} = simplify(P{2});
V = cell(2,1);  % 重心速度
V{1} = jacobian(P{1},Theta)*dTheta;
V{2} = jacobian(P{2},Theta)*dTheta;

%   d/dt(∂L/∂x') - ∂L/∂x + ∂Q/∂x' = Del W/Del q
%   ∂2L/∂2x'*d2x + ∂(∂L/∂x')/∂x - ∂L/∂x + ∂Q/∂x' = Del W/Del q
%   M d2q + H + G + ... = Tau
%   d/dt (Del L/Del dq) - Del L/Del q +  + Del Q/ Del dq = Del W/Del q
%   q: 一般化座標, 	L = T - U
%   T: 運動EN,      U: 位置EN
%   Del W/Del q: 一般化力,  W: 外部からの仕事
T = m(1)*V{1}.'*V{1}/2 + m(2)*V{2}.'*V{2}/2 ...
    + J(1)*dTheta(1)^2/2 + J(2)*dTheta(2)^2/2;      % 運動EN
T = simplify(T);
U = m(1)*g*P{1}(2) + m(2)*g*P{2}(2);    % 位置EN
L = T - U;

L1 = jacobian(T,dTheta).';         L1 = simplify(L1);
M = jacobian(L1,dTheta);           M = simplify(M);
H = jacobian(L1,Theta)*dTheta-jacobian(L,Theta).';     H = simplify(H);
% H = jacobian(L1,Theta)*dTheta;     H = simplify(H);
% G = jacobian(U,Theta).';           G = simplify(G);
dM=funcMatDiff(M, Theta, dTheta);

% d2q = M\(Tau-H)+d;    %*******************

    g = 9.8;    % システムパラメータ
    l1 = 0.08;   l2 = 0.10; %重心までの距離
    m1 = 0.32;   m2 = 0.28; %質量
    N1 = 0.20;   N2 = 0.20; %長さ
    J1 = m1*N1^2/12;   J2 = m2*N2^2/12; %重心点周りの慣性モーメント


M = subs(M);
% fM = matlabFunction(M, 'vars', [Theta(1), Theta(2)]);
fM = matlabFunction(M, 'Vars', {Theta});
dM = subs(dM);
fdM = matlabFunction(dM, 'Vars', {Theta; dTheta});
H = subs(H);
fH = matlabFunction(H, 'Vars', {Theta; dTheta});
G = subs(G);
fG = matlabFunction(G, 'Vars', {Theta});


syms w
f=4.748*w*abs(w);
fTau = matlabFunction(f, 'Vars', w);
Pdes=4.748^(-0.5)*abs(w)^(0.5)*sign(w);
% fPdes = matlabFunction(Pdes, 'Vars', w);
fPdes = @(w) 4.748^(-0.5)*abs(w)^(0.5)*sign(w);
dPdes=diff(Pdes, w);
fdPdes = matlabFunction(dPdes, 'Vars', w);

save('vars.mat');

function dfM = funcMatDiff( dM, theta, dtheta )
%funcMatDiff 行列の微分
%   B: 微分対象の行列
%   X: Bの引数
%   dX: Bの引数の微分
    n = size(dM);
    dfM = sym(zeros( n(1), n(2) ));
    for ii=1:n(2)
        dfM(:,ii) = jacobian( dM(:,ii), theta )*dtheta;
    end
 end



