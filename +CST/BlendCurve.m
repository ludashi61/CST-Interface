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

% This object enables a blend operation on a curve item. The edge produced
% by two segments of the item will be smoothed by use of a circular shape
% with a specified radius that is inserted into the item. If the radius is
% chosen in a way that the structure would change significantly, the
% operation might not be possible. The blend operation will then modify the
% curve items connected to the selected point and create a new item which
% actually represents the blend. The blend item can be identified by an
% unique name, e.g. for subsequent editing operations.
%
% As soon as the blend is defined it will appear in the main plot window
% and on the Navigation Tree.
classdef BlendCurve < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.BlendCurve object.
        function obj = BlendCurve(project, hProject)
            obj.project = project;
            obj.hBlendCurve = hProject.invoke('BlendCurve');
            obj.Reset();
        end
    end
    %% CST Object functions.
    methods
        function AddToHistory(obj, command)
            obj.history = [obj.history, '     ', command, newline];
        end
        function Create(obj)
            % Creates a new curve item. All necessary settings for it have
            % to be made previously.
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = [ 'With BlendCurve', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['define curve blend: ', obj.curve, ':', obj.name, 'on: ', obj.curveitem1, ',', obj.curveitem2], obj.history);
            obj.history = [];
        end
        function CreateConditional(obj, condition)
            % Creates a new curve item. All necessary settings for it have
            % to be made previously.
            %
            % condition: An string of an expression that evaluates to True 
            %            or False
            obj.AddToHistory(['.Create']);
            
            % Prepend With and append End With
            obj.history = [ 'If ', condition, ' Then', newline, ...
                                'With BlendCurve', newline, ...
                                    obj.history, ...
                                'End With', newline, ...
                            'End If'];
            obj.project.AddToHistory(['define conditional curve blend: ', obj.curve, ':', obj.name, 'on: ', obj.curveitem1, ',', obj.curveitem2], obj.history);
            obj.history = [];
        end
        
        function Reset(obj)
            % Resets all internal settings to their default values.
            obj.history = [];
            obj.AddToHistory(['.Reset']);
            
            obj.name = [];
            obj.curve = [];
            obj.curveitem1 = [];
            obj.curveitem2 = [];
        end
        function Name(obj, name)
            % Sets the name of the new blend item.
            obj.AddToHistory(['.Name "', name, '"']);
            obj.name = name;
        end
        function Radius(obj, radius)
            % Resets all internal settings to their default values.
            obj.AddToHistory(['.Radius "', num2str(radius, '%.15g'), '"']);
        end
        function Curve(obj, curve)
            % Specifies the curve the new created blend item object will
            % belong to.
            obj.AddToHistory(['.Curve "', curve, '"']);
            obj.curve = curve;
        end
        function CurveItem1(obj, curveitem1)
            % Selects a specified curve item which has to belong to the
            % same curve object as curve item No.2.
            obj.AddToHistory(['.CurveItem1 "', curveitem1, '"']);
            obj.curveitem1 = curveitem1;
        end
        function CurveItem2(obj, curveitem2)
            % Selects a specified curve item which has to belong to the
            % same curve object as curve item No.1.
            obj.AddToHistory(['.CurveItem2 "', curveitem2, '"']);
            obj.curveitem2 = curveitem2;
        end
        function EdgeId1(obj, edgeid1)
            % Defines a specified edge of a curve item by its identity
            % number.
            obj.AddToHistory(['.EdgeId1 "', num2str(edgeid1), '"']);
        end
        function EdgeId2(obj, edgeid2)
            % Defines a specified edge of a curve item by its identity
            % number.
            obj.AddToHistory(['.EdgeId2 "', num2str(edgeid2), '"']);
        end
        function VertexId1(obj, vertexid1)
            % Defines a specified vertex of a curve item by its identity
            % number.
            obj.AddToHistory(['.VertexId1 "', num2str(vertexid1), '"']);
        end
        function VertexId2(obj, vertexid2)
            % Defines a specified vertex of a curve item by its identity
            % number.
            obj.AddToHistory(['.VertexId2 "', num2str(vertexid2), '"']);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties
        project
        hBlendCurve
        history
        
        name
        curve
        curveitem1
        curveitem2
    end
end

%% Example - Taken from CST documentation and translated to MATLAB.
% Example was corrected before inclusion here.
% blendcurve = project.BlendCurve()
%     blendcurve.Reset();
%     blendcurve.Name('chamfer1');
%     blendcurve.Width('2');
%     blendcurve.Curve('curve1');
%     blendcurve.CurveItem1('rectangle1');
%     blendcurve.CurveItem2('rectangle1');
%     blendcurve.EdgeId1('2');
%     blendcurve.EdgeId2('3');
%     blendcurve.VertexId1('3');
%     blendcurve.VertexId2('3');
%     blendcurve.Create();