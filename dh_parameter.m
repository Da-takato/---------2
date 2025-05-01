clear; 

theta1 = 0; 
theta2 = 0;  
theta3 = 0;  
theta4 = pi/3;
theta5 = pi/3;
theta6 = pi/3;  
theta7 = 0;  
theta8 = 0;
theta9 = 0;
L1 = 0.16;     
L2 = 0.16;   
L3 = 0.17;   
L4 = 0.05;
L5 = 0.06;  
L6 = 0.07;
DH = [0,  pi/2,  0,     pi/2;
      0,  0,    0,     pi/2;
    -L1,   0,    0,  -theta1;  % Link 1
     0 ,  pi/2,  0,        0;      % Link 1-1
    -L2,   0,    0,  theta2;    % Link 2
    -L3,   0,    0,   -theta3];
DH1 = [DH;
       L4,   pi/2,    0,         pi/2;
       0 ,   pi/2,    0,            0;
       0 ,   pi/2,   0.05,       pi/2;
       0 ,   pi/2,    0,            0;
      -L5,   pi/2,    0, -pi/4+theta4;
       0 ,   pi/2,    0,            0;
      -L6,    0,      0,     -theta7];
DH2 = [DH;
       L4,   pi/2,    0,         pi/2;
       0 ,   pi/2,    0,            0;
       0 ,   pi/2,  -0.05,       pi/2;
       0 ,   pi/2,    0,            0;
      -L5,   pi/2,    0, -pi/4+theta5;
       0 ,   pi/2,    0,            0;
      -L6,    0,      0,     -theta8];
DH3 =[ DH;
      -L4,   pi/2,    0,         pi/2;
       0 ,   pi/2,    0,            0;
       0 ,    0,      0,         pi/2;
      -L5,    0,      0, -pi/4+theta6;
      -L6,    0,      0,      theta9];
% 初期化
T1 = eye(4);
T2 = eye(4);
T3 = eye(4);

positions1 = [0, 0, 0];  % Starting at the origin
positions2 = [0, 0, 0];
positions3 = [0, 0, 0];
% DHパラメータを使用してポジションを計算
positions1 = calculate_positions(DH1, positions1, T1);
positions2 = calculate_positions(DH2, positions2, T2);
positions3 = calculate_positions(DH3, positions3, T3);
% 各ロボットアームの座標を取得
x_coords1 = positions1(:, 1);
y_coords1 = positions1(:, 2);
z_coords1 = positions1(:, 3);
x_coords2 = positions2(:, 1);
y_coords2 = positions2(:, 2);
z_coords2 = positions2(:, 3);
x_coords3 = positions3(:, 1);
y_coords3 = positions3(:, 2);
z_coords3 = positions3(:, 3);
% 3Dでプロット
figure(1);
plot3(x_coords1, y_coords1, z_coords1, '-o', 'LineWidth', 2, 'MarkerSize', 10);
hold on;
plot3(x_coords2, y_coords2, z_coords2, '-o', 'LineWidth', 2, 'MarkerSize', 10);
plot3(x_coords3, y_coords3, z_coords3, '-o', 'LineWidth', 2, 'MarkerSize', 10);
hold on;
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
title('Robot Arm in 3D');
grid on;
axis equal;
% 関数：DH行列を計算
function A = DH_matrix(a, alpha, d, theta)
    A = [cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta);
         sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
         0, sin(alpha), cos(alpha), d;
         0, 0, 0, 1];
end
% 関数：ポジション計算
function positions = calculate_positions(DH, positions, T)
    for i = 1:size(DH, 1)
        a = DH(i, 1);
        alpha = DH(i, 2);
        d = DH(i, 3);
        theta = DH(i, 4);
        
        A_i = DH_matrix(a, alpha, d, theta);
        T = T * A_i;
        
        pos = T(1:3, 4)';
        positions = [positions; pos];
    end
end