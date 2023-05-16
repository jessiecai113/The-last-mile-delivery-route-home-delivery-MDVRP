dataFileName = 'mdvrpData0053.txt';
data = load(['.\Data\' dataFileName]);                                      % 

numOfPoints = size(data, 1);
model.numOfSupplyCentre = 3;                                                % 
model.numOfVehicle = 5;                                                     % 
model.capacityOfVehicle = 400;                                              % 
model.costOfVehicle = 500;                                                  % 
model.speed = 50;                                                           % 
model.priceOfUnitKm = 1;                                                    % 
model.salaryOfUnitTime = 30;                                                % 
model.rateCostOfUnitCO2 = 0.3;                                              % 

model.numOfCustomer = numOfPoints - model.numOfSupplyCentre;                % 
model.coordinateOfCustomer = data(1: model.numOfCustomer, 1: 2);            % 
model.demandOfCustomer = data(1: model.numOfCustomer, 3);                   % 
model.coordinateOfSupplyCentre = data(model.numOfCustomer + 1: end, 1: 2);	% 
% 
model.numOfDecVariables = model.numOfCustomer + model.numOfSupplyCentre * model.numOfVehicle;
% 
model.distanceMat = getDistanceMat(model.coordinateOfCustomer, model.coordinateOfSupplyCentre);




