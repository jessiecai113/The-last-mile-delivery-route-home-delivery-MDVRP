function [newPopulation] = crossoverOperationOfTsp(population, crossoverRate)


    [populationSize, n] = size(population);                                
    
    newPopulation = zeros(size(population));
    for i = 1 : populationSize
        if rand() < crossoverRate
            r0 = round(rand() * (n-1) + 1);                                 
            r1 = round(rand() * (n-1) + 1);
        else
            r0 = round(rand() * (n-1) + 1);                                 
            individual = population(i, :);                                 % 
            gene = individual(r0);                                          % 
            
            I = round(rand() * (populationSize-1) + 1);                    %
            individualI = population(I, :);                                % 
            index = find(individualI == gene);                             % 
            index = index(1);                                              % 
            if index < n                                                   % 
                index = index + 1;                                         % 
            else
                index = index - 1;                                         % 
            end
            
            gene = individualI(index);                                     % 
            index = find(individual == gene);                              % 
            index = index(1);                                              % 
            r1 = index;
        end   
        s = sort([r0 r1]);                                                  % 
        r0 = s(1);
        r1 = s(2);
        individual = population(i, :);
        individual(r0:r1) = individual(r1:-1:r0);                          % 
        newPopulation(i, :) = individual;
    end
    
end

