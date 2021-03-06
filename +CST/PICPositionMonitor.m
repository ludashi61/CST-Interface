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

% Suppress warnings:
% Use of brackets [] is unnecessary. Use parenteses to group, if needed.
     %#ok<*NBRAK> 

% Defines a 3D particle position monitor, which records at a given sampling rate detailed data for each particle, such as position, momentum and charge.
classdef PICPositionMonitor < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.PICPositionMonitor object.
        function obj = PICPositionMonitor(project, hProject)
            obj.project = project;
            obj.hPICPositionMonitor = hProject.invoke('PICPositionMonitor');
            obj.history = [];
        end
    end
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
    end
    %% CST Object functions.
    methods
        function Reset(obj)
            % Resets all internal values to their default settings.
            obj.AddToHistory(['.Reset']);
            
            obj.name = [];
        end
        function Name(obj, monitorName)
            % Sets the name of the monitor.
            obj.AddToHistory(['.Name "', num2str(monitorName, '%.15g'), '"']);
            obj.name = monitorname;
        end
        function Tstart(obj, startTime)
            % Sets starting time for a time domain monitor to startTime.
            obj.AddToHistory(['.Tstart "', num2str(startTime, '%.15g'), '"']);
        end
        function Tstep(obj, timeStep)
            % Sets the time increment for a time domain monitor to timeStep.
            obj.AddToHistory(['.Tstep "', num2str(timeStep, '%.15g'), '"']);
        end
        function Tend(obj, stopTime)
            % Sets the end time for a time domain monitor to stopTime.
            obj.AddToHistory(['.Tend "', num2str(stopTime, '%.15g'), '"']);
        end
        function UseTend(obj, bFlag)
            % If bFlag is True the time domain monitor stops storing the results when the end time that is set with Tend is reached. Otherwise the monitor will continue until the simulation stops.
            obj.AddToHistory(['.UseTend "', num2str(bFlag, '%.15g'), '"']);
        end
        function Delete(obj, monitorName)
            % Deletes the monitor named monitorName.
            obj.project.AddToHistory(['PICPositionMonitor.Delete "', num2str(monitorName, '%.15g'), '"']);
        end
        function Rename(obj, oldname, newname)
            % Renames the monitor named oldname to newname.
            obj.project.AddToHistory(['PICPositionMonitor.Rename "', num2str(oldname, '%.15g'), '", '...
                                                                '"', num2str(newname, '%.15g'), '"']);
        end
        function Create(obj)
            % Creates the monitor with the previously applied settings.
            obj.AddToHistory(['.Create']);
            
            % Prepend With PICPositionMonitor and append End With
            obj.history = [ 'With PICPositionMonitor', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define PICPositionMonitor: ', obj.name], obj.history);
            obj.history = [];
        end
        %% Queries
        function long = GetNumberOfMonitors(obj)
            % Returns the total number of defined monitors in the current project.
            long = obj.hPICPositionMonitor.invoke('GetNumberOfMonitors');
        end
        function name = GetMonitorNameFromIndex(obj, index)
            % Returns the name of the monitor with regard to the index in the internal monitor list .
            name = obj.hPICPositionMonitor.invoke('GetMonitorNameFromIndex', index);
        end
        function double = GetMonitorTstartFromIndex(obj, index)
            % Returns the start time of a particle position monitor with regard to the index in the internal monitor list.
            double = obj.hPICPositionMonitor.invoke('GetMonitorTstartFromIndex', index);
        end
        function double = GetMonitorTstepFromIndex(obj, index)
            % Returns the time increment value of a particle position monitor with regard to the index in the internal monitor list.
            double = obj.hPICPositionMonitor.invoke('GetMonitorTstepFromIndex', index);
        end
        function double = GetMonitorTendFromIndex(obj, index)
            % Returns the end time of a particle position monitor with regard to the index in the internal monitor list.
            double = obj.hPICPositionMonitor.invoke('GetMonitorTendFromIndex', index);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hPICPositionMonitor
        history

        name
    end
end

%% Default Settings
% Tstart(0.0)
% Tstep(0.0)
% Tend(0.0)
% UseTend(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% 
% % creates a PIC position monitor
% picpositionmonitor = project.PICPositionMonitor();
%     picpositionmonitor.Reset
%     picpositionmonitor.Name('ParticleMonitor 1');
%     picpositionmonitor.Tstart(1.0)
%     picpositionmonitor.Tstep(0.015)
%     picpositionmonitor.Tend(1.7)
%     picpositionmonitor.UseTend(1)
%     picpositionmonitor.Create
% 
% 
% 
