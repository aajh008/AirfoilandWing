% clc
% clear all
% close all
% 
% SWB = input('SweepBackAngle : ');
% RCL = input('RootChordLenght : ');
% TCL = input('TipChordLenght : ');
% SL = input('SpanLenght : ');
function [x_new1,x_new2,x_new3,x_new4,y_new1,y_new2,y_new3,y_new4,area,AR] = wing_new(SWB,RCL,TCL,SL)
LT = SL/(2*tan(pi/2-SWB))+RCL/4-TCL/4;
TT = SL/(2*tan(pi/2-SWB))+RCL/4+3*TCL/4;
LR = 0;
TR = RCL;
if SWB==0 && RCL==TCL
    y_new1 = 0:0.001: SL/2;
    x_new1 = zeros(1,length(y_new1));
    y_new2 = 0:0.001: SL/2;
    x_new2 = RCL*ones(1,length(y_new2));
    y_new4 = 0:0.001: SL/2;
    x_new4 = RCL/4*ones(1,length(y_new1));
    
else

    %%Leading Edge
    xx1 = [0 LT];
    yy1 = [0 SL/2 ];
    if LT > 0
        x_new1 = 0:0.01:LT;
    else
        x_new1 = LT:0.01:0;
    end
    y_new1 = interp1(xx1,yy1,x_new1);

    %%Trailing Edge
    xx2 = [RCL TT];
    yy2 = [0 SL/2 ];
    if RCL < TT
        x_new2 = RCL:0.001:TT;
    else
        x_new2 = TT:0.001:RCL;
    end
    y_new2 = interp1(xx2,yy2,x_new2);

%%c/4
    xx4 = [RCL/4 SL/(2*tan(pi/2-SWB))+RCL/4];
    yy4 = [0 SL/2 ];
    x_new4 = RCL/4:0.001:SL/(2*tan(pi/2-SWB))+RCL/4;
    y_new4 = interp1(xx4,yy4,x_new4);
    
  end  
    %%Tip
    xx3 = [LT TT];
    yy3 = [SL/2 SL/2 ];
    x_new3 = LT:0.001:TT;
    y_new3 = interp1(xx3,yy3,x_new3);

%     
% 
% plot(x_new1,y_new1,'b');           %%위쪽 Leading Edge
% hold on
% plot(x_new1,-y_new1,'b');          %%아래쪽 Leading Edge
% plot(x_new2,y_new2,'b');           %%위쪽 Trailing Edge
% plot(x_new2,-y_new2,'b');          %%아래쪽 Trailing Edge
% plot(x_new3,y_new3,'b');           %%위쪽 Tip
% plot(x_new3,-y_new3,'b');          %%아래쪽 Tip
% plot(x_new4,y_new4,'r');           %%c/4
% plot(x_new4,-y_new4,'r');           %%c/4
% axis equal

area= (RCL+TCL)*SL/2;
AR = SL^2/area;

