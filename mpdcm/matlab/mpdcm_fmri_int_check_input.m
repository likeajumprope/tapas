function [y] = mpdcm_fmri_int_check_input(u, theta, ptheta)
%%
% sloppy -- Don't check the input
% tflag -- Test flag, this is done
%
% aponteeduardo@gmail.com
% copyright (C) 2014
%

check_u(u)
check_theta(theta)
check_ptheta(ptheta)

su = size(u);
st = size(theta);

assert(su(1) == st(1), ...
    'mpdcm:fmri:int:input:dmatch', ...
    'Dimensions of u and theta doesn''t match')

su = size(u{1});
du = theta{1}.dim_u;
assert(su(1) == du, ...
    'mpdcm:fmri:int:input:theta:dim_u:match_u', ...
    'theta.dim_u doesn''t match u.');
end

function check_u(u)
%% Throws an error if something is wrong with theta

assert(iscell(u), ...
    'mpdcm:fmri:int:input:u:not_cell', ...
    'u should be a cell array')

assert(ndims(u) == 2, ...
    'mpdcm:fmri:int:input:u:ndim', ...
    'u should be two dimensional, number of dimensions is %d', ndims(u))

su = size(u);

assert(su(2) == 1, ...
    'mpdcm:fmri:int:input:u:dsize', ...
    'Second dimension of u should have size 1, size is %d', su(2))

for i = 1:numel(u)
    assert(isnumeric(u{i}), ...
        'mpdcm:fmri:int:input:u:cell:not_numeric', ...
        'u{%d} should be numeric.', i);
    assert(ndims(u{i}) == 2, ...
        'mpdcm:fmri:int:input:u:cell:not_real', ...
        'u{%d} should be two dimensional.', i);
    assert(isreal(u{i}), ...
        'mpdcm:fmri:int:input:u:cell:not_real', ...
        'u{%d} should be real.', i);
    assert(~issparse(u{i}), ...
        'mpdcm:fmri:int:input:u:cell:sparse', ...
        'u{%d} should not be sparse', i);

    if i == 1
        os = size(u{i});
    end

    assert(all(os == size(u{i})), ...
        'mpdcm:fmri:int:input:u:cell:not_match', ...
        'All cells of u should have the same dimensions');
    os = size(u{i});
end

end

function check_matrix(theta, ns, field, element)
%% Checks a matrix in theta.
% theta is a cell array
% ns is the expected size of the matrix
% fields is string with the respetive field
% Element is the index

    assert(isfield(theta{element}, field), ...
        sprintf('mpdcm:fmri:int:input:theta:cell:%s:missing', field), ...
        'Element theta{%d} doesn''t have field %s', element, field);
    m = getfield(theta{element}, field);
    assert(isnumeric(m), ...
        sprintf('mpdcm:fmri:int:input:theta:cell:%s:not_numeric', field), ...
        'theta{%d}.%s should be numeric', element, field);
    assert(isreal(m), ...
        sprintf('mpdcm:fmri:int:input:theta:cell:%s:not_real', field), ...
        'theta{%d}.%s should be real', element, field);
    assert(~issparse(m), ...
        sprintf('mpdcm:fmri:int:input:theta:cell:%s:sparse', field), ...
        'theta{%d}.%s should not be sparse', element, field);
    assert(ndims(m) == 2, ...
        sprintf('mpdcm:fmri:int:input:theta:cell:%s:ndim', field), ...
        'theta{%d}.%s should have 2 dimensions', ...
        element, field)
    assert(all(size(m) == ns), ...
        sprintf('mpdcm:fmri:int:input:theta:cell:%s:dsize', field), ...
        'theta{%d}.%s should have dimensions [%d,%d], instead [%d,%d].', ...
        element, field, ns(1), ns(2), size(m, 1), size(m, 2));
end


function check_theta(theta)
%% Throws an error if something is wrong with theta

assert(iscell(theta), ...
    'mpdcm:fmri:int:input:theta:not_cell', ...
    'theta should be a cell array')
assert(ndims(theta) == 2, ...
    'mpdcm:fmri:int:input:theta:ndim', ...
    'theta should be two dimensional, number of dimensions is %d', ...
    ndims(theta))

for i = 1:numel(theta)

    assert(isstruct(theta{i}), ...
        'mpdcm:fmri:int:input:theta:cell:not_struct', ...
        'theta{%d} is not struct', i)

    assert(isscalar(theta{i}), ...
        'mpdcm:fmri:int:input:theta:cell:ndim', ...
        'theta{%d} is not struct', i)

    check_matrix(theta, [1, 1], 'dim_x', i);
    check_matrix(theta, [1, 1], 'dim_u', i);

    if i == 1
        dx = theta{i}.dim_x;
        du = theta{i}.dim_u;
    end

    assert(dx == theta{i}.dim_x, ...
        'mpdcm:fmri:int:input:theta:cell:dim_x:not_match', ...
        'theta{%d}.dim_x doesn''t match previous values');

    assert(du == theta{i}.dim_u, ...
        'mpdcm:fmri:int:input:theta:cell:dim_u:not_match', ...
        'theta{%d}.dim_u doesn''t match previous values');

    check_matrix(theta, [1, 1], 'fA', i);
    check_matrix(theta, [1, 1], 'fB', i);
    check_matrix(theta, [1, 1], 'fC', i);

    check_matrix(theta, [dx, dx], 'A', i);

    assert(isfield(theta{i}, 'B'), ...
        'mpdcm:fmri:int:input:theta:cell:B:missing', ...
        'Element %d should have field B', i);
    B = getfield(theta{i}, 'B');
    assert(iscell(B), ...
        'mpdcm:fmri:int:input:theta:cell:B:not_cell', ...
        'theta{%d}.B should be a cell array', i);

    assert(numel(B) == du, ...
        'mpdcm:fmri:int:input:theta:cell:B:ndim', ...
        'theta{%d}.B should have %d cells, instead %d', du, numel(B));
    for j = 1:numel(B)
        m = B{j};
        assert(isnumeric(m), ...
            'mpdcm:fmri:int:input:theta:cell:B:cell:not_numeric', ...
            'theta{%d}.B{%d} should be numeric', i, j)
        assert(isreal(m), ...
            'mpdcm:fmri:int:input:theta:cell:B:cell:not_real', ...
            'theta{%d}.B{%d} should be real', i, j)
        assert(~issparse(m), ...
            'mpdcm:fmri:int:input:theta:cell:B:cell:sparse', ... 
            'theta{%d}.B{%d} must not be issparse', i, j)
        assert(ndims(m) == 2, ...
            'mpdcm:fmri:int:input:theta:cell:B:cell:ndim', ...         
            'theta{%d}.B{%d} should be two dimensonal', i, j)
        assert(all(size(m) == [dx, dx]), ...
            'mpdcm:fmri:int:input:theta:cell:B:cell:dsize', ...         
            'theta{%d}.B{%d} wrond dimensonality', i, j);
    end

    check_matrix(theta, [dx, du], 'C', i);
    check_matrix(theta, [dx, 1], 'K', i);
    check_matrix(theta, [dx, 1], 'tau', i);

    check_matrix(theta, [1, 1], 'V0', i);
    check_matrix(theta, [1, 1], 'E0', i);
    check_matrix(theta, [1, 1], 'k1', i);
    check_matrix(theta, [1, 1], 'k2', i);
    check_matrix(theta, [1, 1], 'k3', i);
    check_matrix(theta, [1, 1], 'alpha', i);
    check_matrix(theta, [1, 1], 'gamma', i);

end
end

function check_ptheta_scalar(ptheta, field)
%% Checks for scalar values in ptheta

assert(isfield(ptheta, field), ...
    sprintf('mpdcm:fmri:int:input:ptheta:%s:missing', field), ...
    'ptheta should have field %s', field);

ascalar = getfield(ptheta, field);

assert(isscalar(ascalar), ...
    sprintf('mpdcm:fmri:int:input:ptheta:%s:not_scalar', field), ...
    'ptheta.%s should be scalar', field);

assert(isnumeric(ascalar), ...
    sprintf('mpdcm:fmri:int:input:ptheta:%s:not_numeric', field), ...
    'ptheta.%s should be numeric', field);
assert(isreal(ascalar), ...
    sprintf('mpdcm:fmri:int:input:ptheta:%s:not_real', field), ...
    'ptheta.%s should be real', field);
assert(~issparse(ascalar), ...
    sprintf('mpdcm:fmri:int:input:theta:cell:%s:sparse', field), ...
    'ptheta.%s should not be sparse', field);

end

function check_ptheta(ptheta)
%% Throws an error if something is wrong with ptheta

assert(isstruct(ptheta), ...
    'mpdcm:fmri:int:input:ptheta:not_struct', ...         
    'ptheta should be a struct')

check_ptheta_scalar(ptheta, 'dt');

dt = getfield(ptheta, 'dt');

assert(0 < dt && dt <= 1, ...
    sprintf('mpdcm:fmri:int:input:theta:cell:%s:val', 'dt'), ...
    'ptheta.%s should not be < 0 and > 1', 'dt');

check_ptheta_scalar(ptheta, 'dyu');
dyu = getfield(ptheta, 'dyu');

assert(0 < dyu && dyu <= 1, ...
    sprintf('mpdcm:fmri:int:input:theta:cell:%s:val', 'dyu'), ...
    'ptheta.%s should not be < 0 and > 1', 'dyu');

end

