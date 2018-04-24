function [xdot] = ode1(t,x,input_data)

%% States
SOC = x(1);
V1  = x(2);
V2 = x(3);
Tc = x(4);
Ts = x(5);
SOH = x(6);
Tm = (Ts + Tc) / 2;

%% Input current and outside temperature
it = input_data(:,1);
iCurrent = input_data(:,2); 
iTf = input_data(:,3);

Current = interp1(it,iCurrent,t);
Tf = interp1(it,iTf,t);

%% Updata R0, R1, R2, C1 and C2  

% data of R0
R0c = [0.0055];
R0d = [0.0048];
TrefR0c = 22.2477;
TrefR0d = 31.0494;
TshiftR0c = -11.5943;
TshiftR0d = -15.3253;


% data of R1
R1c = [0.0016 -0.0032 0.0045];
R1d = [7.1135e-4 -4.3865e-4 2.3788e-4];
TrefR1c = 159.2819;
TrefR1d = 347.4707;
TshiftR1c = -41.4548;
TshiftR1d = -79.5816;

% data of R2
R2c = [0.0113 -0.027 0.0339];
R2d = [0.0288 -0.073 0.0605];
TrefR2c = 16.6712;
TrefR2d = 17.0224;

% data of C1
C1d = [335.4518 3.1712e+3 -1.3214e+3 53.2138 -65.4786 44.3761];
C1c = [523.215 6.4171e+3 -7.5555e+3 50.7107 -131.2298 162.4688];

% data of C2
C2d = [3.1887e+4 -1.1593e+5 1.0493e+5 60.3114 1.0175e+4 -9.5924e+3];
C2c = [6.2449e+4 -1.055e+5 4.4432e+4 198.9753 7.5621e+3 -6.9365e+3];

   
if Current < 0
    R0 = R0c * exp (TrefR0c/(Tm - TshiftR0c));
    R1 = (R1c(1) + R1c(2)*SOC + R1c(3)*SOC^2) * exp(TrefR1c/(Tm - TshiftR1c));
    R2 = (R2c(1) + R2c(2)*SOC + R2c(3)*SOC^2) * exp(TrefR2c/Tm);
    C1 = C1c(1) + C1c(2)*SOC + C1c(3)*SOC^2 + (C1c(4) + C1c(5)*SOC + C1c(6)*SOC^2)*Tm;
    C2 = C2c(1) + C2c(2)*SOC + C2c(3)*SOC^2 + (C2c(4) + C2c(5)*SOC + C2c(6)*SOC^2)*Tm;
    
else
    R0 = R0d * exp (TrefR0d/(Tm - TshiftR0d));
    R1 = (R1d(1) + R1d(2)*SOC + R1d(3)*SOC^2) * exp(TrefR1d/(Tm - TshiftR1d));
    R2 = (R2d(1) + R2d(2)*SOC + R2d(3)*SOC^2) * exp(TrefR2d/Tm);
    C1 = C1d(1) + C1d(2)*SOC + C1d(3)*SOC^2 + (C1d(4) + C1d(5)*SOC + C1d(6)*SOC^2)*Tm;
    C2 = C2d(1) + C2d(2)*SOC + C2d(3)*SOC^2 + (C2d(4) + C2d(5)*SOC + C2d(6)*SOC^2)*Tm;
end 

%% Thermal and aging parameters

Ru = 3.08;
Rc = 1.94;
Cc = 62.7;
Cs = 4.5;
Cbat = 2.3 * 3600;
crate = abs(Current/Cbat);

M = 1687.2*crate.^3 - 9522*crate.^2 + 6806.8*crate + 32658;% per-exponential factor
Ea = 31700 - 370.3 * crate;                              % activation energy 
z = 0.55;                                                % power-law factor
R = 8.3144598;                                           % ideal gas constant
Atol = (20 /(M * exp(-Ea /(R*(Tc+273.15)))))^(1/z);      % corresponding total discharged Ah throughput
N =  3600 * Atol / Cbat;


%% electro-thermal-aging model updata



A = [0 0 0; 0 -1/(R1*C1) 0; 0 0 -1/(R2*C2)];
B = [-1/Cbat; 1/C1; 1/C2];


% [SOC_dot; V1_dot; V2_dot] = A * [SOC; V1; V2] + B * Current;

S = A * [SOC; V1; V2] + B * Current;

Tc_dot = (Ts - Tc)/(Rc*Cc) + Current*(V1 + V2 + R0*Current)/Cc;

Ts_dot = (Tf - Ts)/(Ru*Cs) - (Ts - Tc)/(Rc*Cc);

SOH_dot = - abs(Current) / (2 * N * Cbat);


%% return values 

xdot = [S; Tc_dot; Ts_dot; SOH_dot];


