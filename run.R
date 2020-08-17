#!/usr/bin/env Rscript
library(argparser)
library(neurobase)
library(ANTsR)
library(extrantsr)

# create a parser
p <- arg_parser("Make a flair star")
# add command line arguments
p <- add_argument(p, "--out", help = "Output filename", default = "tmp.nii.gz")
# parse the command line arguments
argv <- parse_args(p)

# read in FLAIR and EPI nifti images
flair = readnii("/flair.nii.gz")
epi = readnii("/epi.nii.gz")

flair_n4 = bias_correct(file = flair, correction = "N4")
epi_n4 = bias_correct(file = epi, correction = "N4")

# co-register the FLAIR to the EPI
flair_reg2epi = registration(filename = oro2ants(flair_n4), template.file = oro2ants(epi_n4), typeofTransform = "Rigid", interpolator = "welchWindowedSinc")$outfile
# now multiply the epi and registered flair to get the flair*
flairstar = flair_reg2epi * epi_n4
writenii(flairstar, paste0("/out/", argv$out))
