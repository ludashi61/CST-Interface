% CST Interface - Interface with CST from MATLAB.
% Copyright (C) 2020 Alexander van Katwijk
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% With this object you may start an optimization run. For the optimization you have to define a set of parameters that will be changed by the optimizer and at least one goal function that will be optimized. The kind of goal function depends on the chosen solver type.
classdef Optimizer < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.DS.Project)
        % Only CST.DS.Project can create a Optimizer object.
        function obj = Optimizer(dsproject, hDSProject)
            obj.dsproject = dsproject;
            obj.hOptimizer = hDSProject.invoke('Optimizer');
        end
    end
    %% CST Object functions.
    methods
        %% General Methods
        function SetSimulationType(obj, task)
            % Chooses the optimizer task to be used. An empty argument selects the top level optimizer. This method must be called before any other method if an optimizer task should be queried or modified. If this method is not called then the top level optimizer is used, which will evaluate all active tasks of the current project when executing it's goal function.
            obj.hOptimizer.invoke('SetSimulationType', task);
        end
        function Start(obj)
            % Starts the optimizer with the previously made settings.
            obj.hOptimizer.invoke('Start');
        end
        %% Methods Concerning Parameters
        function InitParameterList(obj)
            % Initialize the optimizer's parameter list from the projects parameter list.
            obj.hOptimizer.invoke('InitParameterList');
        end
        function ResetParameterList(obj)
            % Deselect all parameters in the optimizer's parameter list. After calling this function no parameter is chosen to be optimized.
            obj.hOptimizer.invoke('ResetParameterList');
        end
        function SelectParameter(obj, paraName, bFlag)
            % Select the parameter specified by its name paraName. If bFlag is True the parameter named paraName is chosen to be optimized.
            obj.hOptimizer.invoke('SelectParameter', paraName, bFlag);
        end
        function SetParameterInit(obj, value)
            % This method initializes a previously selected parameter with the given value. The parameter is selected using the SelectParameter method.
            obj.hOptimizer.invoke('SetParameterInit', value);
        end
        function SetParameterMin(obj, value)
            % Set the minimum value the currently selected parameter can reach. You must select a parameter using the SelectParameter  method before you can apply this method.
            obj.hOptimizer.invoke('SetParameterMin', value);
        end
        function SetParameterMax(obj, value)
            % Set the maximum value the currently selected parameter can reach. You must select a parameter using the SelectParameter  method before you can apply this method.
            obj.hOptimizer.invoke('SetParameterMax', value);
        end
        function SetParameterAnchors(obj, number)
            % It is necessary to specify the number of samples per parameter used while the optimization is running. Set the number of samples for a selected parameter using this method. You must select a parameter using the SelectParameter  method before you can apply this method.
            obj.hOptimizer.invoke('SetParameterAnchors', number);
        end
        function SetMinMaxAuto(obj, percentage)
            % Sets the specified percentage for the calculation of the minimum and maximum values of all parameters.
            obj.hOptimizer.invoke('SetMinMaxAuto', percentage);
        end
        function SetAndUpdateMinMaxAuto(obj, percentage)
            % Resets the minimum and maximum values for all parameters. The new minimum and maximum values are calculated by subtracting respectively adding the specified percentage of the current parameter values to the current parameter values. If a parameter is 0 (or very close to 0), the minimum and maximum values are set to the negative respectively positive percentage value.
            obj.hOptimizer.invoke('SetAndUpdateMinMaxAuto', percentage);
        end
        function SetAlwaysStartFromCurrent(obj, bFlag)
            % Activate this method to initialize the optimizer with the current settings (bFlag = True), i.e. you can proceed optimizing your model starting each time from the previously optimized parameter results. However, if you want to restart the optimizer several times with the same initial parameter settings this method should be deactivated (bFlag = False).
            obj.hOptimizer.invoke('SetAlwaysStartFromCurrent', bFlag);
        end
        function SetUseDataOfPreviousCalculations(obj, bFlag)
            % Activate this method to trigger the import of previously calculated results for new optimizations to speed up the optimization process. If the result templates on which the optimizer goals are based were already evaluated before and the corresponding parameter combinations lie in the defined parameter space the results might be imported without the need for recalculation. For the local algorithms it's possible that the initial point is replaced if a more suitable point is found in advance. For the algorithms that use a set of initial points, multiple initial points will be replaced by points that lie close or have a better goal value than the points in the close neighborhood. This may disturb the selected distribution type but the algorithm will find a good compromise between finding points with good goal value and a well distributed set of starting points in the parameter space. Keep in mind that this feature will make the reproducibility of optimizations more difficult because after an optimization there will be more potential imports available than before.
            obj.hOptimizer.invoke('SetUseDataOfPreviousCalculations', bFlag);
        end
        %% Methods Concerning Goals in General
        function long = AddGoal(obj, goalType)
            % Creates a new goal and adds it to the internal list of goals. Upon creation an ID is created for each goal which is returned by this function. The newly defined goal is selected automatically for use.
            % goalType can have one of the following values:
            % "1D Primary Result"
            % Adds a goal for 1D result data other than template based post-processing
            % The goal specification can be done on some 1D task result.
            % "1DC Primary Result"
            % Adds a goal for complex valued 1D result data of some task other than template based post-processing
            % The goal specification can be done on some complex valued 1D task result  (e.g. S-Parameter)
            % "0D Result"
            % Adds a template based post-processing goal for 0D result data
            % The goal specification can be done on some template based post-processing that creates a single 0D value
            % "1D Result"
            % Adds a template based post-processing goal for 1D result data
            % The goal specification can be done on some template based post-processing that creates1D result data
            % "1DC Result"
            % Adds a template based post-processing goal for complex valued 1D result data
            % The goal specification can be done on some template based post-processing that creates1DC result data
            long = obj.hOptimizer.invoke('AddGoal', goalType);
        end
        function SelectGoal(obj, id, bFlag)
            % Selects the goal specified by its ID id. The ID is returned when the goal is created using the AddGoal function. It is necessary to call this method before many other methods may be called because these other methods apply to a previously selected goal.  If bFlag is True the selected goal is used for the optimization else it is ignored.
            obj.hOptimizer.invoke('SelectGoal', id, bFlag);
        end
        function DeleteGoal(obj, id)
            % Deletes the specified goal. To specify the goal use the ID that is returned by the AddGoal function when the goal is created.
            obj.hOptimizer.invoke('DeleteGoal', id);
        end
        function DeleteAllGoals(obj)
            % Deletes all goals that were previously created.
            obj.hOptimizer.invoke('DeleteAllGoals');
        end
        function SetGoalSummaryType(obj, summaryType)
            % Selects a summary type of all goals. The optimizer will minimize the sum or the maximum of all goals corresponding to what is selected.
            % summaryType: 'Sum_All_Goals'
            %              'Max_All_Goals'
            obj.hOptimizer.invoke('SetGoalSummaryType', summaryType);
        end
        function SetGoal(obj, ownerName, containerName, dataName)
            % Sets the specifications for a previously defined result data goal. Result data always refers to the owner/container/data scheme: The owner is either the complete model referred to as "Design" or an individual block or a probe each referred to by name.
            obj.hOptimizer.invoke('SetGoal', ownerName, containerName, dataName);
        end
        function SetGoalUseFlag(obj, bFlag)
            % Marks a previously defined goal to be used or not to be used for the optimization. You must select a previously defined goal using the SelectGoal method before you can apply this method.
            obj.hOptimizer.invoke('SetGoalUseFlag', bFlag);
        end
        function SetGoalOperator(obj, operatorType)
            % Almost every goal needs a goal operator that indicates how to evaluate the goal function value. The selectable operator types depend on the goal type of the currently selected goal. E.g. the operators "min", "max", "<", ">" or "="  indicate that a goal function should be minimized, maximized, lowered under or raised upon a certain value or that the goal function should reach a certain value respectively. You must select a previously defined goal using the SelectGoal method before you can apply this method.
            obj.hOptimizer.invoke('SetGoalOperator', operatorType);
        end
        function can = OperatorType(obj)
            % <
            % lower goal function value under a given target value
            % 0D, 1D and 1DC goals
            % >
            % raise goal function value upon a given target value
            % 0D, 1D and 1DC goals
            % =
            % 0D and 1D template based post-processing goals
            % 0D, 1D and 1DC goals
            % min
            % minimize goal function
            % 0D, 1D and 1DC goals based on the amplitude, real or imaginary part of an S-Parameter
            % max
            % maximize goal function
            % 0D, 1D and 1DC goals based on the amplitude, real or imaginary part of an S-Parameter
            % move min
            % minimize the abscissa distance of the minimum of the 1D result to the selected target. Keep in mind that sensitivities can't be exploited if this goal is used because the min operator is not differentiable
            % 1D and 1DC goals with range type other than "single"
            % move max
            % minimize the distance of the maximum of the 1D result to the selected target. Keep in mind that sensitivities can't be exploited if this goal is used because the max operator is not differentiable
            % 1D and 1DC goals with range type other than "single"
            can = obj.hOptimizer.invoke('OperatorType');
        end
        function SetGoalTarget(obj, value)
            % Sets a target value for a previously defined goal. You must select a previously defined goal using the SelectGoal method before you can apply this method.
            obj.hOptimizer.invoke('SetGoalTarget', value);
        end
        function SetGoalWeight(obj, value)
            % Each goal can be weighted. Thus it is possible to distinguish between goals of greater or less importance. You must select a previously defined goal using the SelectGoal method before you can apply this method.
            obj.hOptimizer.invoke('SetGoalWeight', value);
        end
        function SetGoalScalarType(obj, scalarType)
            % Defines the real scalar type of the complex valued result on which the goal operator is evaluated.
            % scalarType: 'maglin'
            %             'magdb10'
            %             'magdb20'
            %             'real'
            %             'imag'
            %             'phase'
            obj.hOptimizer.invoke('SetGoalScalarType', scalarType);
        end
        %% Methods Concerning Special Goal Settings
        function SetGoal1DResultName(obj, resultName)
            % Set the (absolute) tree name of a 1D task result that is not a template based post-processing result to the previously selected goal.
            obj.hOptimizer.invoke('SetGoal1DResultName', resultName);
        end
        function SetGoal1DCResultName(obj, resultName)
            % Set the (absolute) tree name of a complex valued 1D result that is not a template based post-processing result to the previously selected goal.
            obj.hOptimizer.invoke('SetGoal1DCResultName', resultName);
        end
        function SetGoalTemplateBased0DResultName(obj, resultName)
            % Set the name of a template based post-processing 0D result. The name needs to be an absolute path containing the template based post-processing path and the template name to the previously selected template based post-processing 0D goal.
            obj.hOptimizer.invoke('SetGoalTemplateBased0DResultName', resultName);
        end
        function SetGoalTemplateBased1DResultName(obj, resultName)
            % Set the name of a template based post-processing 1D result. The name needs to be an absolute path containing the template based post-processing path and the template name to the previously selected template based post-processing 1D goal.
            obj.hOptimizer.invoke('SetGoalTemplateBased1DResultName', resultName);
        end
        function SetGoalTemplateBased1DCResultName(obj, resultName)
            % Set the name of a complex valued template based post-processing 1D result. The name needs to be an absolute path containing the template based post-processing path and the template name to the previously selected template based post-processing 1DC goal.
            obj.hOptimizer.invoke('SetGoalTemplateBased1DCResultName', resultName);
        end
        function SetGoalRange(obj, Min, Max)
            %  Set a range for a previously selected 1D or 1DC result goal. You must select a previously defined 1D result goal using the SelectGoal method before you can apply this method.
            obj.hOptimizer.invoke('SetGoalRange', Min, Max);
        end
        function SetGoalRangeType(obj, rangeType)
            % For a defined template based post-processing 1D result goal, you can define the range that is being evaluated with this goal while the optimization is running. If the 1D result goal is based on an S-Parameter template then the range may cover the entire frequency range (total) of the simulation, only a part of the simulation's frequency range (range) or only one single frequency point (single). You must select a previously defined 1D result goal using the SelectGoal method before you can apply this method.
            % rangeType: 'total'
            %            'range'
            %            'single'
            obj.hOptimizer.invoke('SetGoalRangeType', rangeType);
        end
        function UseSlope(obj, bFlag)
            % Sets a previously defined goal to use a slope for the goal operator. The selected goal needs to be defined on a range and the operators have to be "<", ">" or "=". The slope will be from the target at the minimum range to the maximum target at the maximum range.
            obj.hOptimizer.invoke('UseSlope', bFlag);
        end
        function SetGoalTargetMax(obj, target2)
            %  Sets a previously defined goal to use target2 as maximum target. This setting has only an effect if the goal is set to use a slope operator, set by the method UseSlope.
            obj.hOptimizer.invoke('SetGoalTargetMax', target2);
        end
        function SetGoalNormNew(obj, summaryType)
            % Sets the norm for a previously defined goal. For "MaxDiff" the goal value will be the maximal violation in the goal range. "MaxDiffSq" is the square of the maximal violation. "SumDiff" will take the sum of all goal violations to calculate the goal. "SumDiffSq" will take a sum of squares. "Diff" and "DiffSq" are only applicable to 0D goals and are calculated as the absolute value of the difference and the square of the violation respectively.
            % summaryType: 'MaxDiff'
            %              'MaxDiffSq'
            %              'SumDiff'
            %              'SumDiffSq'
            %              'Diff'
            %              'DiffSq'
            obj.hOptimizer.invoke('SetGoalNormNew', summaryType);
        end
        %% Methods Concerning Special Optimizer Settings
        function SetOptimizerType(obj, optimizerType)
            % You can choose between two kinds of optimizers here. The Quasi-Newton optimizer supports the interpolation of primary data reducing the overall calculation time. The Powell optimizer does not support the interpolation of primary data. Thus, the Powell optimizer will usually need more calculation time than the interpolating Quasi-Newton optimizer but in some cases the Powell optimizer may be more accurate.
            % optimizerType can have one of the following values:
            % "Trust_Region"
            % Selects a local optimizing technique embedded in a trust region framework. The algorithm starts with building a linear model on primary data in a "trust" region around the starting point. For building this model sensitivity information of the primary data will be exploited if provided. Fast optimizations are done based on this local model to achieve a candidate for a new solver evaluation. The new point is accepted, if it is superior to the anchors of the model. If the model is not accurate enough the radius of the trust region will be decreased and a model on the new trust region will be created. The algorithm will be converged once the trust region radius or distance to the next predicted optimum becomes smaller than the specified domain accuracy.
            % "Nelder_Mead_Simplex"
            % Selects the local Simplex optimization algorithm by Nelder and Mead. This method is a local optimization technique. If N is the number of parameters, it starts with N+1 points distributed in the parameter space.
            % "CMAES"
            % Selects the global Covariance Matrix Adaptation Evolutionary Strategy. The method follows a global optimization approach in general. An internal step size parameter introduces a convergence property to the method.
            % "Genetic_Algorithm"
            % Selects the global genetic optimizer.
            % "Particle_Swarm"
            % Selects the global particle swarm optimizer.
            % "Interpolated_NR_VariableMetric"
            % Selects the local optimizer supporting interpolation of primary data. This optimizer is fast in comparison to the Classic Powell optimizer but may be less accurate. In addition, you can set the number N of optimizer passes (1 to 10) for this optimizer type. A number N greater than 1 forces the optimizer to start over (N-1) times. Within each optimizer pass the minimum and maximum settings of the parameters are changed approaching the optimal parameter setting. Increase the number of passes to values greater than 1 (e.g., 2 or 3)  to obtain more accurate results. It is recommended for the most common EM optimizations not to increase the number higher than 3 but to increase the number of samples in the parameter list, if the results are not suitable.
            obj.hOptimizer.invoke('SetOptimizerType', optimizerType);
        end
        function SetUseInterpolation(obj, interpolationType, optimizerType)
            % This option is only available for the Genetic Algorithm or the Particle Swarm Optimization. Check this box to activate the interpolation, and disables the sample values in the parameter list.
            % For both global optimizers it is possible to switch on the Interpolation of Primary Data. If the interpolation is applied the only true solver runs that will be done are the ones for the evaluation of the specified anchors and a final solver run for the estimated  best parameters. All other goal function evaluations will be interpolated.
            % Please note that global optimization algorithms have the probability of exploring most of the parameter space. Thus it is most likely that all or nearly all anchor points will actually be evaluated. Keep in mind that the number of solver runs needed for interpolation is dependant of the number of parameters whereas the number of solver runs needed for the two global optimization algorithms are independent of the number of parameters. Because of this, the usage of the interpolation feature will only pay off if the parameter space is not too high dimensional or a large number of iterations is planned.
            % Since the possible goal functions that can be defined have always non negative values the optimization will automatically be stopped if one of the anchor evaluations yields a goal value equal zero.
            % interpolationType,: 'Second_Order'
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            obj.hOptimizer.invoke('SetUseInterpolation', interpolationType, optimizerType);
        end
        function SetGenerationSize(obj, size, optimizerType)
            % It's possible to specify the population size for the Genetic Algorithm or the Particle Swarm Optimization. Keep in mind that choosing a small population size increases the risk that the genes can be depleted. If a large population size is chosen there will be more solver evaluations necessary for the calculation of each generation.
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            obj.hOptimizer.invoke('SetGenerationSize', size, optimizerType);
        end
        function SetMaxIt(obj, max_it, optimizerType)
            % Set the maximal number of iterations. The Genetic Algorithm or the Particle Swarm Optimization will stop after the maximal number of iterations have been done. Like this, it is possible to estimate the maximal optimization time a priori. If "n" is the population size and "m" is the maximal number of iterations "(m+1)*n/2 + 1" solver runs will be done. However this estimation is not valid if the Interpolation feature SetUseInterpolation is switched on, the optimization is aborted or the desired accuracy is reached
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            %                'CMAES'
            obj.hOptimizer.invoke('SetMaxIt', max_it, optimizerType);
        end
        function SetInitialDistribution(obj, distributionType, optimizerType)
            % For the featured global optimization techniques and the  Nelder Mead Simplex Algorithm a set of initial points in the parameter space are necessary. These points will automatically be generated by a uniform random distribution generator or by the Latin Hyper Cube approach.
            % Uniform Random Numbers:  For each starting point a pseudo random number generator will choose uniformly distributed points in the parameter space.
            % Latin Hyper Cube:  Randomly chosen points sometimes have the disadvantage that they do not have optimal space filling properties in the parameter space. The Latin Hyper Cube sampling has the special property that a projection onto each parameter interval yields an equidistant sampling.
            % Noisy Latin Hyper Cube Distribution:  The initial points are distributed similar to the Latin Hyper Cube Distribution but a perturbation is added on each point. This distribution type has similar space filling properties as the Latin Hyper Cube Distribution but the generated point set will be less regular. This distribution type is only available for the Nelder Mead Simplex Algorithm.
            % distributionType,: 'Uniform_Random_Numbers'
            %                    'Latin_Hyper_Cube'
            %                    'Noisy_Latin_Hyper_Cube'
            %                    'Cube_Distribution'
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            %                'Nelder_Mead_Simplex'
            obj.hOptimizer.invoke('SetInitialDistribution', distributionType, optimizerType);
        end
        function SetGoalFunctionLevel(obj, level, optimizerType)
            % A desired goal function level can be specified for the Genetic Algorithm or the Particle Swarm Optimization. The algorithm will be stopped if the goal function value is less than the specified level. However, if the optimization is done distributed this criterion will only be checked after the complete population was calculated. If the desired level is set to zero then the Maximal Number of Iterations is the only breaking condition.
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            %                'Nelder_Mead_Simplex'
            obj.hOptimizer.invoke('SetGoalFunctionLevel', level, optimizerType);
        end
        function SetMutaionRate(obj, rate, optimizerType)
            % If the genes of  two parents are similar enough the mutation rate specifies the probability that a mutation occurs. This option is only available for the Genetic Algorithm and the Particle Swarm Optimization.
            % optimizerType: 'Genetic_Algorithm'
            %                'Particle_Swarm'
            obj.hOptimizer.invoke('SetMutaionRate', rate, optimizerType);
        end
        function SetMinSimplexSize(obj, size)
            % Sets the minimal simplex size for the Nelder Mead Simplex Algorithm. For optimization the parameter space is mapped onto the unit cube. The simplex is a geometrical figure that moves in this multidimensional space. The algorithm will stop as soon as the largest edge of the Simplex will be smaller than the specified size. If the optimization is defined over  just one parameter in the interval [0;1] then this setting corresponds with the desired accuracy in the parameter space.
            obj.hOptimizer.invoke('SetMinSimplexSize', size);
        end
        function SetUseMaxEval(obj, bFlag, optimizerType)
            % Set this option to enable the use of the maximal number of evaluations. This option is only available for the Nelder Mead Simplex Algorithm.
            % optimizerType: 'Nelder_Mead_Simplex'
            %                'CMAES'
            obj.hOptimizer.invoke('SetUseMaxEval', bFlag, optimizerType);
        end
        function SetMaxEval(obj, number, optimizerType)
            % Sets the maximal number of evaluations for the Nelder Mead Simplex Algorithm. Depending on the optimization problem definition it is possible that the specified goal function level can't be reached. If in addition a small value is chosen for minimal simplex size it is possible that the algorithm needs more goal function evaluations to converge. In this case it is convenient to define a maximal number of function evaluations to restrict optimization time a priory. This number has to be greater than one.
            % optimizerType: 'Nelder_Mead_Simplex'
            %                'CMAES'
            obj.hOptimizer.invoke('SetMaxEval', number, optimizerType);
        end
        function SetUsePreDefPointInInitDistribution(obj, bFlag, optimizerType)
            % This option is only available for the Nelder Mead Simplex Algorithm. If this feature is switched on then the point that is defined as anchor point in the parameter list will be included in the initial data set of the algorithm. If the current parameter settings are already quite good then it makes sense to include this point in the starting set. After the set of initial points is generated the closest point from the automatically generated set will be substituted with the predefined point. However if the current point was created by a previous optimization run of a local optimizer and a second optimization is planned on a reduced parameter space this setting should be turned off because it increases the risk that the second optimization will converge to the same local optimum as before. In this case the second optimization won't yield any improvement.
            % optimizerType: 'Nelder_Mead_Simplex'
            %                'CMAES'
            obj.hOptimizer.invoke('SetUsePreDefPointInInitDistribution', bFlag, optimizerType);
        end
        function SetNumRefinements(obj, number)
            % Sets the number of Quasi-Newton optimizer passes. With each Quasi-Newton optimizer pass past the first pass, the minimum and maximum parameter values are refined around the optimal parameter values found in the previous pass.
            obj.hOptimizer.invoke('SetNumRefinements', number);
        end
        function SetDomainAccuracy(obj, accuracy, optimizerType)
            % Set the accuracy of the optimizer in the parameter space if all parameter ranges are mapped to the interval [0,1]. This option is only available for the Trust Region Framework.
            % optimizerType: 'Trust_Region'
            obj.hOptimizer.invoke('SetDomainAccuracy', accuracy, optimizerType);
        end
        function SetSigma(obj, value, optimizerType)
            % This option is only available for CMAES. It sets the sigma of the normal distribution used in the algorithm to the defined value, which must be greater zero and less or equal one.
            % optimizerType: 'CMAES'
            obj.hOptimizer.invoke('SetSigma', value, optimizerType);
        end
        function SetDataStorageStrategy(obj, storageType)
            % Sets the storage strategy for the 1D results produced during the optimization. For optimizations which generate much results on each evaluation or are expected to run for many evaluations it's possible to save time and disc space by avoiding the storage of the signals via the option "None". This setting doesn't apply to template based post-processing results.
            % storageType: 'All'
            %              'Automatic'
            %              'None'
            obj.hOptimizer.invoke('SetDataStorageStrategy', storageType);
        end
        %% Queries
        function long = GetNumberOfVaryingParameters(obj)
            % Returns the number of varying parameters.
            long = obj.hOptimizer.invoke('GetNumberOfVaryingParameters');
        end
        function name = GetNameOfVaryingParameter(obj, index)
            % Returns the name of the parameter referenced by index between 0 and N-1, where N can be determined by GetNumberOfVaryingParameters.
            name = obj.hOptimizer.invoke('GetNameOfVaryingParameter', index);
        end
        function double = GetValueOfVaryingParameter(obj, index)
            % Returns the value of the parameter referenced by index between 0 and N-1, where N can be determined by GetNumberOfVaryingParameters.
            double = obj.hOptimizer.invoke('GetValueOfVaryingParameter', index);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        dsproject                       CST.DS.Project
        hOptimizer

    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% % Optimize a RLC circuit
% This macro demonstrates how do define an optimization task on the S-Parameters of a simple RLC circuit, which is previously  generated from scratch
% 
% %define parameters that will later on be used for the optimization
% DS.StoreDoubleParameter(('Ind1', 1.0 )
% DS.StoreDoubleParameter(('Cap1', 1.0 )
% 
% Units.Frequency('GHz');
% 
% %define a very simple RLC circuit
% optimizer = dsproject.Optimizer();
% .Reset
% .name('GND');
% .type('Ground');
% .Position(5000, 4200)
% .Create
% .Reset
% .name('Resistor');
% .type('CircuitBasic\Resistor');
% .Position(4300, 4000)
% .Create
% .Reset
% .name('Capacitor');
% .type('CircuitBasic\Capacitor');
% .Position(4600, 4000)
% .Create
% .SetDoubleProperty('Capacitance', 'Cap1'); )
% .Reset
% .name('Inductor');
% .type('CircuitBasic\Inductor');
% .Position(4900, 4000)
% .Create
% .SetDoubleProperty('Inductance', 'Ind1'); )
% 
% .Reset
% .Number(1)
% .Position(4000, 4000)
% .Create
% .SetImpedanceType 1
% .SetImpedance 50
% 
% .Reset
% .SetPortFromBlockPort(1, 'GND', '1', 0)
% .SetPortFromBlockPort(2, 'Inductor', '2', 0)
% .Create
% .Reset
% .SetPortFromBlockPort(1, 'Inductor', '1', 0)
% .SetPortFromBlockPort(2, 'Capacitor', '2', 0)
% .Create
% .Reset
% .SetPortFromBlockPort(1, 'Capacitor', '1', 0)
% .SetPortFromBlockPort(2, 'Resistor', '2', 0)
% .Create
% .Reset
% .SetPortFromBlockPort(1, 'Resistor', '1', 0)
% .SetPortFromExternalPort(2, '1', 0)
% .Create
% 
% %define the optimization task and the S-Parameter task
% .Reset
% .Name('Opt');
% 
% If Not .DoesExist Then
% .Type('Optimization');
% .Create
% 
% .Reset
% .Type('S-Parameters');
% .Name('Opt\SPar');
% .SetProperty('fmin', 0)
% .SetProperty('fmax', 10)
% .SetProperty('maximum frequency range', '0');
% .Create
% End If
% 
% %set up the optimization settings and start the optimizer
% .SetSimulationType(('Opt'); )
% .SetOptimizerType('Trust_Region');
% .SetAlwaysStartFromCurrent(0)
% 
% .InitParameterList
% .SelectParameter('Ind1', 1)
% .SetParameterInit(2.0)
% .SetParameterMin(1.0)
% .SetParameterMax(3.0)
% .SelectParameter('Cap1', 1)
% .SetParameterInit(2.0)
% .SetParameterMin(1.0)
% .SetParameterMax(3.0)
% .DeleteAllGoals
% 
% %define a goal on the S-Parameters
% Dim gid As Integer
% gid = .AddGoal('1DC Primary Result');
% .SelectGoal(gid, 1)
% .SetGoal1DCResultName('Opt\SPar\S-Parameters\S1,1');
% .SetGoalScalarType('magdB20');
% .SetGoalOperator('<');
% .SetGoalTarget(-30)
% .SetGoalRangeType('range');
% .SetGoalRange(3.9,4.1)
% 
% .Start %actually start the optimization process
% 
