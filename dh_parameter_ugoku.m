clear;

load('data5_final.mat'); % データをロード
% 各リンクの長さ
L1 = 16;     
L2 = 16;   
L3 = 17;   
L4 = 5;
L5 = 6;  
L6 = 7;

% アニメーション設定
figure;
% subplot(1, 3, 1); % XY平面
hold on;
xlabel('X-axis');
ylabel('Y-axis');
title('XY Plane');
grid on;
axis equal;
xlim([-30, 30]);
ylim([-30, 30]);
h1_xy = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'DisplayName', 'Arm 1');
h2_xy = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'DisplayName', 'Arm 2');
h3_xy = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'DisplayName', 'Arm 3');
legend;

figure;
% subplot(1, 3, 2); % YZ平面
hold on;
xlabel('Y-axis');
ylabel('Z-axis');
title('YZ Plane');
grid on;
axis equal;
xlim([-30, 30]);
ylim([-75, 0]);
h1_yz = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'DisplayName', 'Arm 1');
h2_yz = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'DisplayName', 'Arm 2');
h3_yz = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'DisplayName', 'Arm 3');
legend;

figure;
% subplot(1, 3, 3); % XZ平面
hold on;
xlabel('X-axis');
ylabel('Z-axis');
title('XZ Plane');
grid on;
axis equal;
xlim([-30, 30]);
ylim([-75, 0]);
% h1_xz = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'DisplayName', 'Arm 1');
% h2_xz = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'DisplayName', 'Arm 2');
% h3_xz = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10, 'DisplayName', 'Arm 3');
h1_xz = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10);
h2_xz = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10);
h3_xz = plot(0, 0, '-o', 'LineWidth', 2, 'MarkerSize', 10);
legend;

% メインループ
for x = 3:2:386
    % 各関節角度をラジアンに変換
    % theta1 = data(x,19)*pi/180; 
    % theta2 = data(x,18)*pi/180;  
    % theta3 = data(x,17)*pi/180;  
    % theta4 = data(x,12)*pi/180;
    % theta5 = -data(x,14)*pi/180;
    % theta6 = data(x,16)*pi/180;  
    % theta7 = data(x,11)*pi/180;  
    % theta8 = -data(x,13)*pi/180;
    % theta9 = data(x,15)*pi/180;
    % theta1 = data(x,10)*pi/180-data(x,19)*pi/180; 
    % theta2 = data(x,9)*pi/180-data(x,18)*pi/180;  
    % theta3 = data(x,8)*pi/180-data(x,17)*pi/180;  
    % theta4 = data(x,5)*pi/180-data(x,12)*pi/180;
    % theta5 = data(x,3)*pi/180+data(x,14)*pi/180;
    % theta6 = data(x,7)*pi/180-data(x,16)*pi/180;  
    % theta7 = data(x,4)*pi/180-data(x,11)*pi/180;  
    % theta8 = data(x,2)*pi/180+data(x,13)*pi/180;
    % theta9 = data(x,6)*pi/180-data(x,15)*pi/180;
    theta1 = data(x,10)*pi/180-data(x,19)*pi/180; 
    theta2 = data(x,9)*pi/180-data(x,18)*pi/180;  
    theta3 = data(x,8)*pi/180-data(x,17)*pi/180;  
    theta4 = data(x,3)*pi/180-data(x,12)*pi/180;
    theta5 = data(x,5)*pi/180+data(x,14)*pi/180;
    theta6 = data(x,7)*pi/180-data(x,16)*pi/180;  
    theta7 = data(x,2)*pi/180-data(x,11)*pi/180;  
    theta8 = data(x,4)*pi/180+data(x,13)*pi/180;
    theta9 = data(x,6)*pi/180-data(x,15)*pi/180;

    % 各ロボットアームのDHパラメータ
      DH1 = [0,  pi/2,  0,     pi/2;
           0,   0,    0,     pi/2;
         -L1,   0,    0,  theta1;
          0 ,  pi/2,  0,        0;
         -L2,   0,    0,   theta2;
         -L3,   0,    0,  theta3;
          L4,   pi/2,    0,         pi/2;
       0 ,   pi/2,    0,            0;
       0 ,   pi/2,   10,       pi/2;
       0 ,   pi/2,    0,            0;
      -L5,   pi/2,    0, -pi/4+theta4;
       0 ,   pi/2,    0,            0;
      -L6,    0,      0,     -theta7];

    DH2 = [0,  pi/2,  0,     pi/2;
           0,   0,    0,     pi/2;
         -L1,   0,    0,  theta1;
          0 ,  pi/2,  0,        0;
         -L2,   0,    0,   theta2;
         -L3,   0,    0,  theta3;
          L4,   pi/2,    0,         pi/2;
       0 ,   pi/2,    0,            0;
       0 ,   pi/2,  -10,       pi/2;
       0 ,   pi/2,    0,            0;
      -L5,   pi/2,    0, -pi/4+theta5;
       0 ,   pi/2,    0,            0;
      -L6,    0,      0,     -theta8];

    DH3 = [0,  pi/2,  0,     pi/2;
           0,   0,    0,     pi/2;
         -L1,   0,    0,  theta1;
          0 ,  pi/2,  0,        0;
         -L2,   0,    0,   theta2;
         -L3,   0,    0,  theta3;
          -L4,   pi/2,    0,         pi/2;
       0 ,   pi/2,    0,            0;
       0 ,    0,      0,         pi/2;
      -L5,    0,      0, -pi/4+theta6;
      -L6,    0,      0,      theta9];

    % ポジションを計算
    positions1 = calculate_positions(DH1);
    positions2 = calculate_positions(DH2);
    positions3 = calculate_positions(DH3);

    % XY平面の更新
    set(h1_xy, 'XData', positions1(:, 1), 'YData', positions1(:, 2));
    set(h2_xy, 'XData', positions2(:, 1), 'YData', positions2(:, 2));
    set(h3_xy, 'XData', positions3(:, 1), 'YData', positions3(:, 2));

    % YZ平面の更新
    set(h1_yz, 'XData', positions1(:, 2), 'YData', positions1(:, 3));
    set(h2_yz, 'XData', positions2(:, 2), 'YData', positions2(:, 3));
    set(h3_yz, 'XData', positions3(:, 2), 'YData', positions3(:, 3));

    % XZ平面の更新
    set(h1_xz, 'XData', positions1(:, 1), 'YData', positions1(:, 3));
    set(h2_xz, 'XData', positions2(:, 1), 'YData', positions2(:, 3));
    set(h3_xz, 'XData', positions3(:, 1), 'YData', positions3(:, 3));

    drawnow; % グラフを更新
    pause(0.1); % アニメーション速度を調整
end

% 関数：ポジション計算
function positions = calculate_positions(DH)
    T = eye(4);
    positions = [0, 0, 0]; % 初期位置
    for i = 1:size(DH, 1)
        a = DH(i, 1);
        alpha = DH(i, 2);
        d = DH(i, 3);
        theta = DH(i, 4);

        A_i = DH_matrix(a, alpha, d, theta);
        T = T * A_i;

        positions = [positions; T(1:3, 4)'];
    end
end

% 関数：DH行列を計算
function A = DH_matrix(a, alpha, d, theta)
    A = [cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta);
         sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
         0, sin(alpha), cos(alpha), d;
         0, 0, 0, 1];
end




