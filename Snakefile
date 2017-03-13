"""Do a binned count of reads within genes.

This is to ensure that the length of genes do not affect the results of the
analysis of Lene Christine Olsen's paper.
"""

__author__ = "Endre Bakken Stovner https://github.com/endrebak/"
__license__ = "MIT"

from os.path import expanduser

import pandas as pd
import numpy as np

from os import environ
from sys import platform

from snakemake import shell
from snakemake.utils import R

shell.executable('bash')

# raise keyerror if not within tmux session (if you are using linux and not on travis ci)
if not environ.get("TMUX", "") and platform in ["linux", "linux2"]:
    raise Exception("Not using TMUX!")

def bam_to_dict(fname):

    sample_to_fname = {}
    for f in open(fname):
        bam_file = f.strip()
        sample_number = f.split("Sample_")[1].split("_")[0]
        sample_to_fname[sample_number] = bam_file

    return sample_to_fname

sample_filename_dict = bam_to_dict("filenames.txt")

endre_name_to_lene_name = {"ECIIvsD": "IIvsD", "MECvsLEC": "MedvsLat", "OvsY": "YvsO"}


includes = ["bins/annotation",
            "featurecounts/featurecounts",
            "limma/create_targets_file",
            "limma/limma",
            "simes/simes",
            "venn/venn",
            "prepare_lene_data/replace_with_ensembl"]


for path in includes:
    include: "rules/" + path + ".rules"

rule all:
    input:
        "data/venn/contrasts.pdf",
        # "data/download/gencode.gtf",
        # "data/bam/51.bam.bai",
        # "data/featurecounts/matrix.txt",
        "data/limma/ebayes.RDS",
        expand("data/prepare_lene_data/{contrast}.csv", contrast="ECIIvsD OvsY MECvsLEC".split()),
        expand("data/prepare_lene_data/{contrast}_low_logFC_removed.csv", contrast="ECIIvsD OvsY MECvsLEC".split()),
        expand("data/venn/{contrast}_lene_and_simes_overlap.pdf", contrast="ECIIvsD OvsY MECvsLEC".split()),

        # "data/prepare_lene_data/{contrast}_low_logFC_removed.csv"
        expand("data/simes/{contrast}.csv", contrast="ECIIvsD OvsY MECvsLEC MP02 MP09 MP23 MP45 LP02 LP09 LP23 LP45 IIP02 IIP09 IIP23 IIP45 DP02 DP09 DP23 DP45".split())

        # def bam_to_dict(fname):

        #     sample_to_fname = {}
        #     for f in open(fname):
        #         bam_file = f.strip()
        #         sample_number = f.split("Sample_")[1].split("_")[0]
        #         sample_to_fname[sample_number] = bam_file

        #     return sample_to_fname
