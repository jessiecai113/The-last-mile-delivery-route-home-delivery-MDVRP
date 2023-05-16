function [model] = initModel(dataFileName)
    data = load(['.\Data\' dataFileName]);                                      % 

    numOfPoints = size(data, 1);
    model.numOfSupplyCentre = 15;                                                % the number of DC
    model.numOfVehicle = 3;                                                     % The number of vehicle for each DC 
    model.capacityOfVehicle = 800;                                              % 
    model.costOfVehicle = 200;                                                  % for each vehicle
    model.speed = 50;                                                           % 
    model.priceOfUnitKm = 1;                                                    % 
    model.salaryOfUnitTime = 30;                                                % 
    model.rateCostOfUnitCO2 = 0.3;                                              % 
    model.rentOfDC = 200;                                              % 
    model.costRetentionOfUnitTime = 0;                                       % 

    model.numOfCustomer = numOfPoints - model.numOfSupplyCentre;                % 
    model.coordinateOfCustomer = data(1: model.numOfCustomer, 1: 2);            % 
    model.demandOfCustomer = data(1: model.numOfCustomer, 3);                   % 
    model.coordinateOfSupplyCentre = data(model.numOfCustomer + 1: end, 1: 2);	% 
    % 
    model.numOfDecVariables = model.numOfCustomer + model.numOfSupplyCentre * model.numOfVehicle;
    % 
    model.distanceMat = getDistanceMat(model.coordinateOfCustomer, model.coordinateOfSupplyCentre);
    
    
	model.initIndividual = @initIndividual;                                 % 
	model.getIndividualFitness = @getIndividualFitness;                     % 
    model.showIndividual = @showIndividual;                                 % 
    model.printResult = @printResult;                                       % 
    model.getAllRouteDistance = @getAllRouteDistance;                       % 
    model.repairIndividual = @repairIndividual;                             % 
    model.getDepartNum = @getDepartNum;                                     % 
    model.getSupplyCentreNum = @getSupplyCentreNum;                         % 
    model.getOverload = @getOverload;                                       %
end

%% 
function [individual] = initIndividual(model)
	numOfCustomer = model.numOfCustomer;                                    % 
    numOfSupplyCentre = model.numOfSupplyCentre;                            % 
    numOfVehicle = model.numOfVehicle;                                      % 

    temp = meshgrid(1:numOfSupplyCentre,1:numOfVehicle) + numOfCustomer;
    temp = reshape(temp,[1,numOfSupplyCentre * numOfVehicle]);
    sequence = [1 : numOfCustomer, temp];
    individual = sequence(randperm(length(sequence)));
end

%% 
function [individualFitness] = getIndividualFitness(individual, model)
    [allRouteDistance] = getAllRouteDistance(individual, model);            % Total distance
    [overload] = getOverload(individual, model);                            % overload

    [cost1] = getCost1(individual, model);                                  % cost of vehicle
    [cost2] = getCost2(allRouteDistance, model);                            % unit cost/km
    [cost3] = getCost3(allRouteDistance, model);                            % salary
    [cost4] = getCost4(allRouteDistance, model);                            % CO2
    [cost5] = getCost5(individual, model);                                  % rent for DC
    [cost6] = getCost6(allRouteDistance, model);                            % costRetentionOfUnitTime 
    
    penaltyFactor = 10^ 7;                                                  % 
    individualFitness = - cost1 - cost2 - cost3 - cost4 - cost5 - cost6 - overload * penaltyFactor;
end

% 
function printResult(individual, model)
    [allRouteDistance] = getAllRouteDistance(individual, model);            % 
    [overload] = getOverload(individual, model);                            % 

    [cost1] = getCost1(individual, model);                                  % 
    [cost2] = getCost2(allRouteDistance, model);                            % 
    [cost3] = getCost3(allRouteDistance, model);                            % 
    [cost4] = getCost4(allRouteDistance, model);                            % 
    [cost5] = getCost5(individual, model);                                  % 
    [cost6] = getCost6(allRouteDistance, model);                            % costRetentionOfUnitTime 
    
    penaltyFactor = 10^ 7;                                                  % 
    individualFitness = - cost1 - cost2 - cost3 - cost4 - cost5 - cost6 - overload * penaltyFactor;
    fprintf('total distance:%.2f overload:%.2f cost of vehicle:%.2f unit cost:%.2f salary:%.2f CO2:%.2f rentofDC:%.2f costRetentionOfUnitTime:%.2f Ä¿±êº¯Êý:%.2f\n', allRouteDistance, overload, cost1, cost2, cost3, cost4, cost5, cost6, -individualFitness);
end

% 
function [cost1] = getCost1(individual, model)
    [numOfDepart] = getDepartNum(individual, model);                        % 
    cost1 = numOfDepart * model.costOfVehicle;                              % 
end

% 
function [cost2] = getCost2(allRouteDistance, model)
    cost2 = allRouteDistance * model.priceOfUnitKm;                         % 
end

% 
function [cost3] = getCost3(allRouteDistance, model)
    cost3 = allRouteDistance / model.speed * model.salaryOfUnitTime;        % 
end

% 
function [cost4] = getCost4(allRouteDistance, model)
    cost4 = allRouteDistance * model.rateCostOfUnitCO2;                     % 
end

% 
function [cost5] = getCost5(individual, model)
    [numOfSupplyCentre] = getSupplyCentreNum(individual, model);            % 
    cost5 = numOfSupplyCentre * model.rentOfDC;                    % 
end

% 
function [cost6] = getCost6(allRouteDistance, model)
    cost6 = allRouteDistance / model.speed * model.costRetentionOfUnitTime;	% 
end


%% 
function showIndividual(individual, model)
    numOfCustomer = model.numOfCustomer;                                    % 
    coordinateOfCustomer = model.coordinateOfCustomer;                      % 
    coordinateOfSupplyCentre = model.coordinateOfSupplyCentre;              % 
    
    centreIndex = find(individual > numOfCustomer);                         % 
    centreIndexEnd = [centreIndex(2 : end) - 1 , length(individual)];
    
    coordinate = [coordinateOfCustomer; coordinateOfSupplyCentre];          % 
    xCoord = coordinate(:, 1);
    yCoord = coordinate(:, 2);
    hold on;
    n = 0;
    for i = 1 : length(centreIndex)
        startI = centreIndex(i);
        endI = centreIndexEnd(i);
        routeOfVehicle = [individual(startI : endI) individual(startI)];   	% 
        if length(routeOfVehicle) > 2
            n = n + 1;
            fprintf('vehiclepath%d£º', n);
            disp(routeOfVehicle);
        end
        plot(xCoord(routeOfVehicle),yCoord(routeOfVehicle),'-o','LineWidth',1,'MarkerSize',3,'MarkerFaceColor','white');
    end
    
	for i = 1 : size(coordinate,1)
        text(xCoord(i), yCoord(i),['   ' num2str(i)], 'FontSize', 8);
	end
    
    for i = numOfCustomer + 1 : length(xCoord)
        plot(xCoord(i), yCoord(i), '*r','MarkerSize',20,'LineWidth',2);           % *
    end
    title('Route', 'Fontsize', 20);
    drawnow;
    hold off;
end

%% 
function [allRrouteDistance] = getAllRouteDistance(individual, model)
    numOfCustomer = model.numOfCustomer;                                    % 
    
    centreIndex = find(individual > numOfCustomer);                         % 
    centreIndexEnd = [centreIndex(2 : end) - 1 , length(individual)];
    
    allRrouteDistance = 0;
    for i = 1 : length(centreIndex)
        startI = centreIndex(i);
        endI = centreIndexEnd(i);
        routeOfVehicle = [individual(startI : endI) individual(startI)];   	% 
        routeDistance = getRouteDistance(routeOfVehicle, model);            % 
        allRrouteDistance = allRrouteDistance + routeDistance;
    end
end

%% 
function [routeDistance] = getRouteDistance(route, model)
    routeDistance = 0;  
    for i = 1: length(route) - 1
        city1 = route(i);
        city2 = route(i + 1);
        dis = model.distanceMat(city1, city2);                        % 
        routeDistance = routeDistance + dis;                                % 
    end
end

%% 
function [numOfSupplyCentre] = getSupplyCentreNum(individual, model)
    numOfCustomer = model.numOfCustomer;                                    % 
    
    centreIndex = find(individual > numOfCustomer);                         % 
    centreIndexEnd = [centreIndex(2 : end) - 1 , length(individual)];
    
    supplyCentreMark = zeros(1, model.numOfSupplyCentre + model.numOfCustomer);
    for i = 1 : length(centreIndex)
        startI = centreIndex(i);
        endI = centreIndexEnd(i);
        if startI ~= endI
            supplyCentreMark(individual(startI)) = 1;
        end
    end
    numOfSupplyCentre = sum(supplyCentreMark);
end

%% 
function [numOfDepart] = getDepartNum(individual, model)
    numOfCustomer = model.numOfCustomer;                                    % 
    
    centreIndex = find(individual > numOfCustomer);                         % 
    centreIndexEnd = [centreIndex(2 : end) - 1 , length(individual)];
    
    numOfDepart = 0;
    for i = 1 : length(centreIndex)
        startI = centreIndex(i);
        endI = centreIndexEnd(i);
        if startI ~= endI
            numOfDepart = numOfDepart + 1;
        end
    end
end

%% 
function [newIndividual] = repairIndividual(individual, model)
    numOfCustomer = model.numOfCustomer;                                    % 
    newIndividual = individual;
    centreIndex = find(individual > numOfCustomer);                         % 
    t = centreIndex(1);
    temp = newIndividual(1);
    newIndividual(1) = newIndividual(t);
    newIndividual(t) = temp;                                                   % 
end


%% 
function [overload] = getOverload(individual, model)
    numOfCustomer = model.numOfCustomer;                                    % 
    demandOfCustomer = model.demandOfCustomer;                              % 
    capacityOfVehicle = model.capacityOfVehicle;                            % 
    
    centreIndex = find(individual > numOfCustomer);                         % 
    centreIndexEnd = [centreIndex(2 : end) - 1 , length(individual)];
    
    overload = 0;
    for i = 1 : length(centreIndex)
        startI = centreIndex(i);
        endI = centreIndexEnd(i);
        customerOfVehicle = individual(startI + 1: endI);                   % 
        loadOfVehicle = sum(demandOfCustomer(customerOfVehicle));           % 
        if loadOfVehicle > capacityOfVehicle
            overload = overload + (loadOfVehicle - capacityOfVehicle);
        end
    end
end

% if x is the NO. of customer, the customer to 1 ,or DC to 0
function [isCustomer] = judgeIsCustomer(x, model)
    numOfCustomer = model.numOfCustomer;                                    % 
    isCustomer = 1;                                                         % 
    if x > numOfCustomer
        isCustomer = 0;                                                     % 
    end
end


%% 
function [distanceMat] = getDistanceMat(coordinateOfCustomer, coordinateOfSupplyCentre)
    coordinate = [coordinateOfCustomer; coordinateOfSupplyCentre];          % 
    num = size(coordinate, 1);                                              % 
    distanceMat = zeros(num, num);
    for i = 1 : num
        for j = 1 : num
            coordI = coordinate(i, :);                                      % 
            coordJ = coordinate(j, :);                                      % 
            distanceMat(i, j) = LpNorm(coordI, coordJ, 2);                  % 
        end
    end
end

function [disMat] = LpNorm(vector1, vector2, p)

% vector1 = [0 0]; vector2 = [3 4]; p = 2;              disMat = [5];
%     vector1 = [0 0; 2 2]; vector2 = [3 4; 1 1]; p = 1;	disMat = [7;2];
    N = size(vector1, 1);
    disMat = zeros(N, 1);
    for i = 1 : N
        v1 = vector1(i, :);
        v2 = vector2(i, :);
        disMat(i) = sum(abs(v1 - v2).^p).^(1./p);    
    end
end
