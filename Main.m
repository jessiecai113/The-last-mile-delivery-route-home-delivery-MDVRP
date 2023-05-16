dataFileName = 'mdvrpData0053.txt';
[model] = initModel(dataFileName);


[individual] = model.initIndividual(model);
[individualFitness] = model.getIndividualFitness(individual, model);
model.showIndividual(individual, model);
model.printResult(individual, model);