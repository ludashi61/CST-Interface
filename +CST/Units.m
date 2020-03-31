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

% Cannot be autogenerated since the documentation cuts off halfway through.

classdef Units < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.Units object.
        function obj = Units(project, hProject)
            obj.project = project;
            obj.hUnits = hProject.invoke('Units');
            obj.history = [];
            obj.bulkmode = 0;
        end
    end
    methods
        function StartBulkMode(obj)
            % Buffers all commands instead of sending them to CST
            % immediately.
            obj.bulkmode = 1;
        end
        function EndBulkMode(obj)
            % Flushes all commands since StartBulkMode to CST.
            obj.bulkmode = 0;
            % Prepend With Units and append End With
            obj.history = [ 'With Units', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define units'], obj.history);
            obj.history = [];
        end
        function AddToHistory(obj, command)
            if(obj.bulkmode)
                obj.history = [obj.history, '     ', command, newline];
            else
                obj.project.AddToHistory(['Solver', command]);
            end
        end
    end
    %% CST Object functions.
    methods
        function Geometry(obj, unit)
            % m, cm, mm, um, nm, ft, in, mil
            % Default m.
            % cm: Centimeter
            % mm: Millimeter
            % um: Micrometer
            % nm: Nanometer
            % ft: Feet
            % in: Inch
            % mil: A Thousandth Inch
            
            obj.AddToHistory(['.Geometry "', unit, '"']);
        end
        function Frequency(obj, unit)
            % Default Hz.
            % Hz, KHz, MHz, GHz, THz, PHz
            
            obj.AddToHistory(['.Frequency "', unit, '"']);
        end
        function Voltage(obj, unit)
            % Default V.
            % V, ???
            
            obj.AddToHistory(['.Voltage "', unit, '"']);
        end
        function Resistance(obj, unit)
            % Default Ohm.
            % Ohm, ???
            
            obj.AddToHistory(['.Resistance "', unit, '"']);
        end
        function Inductance(obj, unit)
            % Default NanoH.
            % H, NanoH, ???
            
            obj.AddToHistory(['.Inductance "', unit, '"']);
        end
        function TemperatureUnit(obj, unit)
            % Default Kelvin.
            % Kelvin, Celcius, Fahrenheit
            
            obj.AddToHistory(['.TemperatureUnit "', unit, '"']);
        end
        function Time(obj, unit)
            % Default s.
            % s, ms, us, ns, ps, fs
            
            obj.AddToHistory(['.Time "', unit, '"']);
        end
        function Current(obj, unit)
            % Default A.
            % A, ???
            
            obj.AddToHistory(['.Current "', unit, '"']);
        end
        function Conductance(obj, unit)
            % Default Siemens.
            % Siemens, ???
            
            obj.AddToHistory(['.Conductance "', unit, '"']);
        end
        function Capacitance(obj, unit)
            % Default PikoF. (With a k)
            % F, PikoF, ???
            
            obj.AddToHistory(['.Capacitance "', unit, '"']);
        end
        %% Utility functions.
        function AllUnits(obj, geometry, frequency, voltage, resistance,...
                               inductance, temperature, time, current, ...
                               conductance, capacitance)
            obj.StartBulkMode();
            if(nargin > 1  && ~isempty(geometry   ));   obj.Geometry(geometry);             end
            if(nargin > 2  && ~isempty(frequency  ));	obj.Frequency(frequency);           end
            if(nargin > 3  && ~isempty(voltage    ));   obj.Voltage(voltage);               end
            if(nargin > 4  && ~isempty(resistance ));	obj.Resistance(resistance);         end
            if(nargin > 5  && ~isempty(inductance ));	obj.Inductance(inductance);         end
            if(nargin > 6  && ~isempty(temperature));	obj.TemperatureUnit(temperature);   end
            if(nargin > 7  && ~isempty(time       ));   obj.Time(time);                     end
            if(nargin > 8  && ~isempty(current    ));   obj.Current(current);               end
            if(nargin > 9  && ~isempty(conductance));	obj.Conductance(conductance);       end
            if(nargin > 10 && ~isempty(capacitance));	obj.Capacitance(capacitance);       end
            obj.EndBulkMode();
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hUnits
        history
        bulkmode

    end
end