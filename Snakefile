
configfile: "config.yaml"

rule all:
    input:
        "plots/quals.png"

rule bwa:
    input:
        fa="data/genome.fa",
        fastq="data/samples/{sample}.fastq",
    output:
        "mapped/{sample}.bam"
    conda:
        "envs/mapping.yaml"
    shell:
        "bwa mem {input.fa} {input.fastq} | samtools view -Sb - > {output}"

rule sort:
    input:
        "mapped/{sample}.bam"
    output:
        "mapped/{sample}.sorted.bam"
    conda:
        "envs/mapping.yaml"
    shell:
        "samtools sort {input} -o {output}"

rule call:
    input:
        bams=expand("mapped/{sample}.sorted.bam", sample=config["samples"]),
        fa="data/genome.fa"
    output:
        "called/all.vcf"
    conda:
        "envs/calling.yaml"
    shell:
        "samtools mpileup -g -f {input.fa} {input.bams} | "
        "bcftools call -mv - > {output}"

rule stats:
    input:
        vcf="called/all.vcf"
    output:
        report("plots/quals.png", caption="report/stats.rst")
    conda:
        "envs/plotting.yaml"
    script:
        "scripts/plot-quals.py"
