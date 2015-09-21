function varargout = normnd(data,varargin)
% NORMND computes the vector normal to points in an N-D point cloud
%
%   NORMND(DATA) computes the vector normal to the N-dimensional sample
%   point locations in DATA. DATA is defined as an MxN matrix where M is
%   the number of samples. Each column contains the sample locations in
%   each of the orthogonal dimensions in N-dimensional space 
%
%   Example:
%       % Compute the normal vector to 3-D sample points
%       data = randn(20,3);
%       % Bias the normal vector toward the Z-axis
%       data(:,3) = data(:,3)./10;
%       v = normnd(data);
%       % Plot
%       figure; scatter3(data(:,1),data(:,2),data(:,3));
%       hold on; quiver3(mean(data(:,1)),mean(data(:,2)),mean(data(:,3)),v(1),v(2),v(3))
%
%   See also: cov, eig.
%

%
%   Jered R Wells
%   2013/05/02
%   jered [dot] wells [at] gmail [dot] com
%
%   v1.0
%
%   UPDATES
%       YYYY/MM/DD - jrw - v1.1
%
%

%% INPUT CHECK
narginchk(1,1);
nargoutchk(0,1);
fname = 'norm3d';

% Checked required inputs
validateattributes(data,{'single','double'},{},fname,'DATA',1);

%% PROCESS
% Center the input indicies (center of mass computation)
data = data - repmat(mean(data,1),size(data,1),1);
% Compute the MxM covariance matrix A
A = cov(data);
% Compute the eigenvector of A
[V, LAMBDA] = eig(A);
% Find the eigenvector corresponding to the minimum eigenvalue in A
% This should always be the first column, but check just in case
[~,idx] = min(diag(LAMBDA));
% Normalize
V = V(:,idx) ./ norm(V(:,idx));

% Assemble the VARARGOUT cell array
varargout = {V};

end % MAIN