% Compute spatial overlap between brain states & Yeo network maps

%% 1. Update these parameters

% path to KMeans folder
cd /Users/elenapeterson/Desktop/Dissertation/Data/CAP_States/;

% path to nifti files of CAP states
CAPpath = '/Users/elenapeterson/Desktop/Dissertation/Data/CAP_States/';

% path to nifti files of Yeo Network maps
Yeopath = '/Users/elenapeterson/Desktop/Dynamic_EF/Data/CAP_States/Yeo_Networks/';

% name to distinguish this run
tag = 'test1_';

% threshold of activation to use, in SD if states are normalized
thresh = 1;

%%
% read in brain state

bs_list = dir([CAPpath '*norm.nii.gz']);
bs_list = {bs_list.name};

yeo_list = dir([Yeopath '*.nii.gz']);
yeo_list = {yeo_list.name};

dice_sims = zeros(length(bs_list), length(yeo_list), 1);

for b = 1:length(bs_list)
    % read in each brain state
    bs_list{b}
    bs = niftiread(bs_list{b});

    % convert to logical matrix
    bslog = bs > thresh;
    min(bslog, [], "all")
    max(bslog, [], "all")

    % read in Yeo maps for comparison (already binarized)
    for y = 1:length(yeo_list)
        yeo_list{y}
        yeo = niftiread(['Yeo_Networks/' yeo_list{y}]);
        yeolog = logical(yeo);
        % compute similarity
        sim = dice(bslog, yeolog);
        dice_sims(b,y) = sim;
        disp(['State ', num2str(b) ' vs ' yeo_list{y} ': ' num2str(sim)])
    end
    
end

% get date to add to file names
today_str = string(datetime("now", "Format", "MM.dd.yy.HH.mm"));

% save similarity measures
s_name = strcat(tag, today_str, '.mat');
save(s_name, 'dice_sims');

