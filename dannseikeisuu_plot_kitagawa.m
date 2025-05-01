    % load('ARM.mat');
    load('ARM2.mat');

    x=www(:,3);
    y=www(:,9);
    
    % 図１　磁気エンコーダ＆近似曲線
    figure(1);clf;hold('on');
    plot(x,y,'-','color',"b","LineWidth",2)

    hold on

     P=polyfit(x,y,3)   %x,yの近似曲線を3次でプロット
     % FINkeisuu=[]
     % FINkeisuu=[FINkeisuu,P]
     % save("kinnji_keisuu_finger","FINkeisuu")    %近似曲線の係数
     ARMkeisuu=[]
     ARMkeisuu=[ARMkeisuu,P]
     save("kinnji_keisuu_arm2","ARMkeisuu")

     x2=www(:,3)
     y2=polyval(P,x2);
     fontsize(10,"points")
     plot(x2,y2,'-','color',"r","LineWidth",2)

     xlabel('Encoder angle[deg]','FontSize',14)
     ylabel('Torque[Nm]','FontSize',14)

    hold off

    % 図２　磁気エンコーダ
    figure(2);clf;hold('on');
    plot(x,y,'LineStyle','-','Color',"b","LineWidth",2)

    hold on
    fontsize(10,"points")
    xlabel('Encoder angle[deg]','FontSize',14)
    ylabel('Torque[Nm]','FontSize',14)
    hold off

    % 図３　近似曲線
    figure(3);clf;hold('on');
    plot(x2,y2,'-','color',"r","LineWidth",2)

    hold on
    fontsize(10,"points")
    xlabel('Encoder angle[deg]','FontSize',14)
    ylabel('Torque[Nm]','FontSize',14)
    hold off