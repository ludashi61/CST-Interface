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

% Use this object to define discrete face ports. Beside waveguide ports or
% plane waves the discrete face ports offers another possibility to feed
% the calculation domain with power. The discrete face port is a special
% kind of discrete port. It is supported by the integral equation solver,
% the transient solvers, as well as the frequency domain solver with
% tetrahedral mesh. The discrete face port is replaced by a Discrete Edge
% Port if any other solver is chosen. Two different types of discrete face
% ports are available, considering the excitation as a voltage or as an
% impedance element which also absorbs some power and enables S-parameter
% calculation.
classdef DiscreteFacePort < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.DiscreteFacePort object.
        function obj = DiscreteFacePort(project, hProject)
            obj.project = project;
            obj.hDiscreteFacePort = hProject.invoke('DiscreteFacePort');
        end
    end
    %% CST Object functions.
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            % Creates a new discrete face port. All necessary settings have
            % to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = ['With DiscreteFacePort', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['Create DiscreteFacePort "', num2str(obj.portnumber), '"'], obj.history);
            obj.history = [];
        end
        function Modify(obj)
            % Modifies an existing face port. Only non-geometrical
            % settings which were made previously are changed.
            obj.AddToHistory(['.Modify']);
            
            % Prepend With and append End With
            obj.history = ['With DiscreteFacePort', newline, obj.history, 'End With'];
            obj.project.AddToHistory(['Modify DiscreteFacePort "', num2str(obj.portnumber, '%.15g'), '"'], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            % Resets all internal values to their default settings.
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.portnumber = [];
        end
        function PortNumber(obj, portnumber)
            % Chooses the discrete face port by its number.
            obj.AddToHistory(['.PortNumber "', num2str(portnumber), '"']);
            obj.portnumber = portnumber;
        end
        function Label(obj, label)
            % Sets the label of the discrete port.
            obj.AddToHistory(['.Label "', label, '"']);
        end
        function Type(obj, type)
            % Defines the type of the discrete port.
            % type: 'Sparameter'
            %       'Voltage'
            %       'Current'
            obj.AddToHistory(['.Type "', type, '"']);
        end
        function Impedance(obj, impedance)
            % Specifies the input impedance of the discrete face port, if
            % it is of type 'Sparameter'.
            obj.AddToHistory(['.Impedance "', num2str(impedance), '"']);
        end
        function VoltagePortImpedance(obj, voltageportimpedance)
            % Specifies the input impedance of the discrete face port, if
            % it is of type 'Voltage'.
            obj.AddToHistory(['.VoltagePortImpedance "', num2str(voltageportimpedance), '"']);
        end
        function VoltageAmplitude(obj, amplitude)
            % Specifies the input impedance of the discrete face port, if
            % it is of type 'Voltage'.
            obj.AddToHistory(['.VoltageAmplitude "', num2str(amplitude), '"']);
        end
        function SetP1(obj, picked, x, y, z)
            % Define the starting / end point of the discrete face port.
            % picked has to be True however, hence the coordinates are only
            % used as a reference.
            if(nargin < 3)
                x = 0;
                y = 0;
                z = 0;
            end
            obj.AddToHistory(['.SetP1 "', num2str(picked), '", '...
                                     '"', num2str(x), '", '...
                                     '"', num2str(y), '", '...
                                     '"', num2str(z), '"']);
        end
        function SetP2(obj, picked, x, y, z)
            % Define the starting / end point of the discrete face port.
            % picked has to be True however, hence the coordinates are only
            % used as a reference.
            if(nargin < 3)
                x = 0;
                y = 0;
                z = 1;
            end
            obj.AddToHistory(['.SetP2 "', num2str(picked), '", '...
                                     '"', num2str(x), '", '...
                                     '"', num2str(y), '", '...
                                     '"', num2str(z), '"']);
        end
        function InvertDirection(obj, boolean)
            % Set switch to True to reverse the orientation of the discrete
            % face port.
            obj.AddToHistory(['.InvertDirection "', num2str(boolean), '"']);
        end
        function LocalCoordinates(obj, boolean)
            % This method decides whether local (flag = True) or global
            % (flag = False) coordinates will be used for determining the
            % location of the discrete face port.
            obj.AddToHistory(['.LocalCoordinates "', num2str(boolean), '"']);
        end
        function CenterEdge(obj, boolean)
            % The excitation takes place at the center edge of the port.
            obj.AddToHistory(['.CenterEdge "', num2str(boolean), '"']);
        end
        function UseProjection(obj, boolean)
            % When this flag is activated then one edge is projected onto
            % the other edge and the discrete face port is created in
            % between the edge and its projection.
            obj.AddToHistory(['.UseProjection "', num2str(boolean), '"']);
        end
        function ReverseProjection(obj, boolean)
            % When this flag is activated then the second picked edge will
            % be projected onto the first picked edge. This flag is only
            % considered when UseProjection is active.
            obj.AddToHistory(['.ReverseProjection "', num2str(boolean), '"']);
        end
        function Monitor(obj, boolean)
            % This method decides whether voltage and current of the
            % discrete face port should be monitored or not.
            obj.AddToHistory(['.Monitor "', num2str(boolean), '"']);
        end
        function AllowFullSize(obj, boolean)
            % This flag tells the solvers whether they are allowed to let
            % the active area of the face port extend over the complete
            % port face, rather than adding metallic sheets at both ends of
            % the port. Currently only influences rectangular or
            % cylinder-barrel face ports in the Frequency Domain solver
            % with Tetrahedral mesh.
            obj.AddToHistory(['.AllowFullSize "', num2str(boolean), '"']);
        end
        %% Undocumented functions
        function CurrentAmplitude(obj, amplitude)
            obj.AddToHistory(['.CurrentAmplitude "', num2str(amplitude), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hDiscreteFacePort
        history
        
        portnumber
    end
end

%% Default settings.
% PortNumber(1)
% Label('')
% Type(SParameter)
% Impedance(50.0)
% VoltageAmplitude(1.0)
% VoltagePhase(0.0)
% SetP1(1, 0.0, 0.0, 0.0)
% SetP2(1, 0.0, 0.0, 0.0)
% LocalCoordinates(0)
% InvertDirection(0)
% CenterEdge(0)
% Monitor(0)
% AllowFullSize(1)

%% Example - Taken from CST documentation and translated to MATLAB.
% % Define a discrete port
% discretefaceport = project.DiscreteFacePort();
%      discretefaceport.Reset();
%      discretefaceport.PortNumber(1);
%      discretefaceport.Type('SParameter');
%      discretefaceport.Impedance(50.0);
%      discretefaceport.VoltageAmplitude(1.0);
%      discretefaceport.SetP1(1, -3.9, -0.5, 0.2);
%      discretefaceport.SetP2(1, 4.7, 0.15, 2.1);
%      discretefaceport.LocalCoordinates(0);
%      discretefaceport.InvertDirection(1);
%      discretefaceport.CenterEdge(1);
%      discretefaceport.Monitor(0);
%      discretefaceport.Create();
%  
% % Delete the discrete port
% port = project.Port();
% port.Delete(1);