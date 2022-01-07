classdef simParams
    % Parameters passed to a dsim function
    % 'default' values:
    properties
        g_ca_lts = 0.75;     %gca of .75 with leak of .1 is good;
        g_nat = 60.5;
        g_kd = 60;
        g_nap = 0;
        g_kt = 5;
        g_k2 = .5;
        g_ar = 0.025;
        g_L = 0.1;
        C = 1;            % membrance capacitance  uF/cm^2

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
        
        %Alpha/Beta Synapse
        A1 = 0;           %amplitude of AMPAergic input to cell 1. (0.2)
        tA1= 0;             %arrival time of AMPAergic input to cell 1.
        A2 = 0;
        tA2= 0;
        
        AI1 = 0;           %amplitude of GABAergic input to cell 1.
        tAI1= 0;             %arrival time of GABAergic input to cell 1.
        AI2 = 0;
        tAI2= 0;
        
        %Electrical Synapse
        gj12 = 0;
        gj21 = 0;
    end
end

