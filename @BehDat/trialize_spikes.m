function spikesByTrial = trialize_spikes(obj, trialStart)

% Returns a Nx1 cell array, where N is the number of neurons in the
% session. Each cell contains a 1xT cell array, where T is the number of
% trials.
% INPUT:
%     trialStart - an event named in config.ini marking the start of each trial

numNeurons = numel(obj.spikes);
spikesByTrial = cell(numNeurons, 1);
trialStartTimes = find_event(obj, trialStart);

for n = 1:numNeurons
    spikeTrialIdx = discretize(obj.spikes(n).times, [trialStartTimes obj.info.samples]);
    numTrials = max(spikeTrialIdx);
    numBpod = obj.bpod.nTrials;
    for t = 1:numTrials
        spikesByTrial{n}{t} = obj.spikes(n).times(spikeTrialIdx == t);
    end
    if numTrials < numBpod
        for t = numTrials+1:numBpod
            spikesByTrial{n}{t} = [];
        end
    end
end

