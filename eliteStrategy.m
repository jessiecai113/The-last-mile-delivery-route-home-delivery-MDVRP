function [P, F] = eliteStrategy(population, popFitness, newPopulation, newPopFitness, Mode)
% 
    if Mode == 0
        [P, F] = noneEliteSelect(population, popFitness, newPopulation, newPopFitness);
    elseif Mode == 1
        [P, F] = weakEliteSelect(population, popFitness, newPopulation, newPopFitness);
    else
        [P, F] = strongEliteSelect(population, popFitness, newPopulation, newPopFitness);
    end
end

function [P, F] = strongEliteSelect(population, popFitness, newPopulation, newPopFitness)
% 
    totalPopulation = [population; newPopulation];                          % 
    totalFitness = [popFitness; newPopFitness];
    
    [totalFitness, index] = sort(totalFitness);                             % 
    totalPopulation = totalPopulation(index,:);
    
    populationSize = size(totalPopulation, 1) / 2;
    P = totalPopulation(populationSize + 1:end, :);                         % 
    F = totalFitness(populationSize + 1:end, :);                            % 
end


function [P, F] = weakEliteSelect(population, popFitness, newPopulation, newPopFitness)
% 
    totalPopulation = [population; newPopulation];                          % 
    totalFitness = [popFitness; newPopFitness];
    
    [maxF, index] = max(totalFitness);
    P = newPopulation;
    F = newPopFitness;
    [~, I] = max(F);
    P(I, :) = totalPopulation(index, :);
    F(I) = maxF;

end


function [P, F] = noneEliteSelect(population, popFitness, newPopulation, newPopFitness)
% 
    P = newPopulation;
    F = newPopFitness;
end




