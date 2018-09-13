function [params] = Initialize_params(No_of_trajectories, Initial_SD,...
    Initial_Learning_Rate)

    params.objective.wtdecay = 0.0000; % 0.0001 % 0.01; % 0.10; % 0.01;
    params.objective.lambda = 0.1% 0.4; % 0.4; % 0.2; % 0.01; % 0.2; %0.2; %0.5; % 0.2 0.5<----------------------------------------------------
    params.objective.maxlandingvelocity = 25; %30; %35 m/s (35% soft landings) (4/17); <----------------------------------------------------
    params.objective.maxlandingheight = 0; % meters   %20 meters
    params.objective.penalty = 1; % 1; % 4/17/2016
    params.objective.temp = 1.0; % 5/27/2016 modified params structure
    params.environment1.nrtrajectories =  No_of_trajectories; %1000;
    params.environment1.timestep = 1; % simulation stepsize in seconds
    params.environment1.realtimeincrement = 0.0001; % (seconds in real time) % physically slows simulation
    params.environment1.maxtrajectorylength =  2000; %
    params.environment1.landingpreparationtime = 1; % (seconds in real time) % physically slows simulation
    params.environment2.initialvelocitymean = 100; %150 % meters/second
    params.environment2.initialvelocitystderr = Initial_SD; % meters/second
    params.environment2.initialheightmean = 15000; % meters
    params.environment2.initialheightstderr = 10; % meters was 20
    params.environment2.initialfuel = 3500; %4000; %3500 % 4000; % 3000 (4/17/2016) ; % kilograms <----------------------------------------------------
    params.environment2.escapevelocity = 25; %50; % meters/second  % original 50
    params.environment2.heightescapevelocity = 15000; %meters (realistic number is 110000)
    params.environment2.fuelefficiency = 2300;                               ; % meters/second
    params.environment2.glunar = 1.63; % m/sec^2 (lunar gravitational acceleration)
    params.environment2.lunarthrust = 25000; %25000; %30000; %25000; % meters-kg/sec^2
    params.environment2.masslander = 4000; % kg
    params.estimation.initialweightrange = 0.0001; %0.0001
    nrtrajectories = params.environment1.nrtrajectories;
    params.estimation.learningrate0 = Initial_Learning_Rate; % 0.01; % 0.001; %0.001; % 11/18/2015
    params.estimation.momentum = 0.0; %0.3; %0.5; % 4/15/2016
    params.estimation.learningratehalflife = ceil(nrtrajectories/2);
    params.estimation.maxwtsnorm = 15; % abort if magnitude of weights exceeds this value
    params.estimation.numberrecentaverage = 100;
    params.display.displaythrustprob = 1;
    params.environment2.maxheight = params.environment2.initialheightmean;
end

