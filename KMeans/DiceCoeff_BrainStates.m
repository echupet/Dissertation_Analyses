% Compute spatial overlap between brain states & Yeo network maps

cd /Users/elenapeterson/Desktop/Dissertation/Data/CAP_output/;

datapath = '/Users/elenapeterson/Desktop/Dissertation/Data/CAP_output/';
% read in brain state

bs_list = dir([datapath '*norm.nii.gz']);
bs_list = {bs_list.name};

yeo_list = dir([datapath 'Yeo_Networks/*.nii.gz']);
yeo_list = {yeo_list.name};

% brain states, yeo states, 1
dice_sims = zeros(length(bs_list), length(yeo_list), 1);

for b = 1:length(bs_list)
    % read in each brain state
    bs_list{b}
    bs = niftiread(bs_list{b});

    % convert to logical matrix
    bslog = bs>1;%activation greater than 1sd
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
s_name = strcat('dice_sims_', today_str, '.mat');
save(s_name, 'dice_sims');

