function analyzeResults(allData,options)

nIterations = length(allData);
iterVec = [1:nIterations];

for i = 1:nIterations
    if strncmp(options.Objective,'L2',2)
        ynorm(i) = get2norm(allData(i).output,allData(i).time);
    else
        thisy = allData(i).output;
        L = zeros(size(thisy,1),1);
        for j=1:size(thisy,1)
            L(j) = thisy(j,:)*thisy(j,:)';
        end
        ynorm(i) = max(L);
    end    
end

nDeltas = 0;
if ~isempty(options.UncertainParamRange)
    nDeltas = size(options.UncertainParamRange,1);
    delta = zeros(nIterations,nDeltas);
    for i = 1:nIterations
        thisInput = allData(i).input;
        delta(i,:) = thisInput(1,end-nDeltas+1);
    end

    figure;
    subplot(2,1,1)
        plot(iterVec,ynorm,'.')
        xlabel('Iteration')
        ylabel('Objective')
    subplot(2,1,2)
        for i = 1:nDeltas
            plot(iterVec,delta(:,i),'.')
            hold on
        end
        xlabel('Iteration')
        ylabel('Deltas')
else
    figure;
    plot(iterVec,ynorm,'.')
    xlabel('Iteration')
    ylabel('Objective')
end
    
figure;
for k = 1:nIterations
    colorScale = 0.8*(nIterations-k)/nIterations;
    if k==nIterations
        color = [0 0 0.2];
    else
        color = [colorScale,colorScale,1];
    end
    thisinput = allData(k).input;
    thisu = thisinput(:,1:end-nDeltas);
    plot(allData(k).time,thisu,'Color',color);
    hold on
end
xlabel('Time')
ylabel('Input')
title('Sequence of Inputs')
