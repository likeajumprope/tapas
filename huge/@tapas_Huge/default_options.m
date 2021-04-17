function [ options ] = default_options( ~ )
% Set default options for tapas_Huge class.
% 
% This is a protected method of the tapas_Huge class. It cannot be called
% from outside the class.
% 

% Author: Yu Yao (yao@biomed.ee.ethz.ch)
% Copyright (C) 2019 Translational Neuromodeling Unit
%                    Institute for Biomedical Engineering,
%                    University of Zurich and ETH Zurich.
% 
% This file is part of TAPAS, which is released under the terms of the GNU
% General Public Licence (GPL), version 3. For further details, see
% <https://www.gnu.org/licenses/>.
% 
% This software is provided "as is", without warranty of any kind, express
% or implied, including, but not limited to the warranties of
% merchantability, fitness for a particular purpose and non-infringement.
% 
% This software is intended for research only. Do not use for clinical
% purpose. Please note that this toolbox is under active development.
% Considerable changes may occur in future releases. For support please
% refer to:
% https://github.com/translationalneuromodeling/tapas/issues
% 


options = struct();

% name value pairs
options.nvp = struct(...
    'burnin'                , [], ...
    'confounds'             , [], ...
    'confoundsvariant'      , 'default', ...
    'dcm'                   , [], ...
    'inversetemperature'    , 1, ...
    'k'                     , 1, ...
    'kernelratio'           , [10 100], ...
    'method'                , 'VB', ...
    'numberofiterations'    , [], ...
    'omitfromclustering'    , [], ...
    'priorclustermean'      , 0, ...
    'priorclustervariance'  , .01, ...
    'priordegree'           , 100, ...
    'priorvarianceratio'    , .1, ...
    'randomize'             , false, ...
    'retainsamples'         , 1000, ...
    'saveto'                , [], ...
    'seed'                  , [], ...
    'startingvaluedcm'      , 'prior', ...
    'startingvaluegmm'      , 'prior', ...
    'tag'                   , '', ...
    'transforminput'        , false, ...
    'verbose'               , false ...
);

% starting values
options.start = struct(...
    'dcm', .1, ...
    'gmm', .1);

options.prior = struct(    ...
    'alpha_0'   ,   1.0,   ...
    'S_0'       ,   0.01,  ...
    'm_0'       ,   0.0,   ...
    'tau_0'     ,   0.1,   ...
    'nu_0'      , 100.0,   ...
    'mu_h'      ,   0.0,   ...
    'Sigma_h'   , [exp(-6) 1e-2 1 exp(-6)], ... % 1 self, 2 a, 3 bcd, 4 hemo
    'mu_lambda' ,   2.0,   ...
    's2_lambda' ,   4.0,   ...
    'm_beta_0'  ,   0.0,   ...
    'S_beta_0'  ,   1.0 );

options.convergence = struct(...
    'dDcm'      ,   100, ...
    'dClusters' ,   10, ...
    'dVb'       ,   1e-5, ...
    'bUseKmeans',   true ...
    );

% number of MH steps per iteration
options.mh.nSteps = struct( ...
    'weights' ,    1, ...
    'clusters',    1, ...
    'dcm'     ,    1, ... 
    'knGmm'   ,   10, ... % GMM kernel
    'knKm'    , 1000 );   % k-means mode hopping
% initial MH step size
options.mh.stepSize = struct( ...
    'pi'      , 0.5,   ....
    'mu'      , 0.01,  ....
    'kappa'   , 0.025, ....
    'theta'   , 0.01,  ....
    'lambda'  , 0.05);

% use single precision for Monte Carlo-based inversion
options.bSinglePrec = false;

% quantile levels for posterior summary
options.quantiles = (.025:.025:.975)';

% hemodynamic constants %%% TODO move to dcm
options.hemo = struct( ...
    'E_0'       ,   0.4,  ...
    'r_0'       ,  25.0,  ...
    'V_0'       ,   4.0,  ...
    'vartheta_0',  40.3,  ...
    'alpha'     ,   0.32, ...
    'gamma'     ,   0.32);

% gradient calculation 
options.delta = 1e-3; % step size


end

