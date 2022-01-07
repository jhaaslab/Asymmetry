function ds = dsimIterative(t,s,sim)
 

ds = zeros(max(size(s)),1);
v1= s(1);
v2= s(21);
v3= s(41);
v4= s(61);
v5= s(81);
v6= s(101);

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
if any((sim.istart4<t) .* (t<sim.istop4))
    ix4= -sim.iDC4;
else
    ix4= 0;
end
if any((sim.istart5<t) .* (t<sim.istop5))
    ix5= -sim.iDC5;
else
    ix5= 0;
end
if any((sim.istart6<t) .* (t<sim.istop6))
    ix6= -sim.iDC6;
else
    ix6= 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Synaptic Inputs 
% AMPAergic
if any((t>sim.tA1) .* (t<sim.tA1+2))
    vpreA1=0;
else
    vpreA1 = -100;
end
if any((t>sim.tA2) .* (t<sim.tA2+2))
    vpreA2=0;
else
    vpreA2 = -100;
end
if any((t>sim.tA3) .* (t<sim.tA3+3))
    vpreA3=0;
else
    vpreA3 = -100;
end
if any((t>sim.tA4) .* (t<sim.tA4+2))
    vpreA4=0;
else
    vpreA4 = -100;
end
if any((t>sim.tA5) .* (t<sim.tA5+2))
    vpreA5=0;
else
    vpreA5 = -100;
end
if any((t>sim.tA6) .* (t<sim.tA6+2))
    vpreA6=0;
else
    vpreA6 = -100;
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
if any((t>sim.tAI4) .* (t<sim.tAI4+2))
    vpreAI4=0;
else
    vpreAI4 = -100;
end
if any((t>sim.tAI5) .* (t<sim.tAI5+2))
    vpreAI5=0;
else
    vpreAI5 = -100;
end
if any((t>sim.tAI6) .* (t<sim.tAI6+2))
    vpreAI6=0;
else
    vpreAI6 = -100;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Regular sodium
[dm_nat1, dh_nat1] = Na_t(v1, s(2),  s(3));
[dm_nat2, dh_nat2] = Na_t(v2, s(22), s(23));
[dm_nat3, dh_nat3] = Na_t(v3, s(42), s(43));
[dm_nat4, dh_nat4] = Na_t(v4, s(62), s(63));
[dm_nat5, dh_nat5] = Na_t(v5, s(82), s(83));
[dm_nat6, dh_nat6] = Na_t(v6, s(102), s(103));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Persistent sodium
dm_nap1 = Na_p(v1, s(4));
dm_nap2 = Na_p(v2, s(24));
dm_nap3 = Na_p(v3, s(44));
dm_nap4 = Na_p(v4, s(64));
dm_nap5 = Na_p(v5, s(84));
dm_nap6 = Na_p(v6, s(104));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Delayed rectifier
dm_kd1 = K_rect(v1, s(5));
dm_kd2 = K_rect(v2, s(25));
dm_kd3 = K_rect(v3, s(45));
dm_kd4 = K_rect(v4, s(65));
dm_kd5 = K_rect(v5, s(85));
dm_kd6 = K_rect(v6, s(105));

%%%%%%%%%%%%%%%%%%%%%%%%%%% Transient K = A current, McCormick/Huguenard 1992
[dm_kt1 , dh_kt1]=K_A(v1, s(6), s(7));
[dm_kt2 , dh_kt2]=K_A(v2, s(26), s(27));
[dm_kt3 , dh_kt3]=K_A(v3, s(46), s(47));
[dm_kt4 , dh_kt4]=K_A(v4, s(66), s(67));
[dm_kt5 , dh_kt5]=K_A(v5, s(86), s(87));
[dm_kt6 , dh_kt6]=K_A(v6, s(106), s(107));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GK2
[dm_k21, dh_k21]= K2(v1, s(8), s(9));
[dm_k22, dh_k22]= K2(v2, s(28), s(29));
[dm_k23, dh_k23]= K2(v3, s(48), s(49));
[dm_k24, dh_k24]= K2(v4, s(68), s(69));
[dm_k25, dh_k25]= K2(v5, s(88), s(89));
[dm_k26, dh_k26]= K2(v6, s(108), s(109));

%%%%%%%%%%%%%%%%%%%%%%%T current, as implemented by Traub 2005, which cites Destexhe 1996
[dm_ca_lts1, dh_ca_lts1]= Ca_T(v1, s(10), s(11));
[dm_ca_lts2, dh_ca_lts2]= Ca_T(v2, s(30), s(31));
[dm_ca_lts3, dh_ca_lts3]= Ca_T(v3, s(50), s(51));
[dm_ca_lts4, dh_ca_lts4]= Ca_T(v4, s(70), s(71));
[dm_ca_lts5, dh_ca_lts5]= Ca_T(v5, s(90), s(91));
[dm_ca_lts6, dh_ca_lts6]= Ca_T(v6, s(110), s(111));

%%%%%%%%%%%%%%%%%%%%Anonymous rectifier, AR; Traub 2005 calls this 'h'.  ?!
dm_ar1 = AR(v1, s(12));
dm_ar2 = AR(v2, s(32));
dm_ar3 = AR(v3, s(52));
dm_ar4 = AR(v4, s(72));
dm_ar5 = AR(v5, s(92));
dm_ar6 = AR(v6, s(112));


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
ds(13) = sim.Te1*K_syn(vpreA1)*(1-s(13)) - sim.Te2*s(13);    %excitatory input 
Esyn1 = sim.A1 *s(13)*(v1);   
ds(14) = sim.Ti1*K_syn(vpreAI1)*(1-s(14)) - sim.Ti2*s(14);    %inhibitory input 
Isyn1 = sim.AI1 *s(14)*(v1 +100);
Summed_Isyn1 = Esyn1 + Isyn1 + sim.gj14*(v1-v4) + sim.gj15*(v1-v5) + sim.gj16*(v1-v6);

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
ds(33) = sim.Te1*K_syn(vpreA2)*(1-s(33)) - sim.Te2*s(33);   %excitatory input 
Esyn2 = sim.A2 *s(33)*(v2);
ds(34) = sim.Ti1*K_syn(vpreAI2)*(1-s(34)) - sim.Ti2*s(34);    %inhibitory input 
Isyn2 = sim.AI2 *s(34)*(v2 +100); 
Summed_Isyn2 = Esyn2 + Isyn2 + sim.gj24*(v2-v4) + sim.gj25*(v2-v5) + sim.gj26*(v2-v6);

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
ds(53) = sim.Te1*K_syn(vpreA3)*(1-s(53)) - sim.Te2*s(53);   %excitatory input 
Esyn3 = sim.A3*s(53)*(v3);
ds(54) = sim.Ti1*K_syn(vpreAI3)*(1-s(54)) - sim.Ti2*s(54);    %inhibitory input 
Isyn3 = sim.AI3 *s(54)*(v3 +100);
Summed_Isyn3 = Esyn3 + Isyn3 + sim.gj34*(v3-v4) + sim.gj35*(v3-v5) + sim.gj63*(v3-v6);

%%%%%%%%%%%%%%%%%%%%%%%%%%%   cell 4 (TRN_2_dend_D)
ds(62)=dm_nat4;
ds(63)=dh_nat4;
ds(64)=dm_nap4;
ds(65)=dm_kd4;
ds(66)=dm_kt4;
ds(67)=dh_kt4;
ds(68)=dm_k24;
ds(69)=dh_k24;
ds(70)=dm_ca_lts4;
ds(71)=dh_ca_lts4;
ds(72)=dm_ar4;
Ina4 = (sim.g_nat_dend * (s(62)^3)*s(63)  + sim.g_nap*s(64) )*(v4 -50);
Ik4 =  (sim.g_kd * (s(65)^4) + sim.g_kt*(s(66)^4)*s(67) + sim.g_k2*s(68)*s(69)) * (v4 +100);
ICa4 = (sim.g_ca_lts_dend*(s(70)^2)*s(71)) * (v4 -125);
IAR4 = (sim.g_ar*s(72))*(v4 +40);
IL4 =  (sim.g_L_dend)*(v4 +75);
ds(73) = sim.Te1*K_syn(vpreA4)*(1-s(73)) - sim.Te2*s(73);    %excitatory input 
Esyn4 = sim.A4 *s(73)*(v4);
ds(74) = sim.Ti1*K_syn(vpreAI4)*(1-s(74)) - sim.Ti2*s(74);    %inhibitory input 
Isyn4 = sim.AI4 *s(74)*(v4 +100); 
Summed_Isyn4 = Esyn4 + Isyn4 + sim.gj14*(v4-v1) + sim.gj24*(v4-v2) + sim.gj34*(v4-v3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%   cell 5 (TRN_2_dend_M)
ds(82)=dm_nat5;
ds(83)=dh_nat5;
ds(84)=dm_nap5;
ds(85)=dm_kd5;
ds(86)=dm_kt5;
ds(87)=dh_kt5;
ds(88)=dm_k25;
ds(89)=dh_k25;
ds(90)=dm_ca_lts5;
ds(91)=dh_ca_lts5;
ds(92)=dm_ar5;
Ina5 = (sim.g_nat_dend * (s(82)^3)*s(83)  + sim.g_nap*s(84) )*(v5 - 50);
Ik5 =  (sim.g_kd * (s(85)^4) + sim.g_kt*(s(86)^4)*s(87) + sim.g_k2*s(88)*s(89)) * (v5 +100);
ICa5 = (sim.g_ca_lts_dend*(s(90)^2)*s(91)) * (v5 -125);
IAR5 = (sim.g_ar*s(92))*(v5 +40);
IL5 =  (sim.g_L_dend)*(v5 +75);
ds(93) = sim.Te1*K_syn(vpreA5)*(1-s(93)) - sim.Te2*s(93);   %excitatory input
Esyn5 =  sim.A5*s(93)*(v5);
ds(94) = sim.Ti1*K_syn(vpreAI5)*(1-s(94)) - sim.Ti2*s(94);    %inhibitory input 
Isyn5 = sim.AI5 *s(94)*(v5 +100);
Summed_Isyn5 = Esyn5 + Isyn5 + sim.gj15*(v5-v1) + sim.gj25*(v5-v2) + sim.gj35*(v5-v3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%   cell 6 (TRN_2_soma)
ds(102)=dm_nat6;
ds(103)=dh_nat6;
ds(104)=dm_nap6;
ds(105)=dm_kd6;
ds(106)=dm_kt6;
ds(107)=dh_kt6;
ds(108)=dm_k26;
ds(109)=dh_k26;
ds(110)=dm_ca_lts6;
ds(111)=dh_ca_lts6;
ds(112)=dm_ar6;
Ina6 = (sim.g_nat * (s(102)^3)*s(103)  + sim.g_nap*s(104) )*(v6 - 50);
Ik6 =  (sim.g_kd * (s(105)^4) + sim.g_kt*(s(106)^4)*s(107) + sim.g_k2*s(108)*s(109)) * (v6 +100);
ICa6 = (sim.g_ca_lts*(s(110)^2)*s(111)) * (v6 -125);
IAR6 = (sim.g_ar*s(112))*(v6 +40);
IL6 =  (sim.g_L)*(v6 +75);
ds(113) = sim.Te1*K_syn(vpreA6)*(1-s(113)) - sim.Te2*s(113);   %excitatory input
Esyn6 =  sim.A6*s(113)*(v6);
ds(114) = sim.Ti1*K_syn(vpreAI6)*(1-s(114)) - sim.Ti2*s(114);    %inhibitory input 
Isyn6 = sim.AI6 *s(114)*(v6 +100);  
Summed_Isyn6 = Esyn6 + Isyn6 + sim.gj16*(v6-v1) + sim.gj26*(v6-v2) + sim.gj36*(v6-v3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% final equations

ds(1)  = (-1/sim.C)*( Ina1 + Ik1 + ICa1 + IAR1 + IL1 + ix1 + Summed_Isyn1 + sim.gDM*(v1-v2));
ds(21) = (-1/sim.C)*( Ina2 + Ik2 + ICa2 + IAR2 + IL2 + ix2 + Summed_Isyn2 + sim.gDM*(v2-v1) + sim.gMS*(v2-v3));
ds(41) = (-1/sim.C)*( Ina3 + Ik3 + ICa3 + IAR3 + IL3 + ix3 + Summed_Isyn3 + sim.gMS*(v3-v2));
ds(61) = (-1/sim.C)*( Ina4 + Ik4 + ICa4 + IAR4 + IL4 + ix4 + Summed_Isyn4 + sim.gDM*(v4-v5));
ds(81) = (-1/sim.C)*( Ina5 + Ik5 + ICa5 + IAR5 + IL5 + ix5 + Summed_Isyn5 + sim.gDM*(v5-v4) + sim.gMS*(v5-v6));
ds(101)= (-1/sim.C)*( Ina6 + Ik6 + ICa6 + IAR6 + IL6 + ix6 + Summed_Isyn6 + sim.gMS*(v6-v5));


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