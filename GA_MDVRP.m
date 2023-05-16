
%% 
clear;                                                                      % 
close all;                                                                  % 
clc;                                                                        %
%% 
addpath(genpath('.\'));                                                     % 
rng(0,'twister');
populationSize = 100;                                                       % 
maxGeneration = 50000;                                                      % 
crossoverRate = 0.6;                                                        % 
mutationRate = 0.01;                                                        % 


dataFileName = 'mdvrpData0420.txt';                                         % 
[model] = initModel(dataFileName);                                          % 
%% 
population = initialPopulation(populationSize, model);                      % 
population = repairOperation(population, model);                            % 
popFitness = getFitness(population, model);                                 % 
numOfDecVariables = size(population, 2);                                    % 

bestIndividualSet = zeros(maxGeneration, numOfDecVariables);                % 
bestFitnessSet = zeros(maxGeneration, 1);                                   % 
avgFitnessSet = zeros(maxGeneration, 1);                                    % 

%% 
for i = 1 : maxGeneration
    
    newPopulation = selectionOperationOfTournament(population, popFitness);	% 
    newPopulation = crossoverOperationOfTsp(newPopulation, crossoverRate);	% 
    newPopulation = mutationOperationOfTsp(newPopulation, mutationRate);    % 
    newPopulation = repairOperation(newPopulation, model);                 	% 
    newPopFitness = getFitness(newPopulation, model);                       % 
    [population, popFitness] = eliteStrategy(population, popFitness, newPopulation, newPopFitness, 2); % 
 
    
    [bestIndividual, bestFitness, avgFitness] = getBestIndividualAndFitness(population, popFitness);
    bestIndividualSet(i, :) = bestIndividual;                               % 
    bestFitnessSet(i) = bestFitness;                                        % 
    avgFitnessSet(i) = avgFitness;                                          % 
    fprintf('The %ith PS optimal value：%.3f\n', i, -bestFitness);
    
    if mod(i, 50000) == 0                                                     % 
        close all; 
        subplot(1,2,1);
        showIndividual(bestIndividual, model);                                 % 
        subplot(1,2,2);
        showEvolCurve(200, i, -bestFitnessSet, -avgFitnessSet);                 % 
        model.printResult(bestIndividual, model);
    end
end











