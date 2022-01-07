classdef simParams
    % Parameters passed to a dsim function
    % 'default' values:
    properties
        g_ca_lts = 0.5;     %gca of .75 with leak of .1 is good;
        g_ca_lts_dend = 0.15;
        g_nat = 60.5;
        g_nat_dend = 0;
        g_kd = 90;
        g_nap = 0;
        g_kt = 5;
        g_k2 = .5;
        g_ar = 0.005;
        g_L = 0.1;
        g_L_dend = 0.035;
        C = 1.2;            % membrance capacitance  uF/cm^2
        gMS = 0.4;         % middle dendrite - soma
        gDM = 0.35;        % distal - middle dendrite
        Ti1 = 5;          %Inh rise time constant  %1e-4/5e-4 is good for b-let.
        Ti2 = 35;            %fall time constant  %5e-3 / 20e-3 ?? ~50 ms rise.
        Te1 = 5;          %Exc
        Te2 = 35;

        %DC pulse
        iDC1 = 0;           % uA/cm2;  DC  2.5 is ~TR for burst;
        istart1= 0;
        istop1 = 0;
        iDC2 = 0;
        istart2= 0;
        istop2 = 0;
        iDC3 = 0;
        istart3= 0;
        istop3 = 0;
        iDC4 = 0;
        istart4= 0;
        istop4 = 0;
        iDC5 = 0;
        istart5= 0;
        istop5 = 0;
        iDC6 = 0;
        istart6= 0;
        istop6 = 0;
        
        %Alpha/Beta Synapse
        A1 = 0;           %amplitude of AMPAergic input to cell 1. (0.2)
        tA1= 0;             %arrival time of AMPAergic input to cell 1.
        A2 = 0;
        tA2= 0;
        A3 = 0;
        tA3= 0;
        A4 = 0;
        tA4= 0;
        A5 = 0;
        tA5= 0;
        A6 = 0;
        tA6= 0;
        
        AI1 = 0;           %amplitude of GABAergic input to cell 1.
        tAI1= 0;             %arrival time of GABAergic input to cell 1.
        AI2 = 0;
        tAI2= 0;
        AI3 = 0;
        tAI3= 0;
        AI4 = 0;
        tAI4= 0;
        AI5 = 0;
        tAI5= 0;
        AI6 = 0;
        tAI6= 0;
        
        %Electrical synapse
        gj14=0;   %D-D   .15 is a good median value
        gj15=0;   %D-M
        gj16=0;   %D-S
        gj24=0;   %M-D
        gj25=0;   %M-M
        gj26=0;   %M-S
        gj34=0;   %S-D
        gj35=0;   %S-M
        gj36=0;   %S1-S2
        gj63=0;   %S2-S1 (set gj63=gj36 for symmetric S-S)
    end
end

