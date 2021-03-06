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

% Import CATIA V4, CATIA V5 and 3DExperience CATIA files.
classdef CATIA < handle
    %% CST Interface specific functions.
    methods(Access = ?CST.Project)
        % Only CST.Project can create a CST.CATIA object.
        function obj = CATIA(project, hProject)
            obj.project = project;
            obj.hCATIA = hProject.invoke('CATIA');
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
            % Resets the import options to the default.
            obj.AddToHistory(['.Reset']);
            
            obj.filename = [];
        end
        function CatiaVersion(obj, version)
            % Sets the CATIA version of the import file. Versions 4 and 5 are valid options. In order to import CATIA V5, 3DExperience CATIA part files (file extension: CATPart) or assembly files (file extension: CATProduct) set the version to 5.  Version 4 will import  CATIA V4 part  files (file extension: model) or assembly files (file extension: exp).
            obj.AddToHistory(['.CatiaVersion "', num2str(version, '%.15g'), '"']);
        end
        function FileName(obj, filename)
            % Sets the name of the import file.
            obj.AddToHistory(['.FileName "', num2str(filename, '%.15g'), '"']);
            obj.filename = filename;
        end
        function Version(obj, version)
            % Sets the version of the import filter since the behavior of the import may slightly change from version to version. This setting is available for backward compatibility reasons and should ensure that later versions of the import can exactly reproduce the behavior of earlier versions. The most recent version of the import is 10.0.
            obj.AddToHistory(['.Version "', num2str(version, '%.15g'), '"']);
        end
        function Id(obj, id)
            % A CAD file may be imported more than once into the same project with different settings of import options. In order to improve the performance of structure rebuilds, an intermediate sat file is stored during the import process which allows to quickly re-read the data during rebuilds in case that the original CAD file has not been modified. The naming convention of the intermediate sat file has to be unique for each individual import step. Therefore, in case that the same file is imported more than once or a file with the same name is imported into the project, the Id setting needs to be increased. The Id will then be incorporated into the file name which ensures unique file names for every import.
            obj.AddToHistory(['.Id "', num2str(id, '%.15g'), '"']);
        end
        function Healing(obj, boolean)
            % If set to True structure will be healed after it is imported. Healing checks the imported structure and tries to repair it, if necessary.
            obj.AddToHistory(['.Healing "', num2str(boolean, '%.15g'), '"']);
        end
        function ScaleToUnit(obj, boolean)
            % If set to True the imported model is scaled to the currently active unit. If not activated the import feature uses the source units. In such a case, no scaling occurs.
            obj.AddToHistory(['.ScaleToUnit "', num2str(boolean, '%.15g'), '"']);
        end
        function ImportToActiveCoordinateSystem(obj, boolean)
            % Import the CAD data relative to the active coordinate system.
            obj.AddToHistory(['.ImportToActiveCoordinateSystem "', num2str(boolean, '%.15g'), '"']);
        end
        function Curves(obj, boolean)
            % If set to True curves will be imported from the import file.
            obj.AddToHistory(['.Curves "', num2str(boolean, '%.15g'), '"']);
        end
        function ImportAttributes(obj, boolean)
            % Identifies if attributes like solid names, material names and material color should be read from the import file. This setting is not used for CATIA V4 files.
            obj.AddToHistory(['.ImportAttributes "', num2str(boolean, '%.15g'), '"']);
        end
        function ImportCurveAttributes(obj, boolean)
            % Identifies if the attributes like curve names should be read from the import file. This setting is not used for CATIA V4 files.
            obj.AddToHistory(['.ImportCurveAttributes "', num2str(boolean, '%.15g'), '"']);
        end
        function Read(obj)
            % Starts the actual import of the file.
            obj.AddToHistory(['.Read']);
            
            % Prepend With CATIA and append End With
            obj.history = [ 'With CATIA', newline, ...
                                obj.history, ...
                            'End With'];
            obj.project.AddToHistory(['import CATIA: ', obj.filename], obj.history);
            obj.history = [];
        end
    end
    %% MATLAB-side stored settings of CST state.
    % Note that these can be incorrect at times.
    properties(SetAccess = protected)
        project
        hCATIA
        history

        filename
    end
end

%% Default Settings
% FileName('');
% Version(4)
% CatiaVersion(4)
% Healing(1)
% ImportToActiveCoordinateSystem(0)
% ImportCurves(0)
% ImportAttributes(0)

%% Example - Taken from CST documentation and translated to MATLAB.
% catia = project.CATIA();
%     catia.Reset
%     catia.FileName('.\example.model');
%     catia.Healing(1)
%     catia.ImportToActiveCoordinateSystem(0)
%     catia.ImportCurves(1)
%     catia.ImportAttributes(1)
%     catia.Read    
