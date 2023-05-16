function [newPopulation] = selectionOperationOfTournament(population, popFitness)

    K = 2;                                                                  % 
    populationSize= size(population, 1);                                    % 
    newPopulation = zeros(size(population));
    for i = 1: populationSize
        rs = unidrnd(populationSize, K, 1);
        tempFitness = popFitness(rs);
        [~, index] = sort(tempFitness);
        newPopulation(i, :) = population(rs(index(K)), :);
    end
end

