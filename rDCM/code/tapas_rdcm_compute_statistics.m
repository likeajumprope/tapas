function [ output ] = tapas_rdcm_compute_statistics(DCM, output, options)
% Computes statistics for the posterior parameter estimates
% 
% 	Input:
%   	DCM         - model structure
%       output      - model inversion results
%       options     - estimation options
%
%   Output:
%       output      - model inversion results with statistics
%
% 
% ----------------------------------------------------------------------
% 
% Authors: Stefan Fraessle (stefanf@biomed.ee.ethz.ch), Ekaterina I. Lomakina
% 
% Copyright (C) 2016-2018 Translational Neuromodeling Unit
%                         Institute for Biomedical Engineering
%                         University of Zurich & ETH Zurich
%
% This file is part of the TAPAS rDCM Toolbox, which is released under the 
% terms of the GNU General Public License (GPL), version 3.0 or later. You
% can redistribute and/or modify the code under the terms of the GPL. For
% further see COPYING or <http://www.gnu.org/licenses/>.
% 
% Please note that this toolbox is in an early stage of development. Changes 
% are likely to occur in future releases.
% 
% ----------------------------------------------------------------------


% get rDCM posterior estimates
output.allParam.par_est = tapas_rdcm_ep2par(output.Ep);


% get true (simulations) or VBL parameters
try
    output.allParam.par_true = tapas_rdcm_ep2par(DCM.Tp);
catch
    output.allParam.par_true = tapas_rdcm_ep2par(DCM.Ep);
end


% get the true present connections
output.allParam.idx = output.allParam.par_true~=0;


% compute statistics
output.statistics.mse_n = mean((output.allParam.par_est(output.allParam.idx) - output.allParam.par_true(output.allParam.idx)).^2)/norm(output.allParam.par_true(output.allParam.idx));
output.statistics.mse   = mean((output.allParam.par_est(output.allParam.idx) - output.allParam.par_true(output.allParam.idx)).^2);
output.statistics.sign  = sum(output.allParam.par_est(output.allParam.idx).*output.allParam.par_true(output.allParam.idx)<0);


% compute signal
if ( options.compute_signal )
    output = tapas_rdcm_compute_signals(DCM, output, options);
end

end
