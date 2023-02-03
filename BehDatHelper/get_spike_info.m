function spikeStruct = get_spike_info(sessPath)
    
%Getting spike info from Kilosort3 files
unsortedSpikeTimes = double(readNPY(strcat(sessPath, '\spike_times.npy')));
unsortedSpikeClusters = double(readNPY(strcat(sessPath, '\spike_clusters.npy')))+1;
clusterInfo = tdfread(strcat(sessPath, '\cluster_info.tsv'));

%Combining your manually curated clusters (if any) with those that kilosort
%automatically assigns
for cluster = 1:length(clusterInfo.id)
    if isnan(clusterInfo.group(cluster,1))
        clusterInfo.group(cluster,1) = clusterInfo.KSLabel(cluster,1); 
    elseif regexp('   ', clusterInfo.group(cluster,:)) == 1
        clusterInfo.group(cluster,1) = clusterInfo.KSLabel(cluster,1);
    elseif regexp('    ', clusterInfo.group(cluster,:)) == 1
        clusterInfo.group(cluster,1) = clusterInfo.KSLabel(cluster,1);
    elseif regexp('     ', clusterInfo.group(cluster,:)) == 1
        clusterInfo.group(cluster,1) = clusterInfo.KSLabel(cluster,1);
    end
end

%Pulling out only the clusters labeled 'good' (the ones that start with a 'g')
%and putting them into a matrix called GoodClusters
goodClusters = clusterInfo.id(ismember(clusterInfo.group(:,1),'g') == 1)+1;
clusterInfo.ch = clusterInfo.ch + 1; 
goodChannels = num2cell(clusterInfo.ch(ismember(clusterInfo.group(:,1),'g') == 1)); 
numCells = length(goodClusters);

spikeTimeArray = cell(numCells, 1);
for cluster = 1:numCells
    spikeTimeArray{cluster} = (unsortedSpikeTimes(unsortedSpikeClusters == goodClusters(cluster))');
end

spikeStruct= struct('times', spikeTimeArray, 'regions', [], 'channels', goodChannels);
