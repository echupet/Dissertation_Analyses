%% This script computes various kmeans cluster selection metrics.

%% 1. Update these parameters

tic

% Path to cap matlab scripts
cd '/Users/elenapeterson/Desktop/CAP_Tools/CAP_mods/SmallData/';

% Path to txt data files
datapath = '/Users/elenapeterson/Desktop/CAP_Tools/CAP_mods/SmallData/';

% This is the k which has been previously selected as optimal number of
% clusters
k = 6;

%% 2. Loading the data files

files = dir([datapath '*.txt']);
files = {files.name};
Xon = {};

% Data: cell array, each cell of size n_TP x n_masked_voxels
for i = 1:length(files)
    f = load([datapath, files{i}])'; %added apostrophe
    Xon{i} = f;
end


%% 2. Prep for K means

% for testing:
%X = randn(18,4); % total vols by ROIs
%n_subs = 3;
%k=3;

DistType = 'sqeuclidean';

% convert to matrix & rotate
X = (cell2mat(Xon))';

% save total length of sequence (all volumes)
IDX_length = size(X,1);

%% 3. K means Clustering

disp('Starting Clustering:')
toc

% consider other start options
[IDX,C,sumd,D]=kmeans(X,k,'Distance','sqeuclidean','Display','final','Replicates',100,'maxiter',1000,'Start','uniform');          

% IDX  = vector with categorized states for all subs (concatenized, nsub x nvol)
%  C   = for each brain state, average activity at each ROI (6x347)
% sumd = within-cluster sums of point-to-centroid distances in the k-by-1 vector sumd.
%  D   = distances from each point to every centroid in the n-by-k matrix D.
%% 3. Save k selection metrics

% get date to add to file names
today_str = string(datetime("today", "Format", "MM-dd-yy"));

s_name = strcat('Output/CAP_final_output_', today_str, '.mat');
save(s_name, 'IDX', 'C', 'sumd', 'D');

disp('Done with kmeans!');
toc
