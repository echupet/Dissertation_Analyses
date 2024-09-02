%% Reconstruct States (C) back into 3D volume
% Single_template=load_untouch_nii('/path/to/MNI/brain/MNI_2mm_brain.nii'); %arbitary template file (non binary)

% need to have C loaded in environment (brain states)

Single_template=load_untouch_nii('/Users/elenapeterson/Desktop/CAP_Tools/Old_CAP_analysis/ROIs/New_Map/Good2/Parcels_MNI_222_subcortical.nii'); %roi template file (non binary)
Single_template.img=Single_template.img*0; % zeros at all voxels

% Data_mask=load_untouch_nii('/path/to/MNI/mask/MNI_2mm_GM_Mask.nii');

Data_mask=load_untouch_nii('/Users/elenapeterson/Desktop/CAP_Tools/Old_CAP_analysis/ROIs/New_Map/Good2/Parcels_MNI_222_subcortical.nii');
% vox_location=find(Data_mask.img>0); %relevant voxels
% EP: above line not totally necessary bc non-ROI voxels will not have ROI code
% of 1-130
%but it may save a little time in the length(vox_location) loop 

vox_location=find(Data_mask.img<400); %relevant voxels

    
%%
% set cluster number range
for i=1:8

% this reconstructs state i into a nii image

for j=1:length(vox_location)
    for k=1:347 %number of ROIs
        if Data_mask.img(j)==k
            Single_template.img(j)=C(i,k); %double-check number of ROIs
        end
    end
end

%%

    %Save

    Name=(['CAP_reshape_cluster',num2str(i),'.nii']);
    save_untouch_nii(Single_template,Name);
    
end
%%
disp('Done with creating brain state niftis!');
toc
