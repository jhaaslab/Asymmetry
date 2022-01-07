function ds = dsimIterative(t,s,sim)
 

ds = zeros(max(size(s)),1);
v1= s(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Applied Current
if any((sim.istart1<t) .* (t<sim.istop1))
    ix1= -sim.iDC1;
else
    ix1= 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Synaptic Inputs 
% AMPAergic
if any((t>sim.tA1) .* (t<sim.tA1+2))
    vpre1=0;
else
    vpre1 = -100;
end

% GABAergic
if any((t>sim.tAI1) .* (t<sim.tAI1+2))
    vpreAI1=0;
else
    vpreAI1 = -100;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Regular sodium
[dm_nat1, dh_nat1] = Na_t(v1, s(2),  s(3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Persistent sodium
dm_nap1 = Na_p(v1, s(4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Delayed rectifier
dm_kd1 = K_rect(v1, s(5));

%%%%%%%%%%%%%%%%%%%%%%%%% Transient K = A current, McCormick/Huguenard 1992
[dm_kt1, dh_kt1]=K_A(v1, s(6), s(7));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GK2
[dm_k21, dh_k21]= K2(v1, s(8), s(9));

%%%%%%%% T current, as implemented by Traub 2005, which cites Destexhe 1996
[dm_ca_lts1, dh_ca_lts1]= Ca_T(v1, s(10), s(11));

%%%%%%%%%%%%%%%%%%%%Anonymous rectifier, AR; Traub 2005 calls this 'h'.  ?!
dm_ar1 = AR(v1, s(12));


%%%%%%%%%%%%%%%%%%%%%%%%%%%   cell 1 (TRN)
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
Ina1 = (sim.g_nat*(s(2)^3)*s(3) + sim.g_nap*s(4))*(v1 -50);
Ik1 =  (sim.g_kd*(s(5)^4) + sim.g_kt*(s(6)^4)*s(7) + sim.g_k2*s(8)*s(9))*(v1 +100);
ICa1 = (sim.g_ca_lts*(s(10)^2)*s(11))*(v1 -125);
IAR1 = (sim.g_ar*s(12))*(v1 +40);
IL1 =  (sim.g_L)*(v1 +75);
ds(13) = sim.Te1*K_syn(vpre1)*(1-s(13)) - sim.Te2*s(13);    %excitatory input 1
Esyn1 = sim.A1 *s(13)*(v1);
ds(14) = sim.Ti1*K_syn(vpreAI1)*(1-s(14)) - sim.Ti2*s(14);    %inhibitory input 
Isyn1 = sim.AI1 *s(14)*(v1 +100);
Summed_Isyn1 = Esyn1 + Isyn1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% final equations

ds(1) = (-1/sim.C)*(Ina1 + Ik1 + ICa1 + IAR1 + IL1 + ix1 + Summed_Isyn1);


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