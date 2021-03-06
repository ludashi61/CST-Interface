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

classdef EvaluateFieldAlongCurve < handle
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.EvaluateFieldAlongCurve object.
        function obj = EvaluateFieldAlongCurve(project, hProject)
            obj.project = project;
            obj.hEvaluateFieldAlongCurve = hProject.invoke('EvaluateFieldAlongCurve');
        end
    end
    %% CST Interface specific functions.
    methods
        function PlotField(obj, curvename, component)
            % Creates a 1D-plot of the selected field component / absolute
            % value along the curve named by sCurveName. The plot is put
            % under "1D Results\Field Along Curves\<sCurveName>" in the
            % Navigation Tree.
            %
            % component: 'x'
            %            'y'
            %            'z'
            %            'abs'
            %            'tangential'
            obj.hEvaluateFieldAlongCurve.invoke('PlotField', curvename, component);
        end
        function [real, imag] = IntegrateField(obj, curvename, component)
            % Integrates the real and imaginary part of the selected field
            % component / absolute value along the curve named by
            % sCurveName. The integrals are returned in the double
            % variables dIntReal and dIntImag.
            %
            % component: 'x'
            %            'y'
            %            'z'
            %            'abs'
            %            'tangential'
            functionString = [...
                'Dim real As Double, imag As Double', newline, ...
                'EvaluateFieldAlongCurve.IntegrateField(', curvename, ', ', component, ', real, imag)', newline, ...
            ];
            returnvalues = {'real', 'imag'};
            [real, imag] = obj.dsproject.RunVBACode(functionString, returnvalues);
            % Numerical returns.
            real = str2double(real);
            imag = str2double(imag);
        end
        function FitCurveToGridForPlot(obj, boolean)
            % If boolean is set to 1, the field is plot along a curve path
            % which is fitted to the mesh cells. Else, the field is
            % interpolated on the exact curve positions for the plot.
            obj.hEvaluateFieldAlongCurve.invoke('FitCurveToGridForPlot', boolean);
        end
        function FitCurveToGridForIntegration(obj, boolean)
            % If boolean is set to 1, the field is integrated along a curve
            % path which is fitted to the mesh cells. Set to False to
            % interpolate the field on the exact curve positions for the
            % integration.
            obj.hEvaluateFieldAlongCurve.invoke('FitCurveToGridForIntegration', boolean);
        end
        function EvaluateOnSurface(obj, boolean)
            % If boolean is set to 1, the field is evaluated on the nearest
            % surface to the curve path, disregarding volume results. This
            % can be used to avoid zero result values, if the curve path is
            % defined on a surface bordering a volume with zero field
            % values (e.g. PEC).
            obj.hEvaluateFieldAlongCurve.invoke('EvaluateOnSurface', boolean);
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hEvaluateFieldAlongCurve

    end
end

%% Default Settings
% FitCurveToGridForPlot(0)
% FitCurveToGridForIntegration(1)
% EvaluateOnSurface(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% % NOTE: This example does not work due to the fact that IntegrateField is not implemented.
% evaluatefieldalongcurve = project.EvaluateFieldAlongCurve();
% evaluatefieldalongcurve.FitCurveToGridForIntegration(1);
% evaluatefieldalongcurve.IntegrateField('curve1', 'tangential", dIntReal, dIntImag);
% evaluatefieldalongcurve.PlotField('curve1', 'tangential');
% project.SelectTreeItem("1D Results\Field Along Curves\curve1\Mag");
% fprintf('%g+j%g\n', dIntReal, dIntImag);