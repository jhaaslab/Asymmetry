% Connecting parallel pool 
%c = parcluster; 
%parpool(c, 8); 
   
startTime  = 0;
endTime    = 1200;
skipTime   = 1/10;

load s_init.mat         % these were saved after a 5 s. run with 0 input.


%Sim variables
var_iDC     = -1:0.025:1;


all_vars    = { var_iDC, 'Iapplied'};
            
var_vectors = all_vars(:, 1)';
var_names   = all_vars(:, 2)';
var_combos  = all_combos(var_vectors{:});

mkdir init_data 
mkdir result
save([pwd '/init_data/var_vectors.mat'], 'var_vectors');
save([pwd '/init_data/var_combos.mat'], 'var_combos', 'var_names');

%Simulation/Run variables
namesOfNeurons     = {'TRN'};
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
    [iDC] = selected{:};
    
    sim = simParams; % initialize simParams object
    % change simParams vars to selected vars
    sim.iDC1 = iDC;
    sim.istart1= 100;
    sim.istop1 = 1000;
    
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
       tmpS_struct.(strcat(namesOfNeurons{ii},'_Ca')) = s(kept_idx, idx+1);
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

%delete(gcp('nocreate')) %shutdown parallel pool