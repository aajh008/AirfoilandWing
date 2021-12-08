function [Lift,Drag,Liftcoef,Dragcoef] = function_math(Profile_drag_coef,wing_area,aspect_ratio,span_effectivenessfactor,weight,altitude,flightvelocity)
Temp0 = 288.16;  
Temp11 = 216.66;
a = (Temp11-Temp0)/11000;
laps = -6.5e-3;
R = 287.1;
gamma = 1.4;

if altitude < 11000
    Temp0 = 288.16;
    temp = Temp0 + laps * altitude;
    Density0 = 1.2250;
    density = (temp/Temp0)^-(9.81/(laps*287.1)+1)*Density0;
elseif altitude >= 11000 && altitude < 25000
    Temp0 = 216.66;
    temp = Temp0;
    Density0 = 0.3640;
    density = exp(-9.81/(laps*R)+1)*Density0;
else
    Temp0 = 216.66;
    laps = 3e-3;
    temp = Temp0 + laps*(altitude);
    Density0 = 0.11;
    density = (temp/Temp0)^-(9.8/(laps*R)+1)*Density0;
end
q = 0.5*(density)*(flightvelocity)^2;
Lift = weight*9.8;
Liftcoef = Lift/(q*wing_area);
Dragcoef = Profile_drag_coef+Liftcoef^2/(pi*(span_effectivenessfactor)*(aspect_ratio));
Drag = q*wing_area*Dragcoef;
