%% Reconstruct States back into 3D volumes
% Uses Nifti Tools "Tools for NIfTI and ANALYZE image"
%% Update these parameters

% load output .mat file from KMeans
load('/Users/elenapeterson/Desktop/Dynamic_EF/Data/CAP_States/CAP_final_output_k8_03-19-24.mat');   
% output file contains C, which is matrix
% where rows = k, columns = ROIs, values = average activation at an ROI for a
% given brain state k

% Load nifti map of ROIs, where value = numeric ID for that ROI
Data_mask=load_untouch_nii('/Users/elenapeterson/Desktop/Dynamic_EF/Data/CAP_States/Parcels_MNI_222_subcortical.nii');

% number of ROIs
num_ROIs = 347;

% number of ROIs
num_states = 8;

%% Prep for loading images
% Make a blank template for brain images
Single_template=Data_mask;
Single_template.img=Single_template.img*0; % zeros at all voxels

vox_location=find(Data_mask.img<1000); %this gives total number of voxels

    
%%
% set cluster number range
for state=1:num_states
    disp(['Creating image for State = ',num2str(state),'...']);

% this reconstructs state i into a nii image:

    for vox=1:length(vox_location)
        for roi=1:num_ROIs
            if Data_mask.img(vox)==roi
                Single_template.img(vox)=C(state,roi); %double-check number of ROIs
            end
        end
    end

%%

    %Save

    Name=(['Output/CAP_cluster',num2str(state),'.nii']);
    save_untouch_nii(Single_template,Name);
    
end
%%
disp('Done with creating brain state niftis!');

