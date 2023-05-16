function [popFitness] = getFitness(population, model)
% 
    populationSize = size(population, 1);
    popFitness = zeros(populationSize, 1);
    
    for i = 1: populationSize
        individual = population(i, :);
        popFitness(i) = model.getIndividualFitness(individual, model);
    end
end

