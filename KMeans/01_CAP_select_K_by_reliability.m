%% This script computes various kmeans cluster selection metrics.

% This script will compare similarity of k-means solutions when the
% algorithm is repeated on subsets of the whole sample.

% dependencies: getGammaSimilarity_EP & munkres

% input files: one text file per person, 
% where rows = fMRI volumes & columns = regions of interest

%% 1. Update these parameters

tic

% name to distinguish this run
tag = 'k511_test1_';

% Path to KMeans folder
cd '/Users/elenapeterson/Desktop/Dynamic_EF/Scripts/KMeans/';

% Path to txt data files
datapath = '/Users/elenapeterson/Desktop/Dynamic_EF/Data/CAP_test_data/';

% This specifies the range of values over which to perform k means
K_range = 5:11;

% number of repetitions of k-means algorithms, which will be checked for
% sim
reps = 10;

drop_size = .1; % sample size to drop each iteration as a fraction


%% 2. Loading the data files

files = dir([datapath '*.txt']);
files = {files.name};
Xon = {};

% Data: cell array, each cell of size timepoints x regions
for i = 1:length(files)
    f = load([datapath, files{i}]); % vols x rois
    fnorm = normalize(f); % IMPORTANT - normalize data by columns (rois)
    fnormt = fnorm'; % transpose for k means
    Xon{i} = fnormt;
end


%% 2. Prep for K means

DistType = 'sqeuclidean';

% convert to matrix & rotate
X = (cell2mat(Xon))';

totalvols = size(X,1);

% number volumes to drop each rep
nvols_dropped = round(totalvols*drop_size);

% save total length of sequence (all volumes)
IDX_length = size(X,1);

% get number of subs
%n_subs = length(files);

% initialize matrices for storage
allIDX = zeros(IDX_length, length(K_range), 1);
all_sims_av = [];
all_sims_sd = [];


%% 3. K means Clustering

disp('Starting Clustering:')
toc

   % Loop over all K values to assess
    for n_k = 1:length(K_range)
        
        k = K_range(n_k);
    
        disp(['Starting kmeans for K = ',num2str(k),'...']);
        toc

        % initialize k-specific matrix 
        k_IDX_bin = zeros(IDX_length, k, reps);
        
        % do clustering replications
        for rep = 1:reps

            % drop some percentage of volumes for each repetition
            dropvols = randsample(totalvols, nvols_dropped);
            Xrep = X;
            Xrep(dropvols,:) = NaN;

            % IDX contains the indices for each datapoint
            IDX = kmeans(Xrep,k,'Distance',DistType,'Replicates',10, 'MaxIter',1000);
            
            % save the very first iteration for other tests
            if rep == 1
                all_IDX(:,n_k) = IDX;
            end   
            
            % split IDX into multiple columns, each represents one cluster,
            % ones when that state is present, zeros when absent.
            IDX_bin = zeros(IDX_length, k);
            
            % NaNs (dropped volumes) will become zero
            for this_k = 1:k
                IDX_bin(:,this_k) = IDX == this_k;
            end
            
            % save binary IDX from each repetition
            k_IDX_bin(:, :, rep) = IDX_bin;
            k_IDX_bin(:, :, rep) = IDX_bin;
        end
        
        % initialize similarity vector
        k_sim = []; %unique combos of reps

        for run1 = 1:reps-1
            for run2 = run1+1:reps
                sim = getGammaSimilarity_EP(k_IDX_bin(:,:,run1), k_IDX_bin(:,:,run2));
                k_sim = [k_sim sim];
            end
        end
        
        % get average of nonzero elements
        k_sim_av = mean(k_sim);
        k_sim_sd = std(k_sim);
        
        all_sims_av = [all_sims_av k_sim_av];
        all_sims_sd = [all_sims_sd k_sim_sd];
        
end

%% 3. Save k selection metrics

all_sims_av'
all_sims_sd'

% get date to add to file names
today_str = string(datetime("now", "Format", "MM.dd.yy.HH.mm"));

% save similarity measures
s_name = strcat('Output/k_selection_sims_', tag, today_str, '.mat');
save(s_name, 'all_sims_av', 'all_sims_sd', 'X', 'all_IDX');

disp('Done computing test-retest reliability!');
toc
           
%% Optional: additional ways to evaluate clustering solutions:   

%cal = evalclusters(X,all_IDX,'CalinskiHarabasz')
%dave = evalclusters(X,all_IDX,'DaviesBouldin')
%silo = evalclusters(X,all_IDX,'silhouette')

% save other quality measures
%s_name2 = strcat('Output/k_selection_other_', today_str, '.mat');
%save(s_name2, 'cal', 'dave', 'silo');

%disp('Done computing extra clustering metrics!');
%toc
