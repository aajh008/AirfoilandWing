% %----------------------------------------
% % input_NACA.m        
% % Termproject
% % use NACA_4_Digit to make Airfoil
% % student No : 18011295
% % name : 이주헌
% % input data NACAtype
% % output data : xu,yu,yl,yl , plot NACA airfoil
% % Nov.27.2021
% %-----------------------------------------
function [xu,yu,xl,yl] = make_NACA(NACAtype,popTE)
%%%% 나카 익형 종류의 4가지 숫자에서 필요한 값 추출 %%%%
M = str2double(NACAtype(1)); %숫자형으로 변경
P = str2double(NACAtype(2));
XX = str2double(NACAtype(3:4));

% 익형의 grid points 설정 (몇 개의 점으로 그릴지)
gridPts = 500;

% 실제 NACA 익형 식은
% y = a0 * x^(1/2) + a1 * x^1 + a2 * x^2 + a3 *x^3 + a4 * x^4
% 형태를 띈다. 이때 a의 값들
a0 = 0.2969;
a1 = -0.1260;
a2 = -0.3516;
a3 = 0.2843;
if popTE == 1
    a4 = -0.1036; % 닫힌 익형 => 구할려는 것
elseif popTE == 2
    a4 = -0.1015; % 열린 익형
end


% % % % % % % % % 실제 계산 % % % % % % % % % % % %
m = M/100;
p = P/10;
xx = XX/100;

% grid 값
x = linspace(0,1,gridPts);

% Camber 와 Gradient 값 정하기

for i = 1:1:gridPts
    if (x(i) >= 0 && x(i) < p)
        yc(i) = (m/p^2) * ((2*p*x(i))-x(i)^2);
        dyc_dx(i) = ((2*m)/(p^2))*(p-x(i));
    elseif (x(i) >= p && x(i) <= 1)
        yc(i) = (m/(1-p)^2)*(1-(2*p)+(2*p*x(i))-(x(i)^2));
        dyc_dx(i) = ((2*m)/((1-p)^2))*(p-x(i));
    end
    theta(i) = atan(dyc_dx(i));
end

% 두께 구해주기
for i = 1:1:gridPts
    thick0 = a0 * sqrt(x(i));
    thick1 = a1 * x(i);
    thick2 = a2*x(i)^2;
    thick3 = a3*x(i)^3;
    thick4 = a4*x(i)^4;
    
    yt(i) = 5*xx*(thick0 + thick1 + thick2 + thick3 + thick4);
end

% 위쪽 익형 표면
for i = 1:1:gridPts
    xu(i) = x(i) - yt(i)*sin(theta(i));
    yu(i) = yc(i) + yt(i)*cos(theta(i));
end

% 아래쪽 익형 표면
for i = 1:1:gridPts
    xl(i) = x(i) + yt(i)*sin(theta(i));
    yl(i) = yc(i) - yt(i)*cos(theta(i));
end

% Plot the airfoil
% f1 = figure(1);
% hold on; grid on;
% axis equal
% plot(xu,yu,'r-');
% plot(xl,yl,'b-');
