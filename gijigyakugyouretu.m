% 6×9行列の定義
A = rand(2, 3); % ランダムな6×9行列

% 擬似逆行列の計算
A_pseudo_inverse = pinv(A);


disp(A);
% 結果表示
disp('6×9行列の擬似逆行列:');
disp(A_pseudo_inverse);

% 確認: A * A_pseudo_inverse * A = A が成り立つか確認
disp('確認: A * A_pseudo_inverse * A');
disp(A * A_pseudo_inverse * A);