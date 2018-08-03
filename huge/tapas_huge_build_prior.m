%% [ priors, DcmInfo ] = tapas_huge_build_prior( DcmInfo )
%
% Generates values for prior parameters for HUGE. Prior mean of cluster
% centers and prior mean and covariance of heamodynamic parameters follow
% SPM convention (SPM8 r6313).
%
% INPUT:
%       DcmInfo    - EITHER: struct containing DCM model specification and
%                            BOLD time series in DcmInfo format (see
%                            tapas_huge_simulate.m for an example)
%                    OR:     cell array of DCM in SPM format
%
% OUTPUT:
%       priors  - struct containing priors
%       DcmInfo - struct containing DCM model specification and BOLD time
%                 series in DcmInfo format
%
% REFERENCE:
%
% Yao Y, Raman SS, Schiek M, Leff A, Fr�ssle S, Stephan KE (2018).
% Variational Bayesian Inversion for Hierarchical Unsupervised Generative
% Embedding (HUGE). NeuroImage, 179: 604-619
% 
% https://doi.org/10.1016/j.neuroimage.2018.06.073
%

% Author: Yu Yao (yao@biomed.ee.ethz.ch)
% Copyright (C) 2018 Translational Neuromodeling Unit
%                    Institute for Biomedical Engineering,
%                    University of Zurich and ETH Zurich.
% 
% This file is part of TAPAS, which is released under the terms of the GNU
% General Public Licence (GPL), version 3. For further details, see
% <http://www.gnu.org/licenses/>.
% 
% This software is intended for research only. Do not use for clinical
% purpose. Please note that this toolbox is in an early stage of
% development. Considerable changes are planned for future releases. For
% support please refer to:
% https://github.com/translationalneuromodeling/tapas/issues
function [ priors, DcmInfo ] = tapas_huge_build_prior( DcmInfo )
%% check input format
if ~isfield(DcmInfo,'listBoldResponse')
    try
        DcmInfo = tapas_huge_import_spm(DcmInfo);
    catch err
        disp(['TAPAS:HUGE: Unsupported format. '...
              'Use cell array of DCM in SPM format as first input.'])
        rethrow(err);
    end
end


%% set priors
priors = struct();
priors.alpha = 1;
tmp = DcmInfo.adjacencyA/64/DcmInfo.nStates;
tmp = tmp - diag(diag(tmp)) - .5*eye(DcmInfo.nStates);
tmp = [tmp(:); DcmInfo.adjacencyC(:)*0; DcmInfo.adjacencyB(:)*0; ...
       DcmInfo.adjacencyD(:)*0];
priors.clustersMean = tmp(DcmInfo.connectionIndicator)'; % SPM 8 prior
priors.clustersTau = 0.1;
priors.clustersDeg = max(100,1.5^DcmInfo.nConnections);
priors.clustersDeg = min(priors.clustersDeg,realmax('single'));
priors.clustersSigma = 0.01*eye(DcmInfo.nConnections)*...
                       (priors.clustersDeg - DcmInfo.nConnections - 1);
priors.hemMean = zeros(1,DcmInfo.nStates*2 + 1); % SPM 8 prior
priors.hemSigma = diag(zeros(1,DcmInfo.nStates*2 + 1)+exp(-6)); % SPM prior

priors.noiseInvScale = .025;
priors.noiseShape = 1.28;


end

