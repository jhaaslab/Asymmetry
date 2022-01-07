function ds = dsimIterative(t,s,sim)
 

ds = zeros(max(size(s)),1);
v1= s(1);
v2= s(21);
v3= s(41);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Applied Current
if any((sim.istart1<t) .* (t<sim.istop1))
    ix1= -sim.iDC1;
else
    ix1= 0;
end
if any((sim.istart2<t) .* (t<sim.istop2))
    ix2= -sim.iDC2;
else
    ix2= 0;
end
if any((sim.istart3<t) .* (t<sim.istop3))
    ix3= -sim.iDC3;
else
    ix3= 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Synaptic Inputs 
% AMPAergic
if any((t>sim.tA1) .* (t<sim.tA1+2))
    vpre1=0;
else
    vpre1 = -100;
end
if any((t>sim.tA2) .* (t<sim.tA2+2))
    vpre2=0;
else
    vpre2 = -100;
end
if any((t>sim.tA3) .* (t<sim.tA3+2))
    vpre3=0;
else
    vpre3 = -100;
end

% GABAergic
if any((t>sim.tAI1) .* (t<sim.tAI1+2))
    vpreAI1=0;
else
    vpreAI1 = -100;
end
if any((t>sim.tAI2) .* (t<sim.tAI2+2))
    vpreAI2=0;
else
    vpreAI2 = -100;
end
if any((t>sim.tAI3) .* (t<sim.tAI3+2))
    vpreAI3=0;
else
    vpreAI3 = -100;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Regular sodium
[dm_nat1, dh_nat1] = Na_t(v1, s(2),  s(3));
[dm_nat2, dh_nat2] = Na_t(v2, s(22), s(23));
[dm_nat3, dh_nat3] = Na_t(v3, s(42), s(43));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Persistent sodium
dm_nap1 = Na_p(v1, s(4));
dm_nap2 = Na_p(v2, s(24));
dm_nap3 = Na_p(v3, s(44));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Delayed rectifier
dm_kd1 = K_rect(v1, s(5));
dm_kd2 = K_rect(v2, s(25));
dm_kd3 = K_rect(v3, s(45));

%%%%%%%%%%%%%%%%%%%%%%%%%%% Transient K = A current, McCormick/Huguenard 1992
[dm_kt1, dh_kt1]=K_A(v1, s(6), s(7));
[dm_kt2, dh_kt2]=K_A(v2, s(26), s(27));
[dm_kt3, dh_kt3]=K_A(v3, s(46), s(47));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GK2
[dm_k21, dh_k21]= K2(v1, s(8), s(9));
[dm_k22, dh_k22]= K2(v2, s(28), s(29));
[dm_k23, dh_k23]= K2(v3, s(48), s(49));

%%%%%%%%%%%%%%%%%%%%%%%T current, as implemented by Traub 2005, which cites Destexhe 1996
[dm_ca_lts1, dh_ca_lts1]= Ca_T(v1, s(10), s(11));
[dm_ca_lts2, dh_ca_lts2]= Ca_T(v2, s(30), s(31));
[dm_ca_lts3, dh_ca_lts3]= Ca_T(v3, s(50), s(51));

%%%%%%%%%%%%%%%%%%%%Anonymous rectifier, AR; Traub 2005 calls this 'h'.  ?!
dm_ar1 = AR(v1, s(12));
dm_ar2 = AR(v2, s(32));
dm_ar3 = AR(v3, s(52));


%%%%%%%%%%%%%%%%%%%%%%%%%%%   cell 1 (TRN_1_dend_D)
ds(2)=dm_nat1;
ds(3)=dh_nat1;
ds(4)=dm_nap1;
ds(5)=dm_kd1;
ds(6)=dm_kt1;
ds(7)=dh_kt1;
ds(8)=dm_k21;
ds(9)=dh_k21;
ds(10)=dm_ca_lts1;
ds(11)=dh_ca_lts1;
ds(12)=dm_ar1;
Ina1 = (sim.g_nat_dend * (s(2)^3)*s(3)  + sim.g_nap*s(4) )*(v1 -50);
Ik1 =  (sim.g_kd * (s(5)^4) + sim.g_kt*(s(6)^4)*s(7) + sim.g_k2*s(8)*s(9)) * (v1 +100);
ICa1 = (sim.g_ca_lts_dend*(s(10)^2)*s(11)) * (v1 -125);
IAR1 = (sim.g_ar*s(12))*(v1 +40);
IL1 =  (sim.g_L_dend)*(v1 +75);
ds(13) = sim.Te1*K_syn(vpre1)*(1-s(13)) - sim.Te2*s(13);    %excitatory input 
Esyn1 = sim.A1 *s(13)*(v1);   
ds(14) = sim.Ti1*K_syn(vpreAI1)*(1-s(14)) - sim.Ti2*s(14);    %inhibitory input 
Isyn1 = sim.AI1 *s(14)*(v1 +100);
Summed_Isyn1 = Esyn1 + Isyn1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%   cell 2 (TRN_1_dend_M)
ds(22)=dm_nat2;
ds(23)=dh_nat2;
ds(24)=dm_nap2;
ds(25)=dm_kd2;
ds(26)=dm_kt2;
ds(27)=dh_kt2;
ds(28)=dm_k22;
ds(29)=dh_k22;
ds(30)=dm_ca_lts2;
ds(31)=dh_ca_lts2;
ds(32)=dm_ar2;
Ina2 = (sim.g_nat_dend * (s(22)^3)*s(23)  + sim.g_nap*s(24) )*(v2 -50);
Ik2 =  (sim.g_kd * (s(25)^4) + sim.g_kt*(s(26)^4)*s(27) + sim.g_k2*s(28)*s(29)) * (v2 +100);
ICa2 = (sim.g_ca_lts_dend*(s(30)^2)*s(31)) * (v2 -125);
IAR2 = (sim.g_ar*s(32))*(v2 +40);
IL2 =  (sim.g_L_dend)*(v2 +75);
ds(33) = sim.Te1*K_syn(vpre2)*(1-s(33)) - sim.Te2*s(33);   %excitatory input 
Esyn2 = sim.A2 *s(33)*(v2);
ds(34) = sim.Ti1*K_syn(vpreAI2)*(1-s(34)) - sim.Ti2*s(34);    %inhibitory input 
Isyn2 = sim.AI2 *s(34)*(v2 +100);  
Summed_Isyn2 = Esyn2 + Isyn2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%   cell 3 (TRN_1_soma)
ds(42)=dm_nat3;
ds(43)=dh_nat3;
ds(44)=dm_nap3;
ds(45)=dm_kd3;
ds(46)=dm_kt3;
ds(47)=dh_kt3;
ds(48)=dm_k23;
ds(49)=dh_k23;
ds(50)=dm_ca_lts3;
ds(51)=dh_ca_lts3;
ds(52)=dm_ar3;
Ina3 = (sim.g_nat * (s(42)^3)*s(43)  + sim.g_nap*s(44) )*(v3 -50);
Ik3 =  (sim.g_kd * (s(45)^4) + sim.g_kt*(s(46)^4)*s(47) + sim.g_k2*s(48)*s(49)) * (v3 +100);
ICa3 = (sim.g_ca_lts*(s(50)^2)*s(51)) * (v3 -125);
IAR3 = (sim.g_ar*s(52))*(v3 +40);
IL3 =  (sim.g_L)*(v3 +75);
ds(53) = sim.Te1*K_syn(vpre3)*(1-s(53)) - sim.Te2*s(53);   %excitatory input 
Esyn3 = sim.A3*s(53)*(v3);
ds(54) = sim.Ti1*K_syn(vpreAI3)*(1-s(54)) - sim.Ti2*s(54);    %inhibitory input 
Isyn3 = sim.AI3 *s(54)*(v3 +100);
Summed_Isyn3 = Esyn3 + Isyn3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% final equations

ds(1) = (-1/sim.C)*( Ina1 + Ik1 + ICa1 + IAR1 + IL1 + ix1 + Summed_Isyn1 + sim.gDM*(v1-v2));
ds(21)= (-1/sim.C)*( Ina2 + Ik2 + ICa2 + IAR2 + IL2 + ix2 + Summed_Isyn2 + sim.gDM*(v2-v1) + sim.gMS*(v2-v3));
ds(41)= (-1/sim.C)*( Ina3 + Ik3 + ICa3 + IAR3 + IL3 + ix3 + Summed_Isyn3 + sim.gMS*(v3-v2));


function [dm, dh]= Na_t(v, m, h)
    minf_nat = 1/(1 + exp((-v - 38)/10));
    if v<= -30
        tau_m_nat = 0.0125 + .1525*exp((v+30)/10);
    else
        tau_m_nat = 0.02 + .145*exp((-v-30)/10);
    end
    hinf_nat = 1/(1 + exp((v + 58.3)/6.7));
    tau_h_nat = 0.225 + 1.125/(1+exp((v+37)/15));
    dm = -(1/tau_m_nat) * (m - minf_nat);
    dh= -(1/tau_h_nat) * (h - hinf_nat);
end

function dm=Na_p(v, m)
    minf_nap = 1/(1+exp((-v-48)/10));
    if v<= -40
        tau_m_nap = 0.025 + .14*exp((v+40)/10);
    else
        tau_m_nap = 0.02 + .145*exp((-v-40)/10);
    end
    dm = -(1/tau_m_nap) * (m - minf_nap);
end

function dm = K_rect(v, m)
    minf_kd = 1/(1+exp((-v-27)/11.5));
    if v<= -10
        tau_m_kd = 0.25 + 4.35*exp((v+10)/10);
    else
        tau_m_kd = 0.25 + 4.35*exp((-v-10)/10);
    end
    dm = -(1/tau_m_kd) * (m - minf_kd);
end

function [dm, dh]= K_A(v, m, h)
    minf_kt = 1/(1+exp((-v-60)/8.5));
    tau_m_kt = .185 + .5/(exp((v+35.8)/19.7) + exp((-v-79)/12.7));
    hinf_kt = 1/(1+exp((v+78)/6));
    if v<= -63
        tau_h_kt = .5/(exp((v+46)/5) + exp((-v-238)/37.5));
    else
        tau_h_kt = 9.5;
    end
    dm = -(1/tau_m_kt) * (m - minf_kt);
    dh = -(1/tau_h_kt) * (h - hinf_kt);
end

function [dm, dh] = K2(v, m, h)
    minf_k2 = 1/(1+exp((-v-10)/17));
    tau_m_k2 = 4.95 + .5/(exp((v-81)/25.6) + exp((-v-132)/18));
    hinf_k2 = 1/(1+exp((v+58)/10.6));
    tau_h_k2 = 60 + .5/(exp((v - 1.33)/200) + exp((-v-130)/7.1));
    dm = -(1/tau_m_k2) * (m - minf_k2);
    dh = -(1/tau_h_k2) * (h - hinf_k2);
end

function [dm, dh]= Ca_T(v, m, h)
    minf_ca_lts = 1./(1+exp((-v-52)./7.4));   %traub
    tau_m_ca_lts = 1 + .33./(exp((v+27)/10) + exp((-v-102)./15));
    hinf_ca_lts = 1./(1+exp((v+80)./5));
    tau_h_ca_lts = 28.3 + .33./(exp((v+48)/4) + exp((-v-407)/50));
    dm = -(1/tau_m_ca_lts) * (m - minf_ca_lts);
    dh = -(1/tau_h_ca_lts) * (h - hinf_ca_lts);
end

function dm=AR(v, m)
    minf_ar = 1/(1+exp((v+75)/5.5));
    tau_m_ar = 1/(exp(-14.6  - .086*v) + exp(-1.87 + .07*v));
    dm= -(1/tau_m_ar) * (m - minf_ar);
end

function k = K_syn(v)
    k = 1/(1+exp(-(v+50)/2));
end


end  %main