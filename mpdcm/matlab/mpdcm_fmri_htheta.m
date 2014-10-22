function [htheta] = mpdcm_fmri_htheta(ptheta)
%% Produces the kernel used for the proposal distribution. 
%
% aponteeduardo@gmail.com
% copyright (C) 2014
%

hA = 0.01;
hB = 0.01;
hC = 0.01;

ht = 0.01;
hd = 0.01;
he = 0.01;

hlambda = 0.01;

htheta = struct('c_c', []);

% Evaluate the identity operator

c_A = hA * eye(sum(logical(ptheta.a(:))));
c_B = hB * eye(sum(logical(ptheta.b(:))));
c_C = hC * eye(sum(logical(ptheta.c(:))));

nr = size(ptheta.a, 1);
nu = size(ptheta.c, 2);

c_transit = ht * eye(nr);
c_decay = hd * eye(nr);
c_epsilon = he * eye(1);

c_lambda = hlambda * eye(size(ptheta.Q, 3));

htheta.c_c = sparse(blkdiag(chol(c_A), chol(c_B), chol(c_C), ...
    chol(c_transit), chol(c_decay), chol(c_epsilon), chol(c_lambda)));


end
