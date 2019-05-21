import matplotlib
import matplotlib.pyplot as plt
from pysam import VariantFile
matplotlib.use("Agg")


quals = [record.qual for record in VariantFile(snakemake.input.vcf)]

plt.hist(quals)

plt.savefig(snakemake.output[0])
