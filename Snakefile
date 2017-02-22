"""Do a binned count of reads within genes.

This is to ensure that the length of genes do not affect the results of the
analysis of Lene Christine Olsen's paper.
"""

__author__ = "Endre Bakken Stovner https://github.com/endrebak/"
__license__ = "MIT"

from os.path import expanduser

import pandas as pd
import numpy as np


def bam_to_dict(fname):

    sample_to_fname = {}
    for f in open(fname):
        bam_file = f.strip()
        sample_number = f.split("Sample_")[1].split("_")[0]
        sample_to_fname[sample_number] = bam_file

    return sample_to_fname

sample_filename_dict = bam_to_dict("filenames.txt")

includes = ["download/gencode",
            "bam/prepare"]

for path in includes:
    include: "rules/" + path + ".rules"

rule all:
    input:
        "data/download/gencode.gtf",
        "data/bam/51.bam.bai"