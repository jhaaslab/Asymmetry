% Connecting parallel pool 
%c = parcluster; 
%parpool(c, 8); 
   
startTime  = 0;
endTime    = 500;
skipTime   = 1/10;

load s_init.mat         % these were saved after a 5 s. run with 0 input.


%Sim variables
var_iDC3 = [0 0.25 0.5 0.75 1 1.25 1.5];   
var_isi = [3 5 7.5 10];
var_spks = (5:2:13);
var_A1 = unique(0.5:0.25:2);  %amplitude of AMPAergic input to cell 1. (0.2)
   

all_vars    = { var_iDC3,  'iDC_soma';
                var_A1,    'A_dend_D';
                var_isi,   'A_dend_isi';
                var_spks,  'A_dend_spknum'};
            
var_vectors = all_vars(:, 1)';
var_names   = all_vars(:, 2)';
var_combos  = all_combos(var_vectors{:});

mkdir init_data 
mkdir result
save([pwd '/init_data/var_vectors.mat'], 'var_vectors');
save([pwd '/init_data/var_combos.mat'], 'var_combos', 'var_names');

%Simulation/Run variables
namesOfNeurons     = {'TRN_1_D', 'TRN_1_M', 'TRN_1_S'};
nameOfSavedVar     = 'Sim_results'; 

maxNumIter         = 1000; 
[lpp, ~]           = size(var_combos); 
maxNumBlocks       = ceil(lpp/maxNumIter);
TMPBLOCK = 1;
allblocks = vec2mat(1 : lpp, maxNumIter);

finalblock = allblocks(maxNumBlocks, :);
finalblock = finalblock(finalblock ~= 0);

% Start running
while TMPBLOCK <= maxNumBlocks
    
    if TMPBLOCK == maxNumBlocks
        block2run = finalblock;
    else
        block2run = allblocks(TMPBLOCK, :);
    end
    
var_combos_2run = var_combos(block2run, :);    
sim_result = struct('file', [], 'vars', [], 'data', [], 'analysis', []);

tic
parfor i = 1:numel(block2run)
    tmpStruct = struct('file', block2run(i));
    selected = num2cell(var_combos_2run(i,:),1);
    
    % Get out the 'location' of which values to pick from 'selected'
    [iDC3, A1, isi, spks] = selected{:};
    
    % Set sim specific parameters
    sim = simParams;
    sim.iDC3 = iDC3;
    sim.istart1= 20;
    sim.istop1 = 420;
    sim.A1 = A1;
    sim.tA1 = (70:isi:(70+isi*spks-1)); 
    
    varCellTmpStruct = cell(1, 2*length(var_names));
    varCellTmpStruct(1 : 2 : end-1) = var_names;
    varCellTmpStruct(2 : 2 : end)   = num2cell(selected, 1);
    tmpStruct.vars = struct(varCellTmpStruct{:});
    
    % Start stimualtion
    tspan = [startTime endTime];
    tmax = abs(endTime - startTime);
    s0 = s_init;
        options=odeset('InitialStep',10^(-3),'MaxStep',10^(-2));
        [t,s] = ode23(@(t,s) dsimIterative(t,s,sim),tspan,s0,options);
    
    % Saving Vm data (sampled)
    skip_time = skipTime ; % ms
    tot_skip_points = ceil( skip_time * length(t) / tmax );
    kept_idx = 1 : tot_skip_points : length(t);
    
    tmpS_struct = struct('time', t(kept_idx)); 
    idx = 1;
    for ii = 1 : length(namesOfNeurons)
       tmpS_struct.(namesOfNeurons{ii}) = s(kept_idx, idx);
       idx = idx+20;
    end
    tmpStruct.data = tmpS_struct;
    
    % Analysis       
    % General analysis : NumSpk, SpkTime
    tmpAnly_struct = struct('numspk', [], 'spktime', [], 'lat', []);
    tmpNSpk_struct = struct();
    tmpSpkT_struct = struct(); 
    tmpLat_struct  = struct(); 
    for ii = 1 : length(namesOfNeurons)
        [~, loc] = findpeaks(s(:, (ii-1) * 20 + 1), t, 'MinPeakProminence', 50);
        % number of spikes 
        tmpNSpk_struct.(namesOfNeurons{ii}) = length(loc);
        % latency of spikinh, NaN if none 
        latency = NaN; 
        if ~isempty(loc) 
            latency = loc(1);
        end
        tmpLat_struct.(namesOfNeurons{ii}) = latency;
        % spike timings 
        tmpSpkT_struct.(namesOfNeurons{ii}) = loc;        
    end
    tmpAnly_struct.numspk   = tmpNSpk_struct; 
    tmpAnly_struct.lat      = tmpLat_struct; 
    tmpAnly_struct.spktime  = tmpSpkT_struct;
    
    tmpStruct.analysis = tmpAnly_struct;
    
    sim_result(i) = tmpStruct;
    tmpStruct = [];
end
eval([nameOfSavedVar ' = sim_result;']);
toc

save([pwd '/result/' nameOfSavedVar num2str(TMPBLOCK) '.mat'], nameOfSavedVar);

TMPBLOCK = TMPBLOCK+1;
end

%delete(gcp('nocreate')