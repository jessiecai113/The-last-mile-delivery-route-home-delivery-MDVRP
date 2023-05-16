function [newPopulation] = mutationOperationOfTsp(population, mutationRate)
% 
    populationSize = size(population, 1);
    newPopulation = zeros(size(population));
    for i = 1 : populationSize
        individual = population(i, :);
        newPopulation(i, :) = mutateIndividual(individual, mutationRate);
    end

end

%% 
function [individual] = mutateIndividual(individual, mutationRate)
    n = length(individual);
    for i = 1: n
        if rand() < mutationRate
            r0 = individual(i);                                             % 
            r1 = round(rand() * (n-1) + 1);                                 % 
            s = sort([r0 r1]);                                              % 
            r0 = s(1);
            r1 = s(2);
            individual(r0:r1) = individual(r1:-1:r0);                      	% 
        end
    end
end

