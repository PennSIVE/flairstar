#!/bin/bash

# for example
for subj in $(ls /cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all | grep ^sub)
do
    qsub -b y -cwd -l h_vmem=12G -l short -o flairstar.\$JOB_ID.out -e flairstar.\$JOB_ID.err singularity run \
    -B /cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all/${subj}/ses-001/anat/${subj}_ses-001_run-001_T2w.nii.gz:/flair.nii.gz:ro \
    -B /cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all/${subj}/ses-001/anat/${subj}_ses-001_run-001_T2star1.nii.gz:/epi.nii.gz:ro \
    -B /cbica/projects/UVMdata/bids/datasets/2020-06-07/Nifti_all/${subj}/ses-001/anat:/out \
    /cbica/home/robertft/singularity_images/flairstar_latest.sif --out ${subj}_ses-001_run-001_FLAIRstar.nii.gz
done