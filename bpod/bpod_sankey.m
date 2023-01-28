function bpod_sankey(session)
startState = cell(0);
endState = cell(0);
for trial = 1:session.nTrials
    stateNames = session.RawData.OriginalStateNamesByNumber{trial};
    trialEvents = session.RawData.OriginalStateData{trial};
    numStates = numel(trialEvents);
    for state = 1:numStates-1
%         if any(strcmp({'ITI2', 'DelayOnHold', 'DelayWaitForReentry'}, stateNames{trialEvents(state)}))
            startState{end+1} = stateNames{trialEvents(state)};
            endState{end+1} = stateNames{trialEvents(state+1)};
%         end
    end
end

startState = categorical(startState');
endState = categorical(endState');
t = table(startState, endState, 'VariableNames', ["Start", "End"]);

options.color_map = 'parula';      
options.flow_transparency = 0.2;   % opacity of the flow paths
options.bar_width = 120;            % width of the category blocks
options.show_perc = false;          % show percentage over the blocks
options.text_color = [0 0 0];      % text color for the percentages
options.show_layer_labels = true;  % show layer names under the chart
options.show_cat_labels = true;   % show categories over the blocks.
options.show_legend = false;    

plotSankeyFlowChart(t, options);

%Carlos Borau (2023). Sankey flow chart (https://www.mathworks.com/matlabcentral/fileexchange/101516-sankey-flow-chart), MATLAB Central File Exchange. Retrieved January 28, 2023. 
