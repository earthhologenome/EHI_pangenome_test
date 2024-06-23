######
# Experimental pangenome pipeline
# Antton alberdi
# 2024/06/22
# Description: the pipeline creates, annotates and analyses pangenomes.
#
# 1) Create pangenome input files and store them in the input folder
# 2) Launch the snakemake using the following code:
# module purge && module load snakemake/7.20.0 mamba/1.3.1
# snakemake -j 20 --cluster 'sbatch -o logs/{rule}.{wildcards.pangenome}-%j.out --mem {resources.mem_gb}G --time {resources.time} -c {threads} --job-name={rule}.{wildcards.pangenome} -v' --use-conda --conda-frontend mamba --conda-prefix conda --latency-wait 600 --keep-going --keep-incomplete
#
######

#List sample wildcards
pangenomes, = glob_wildcards("input/{pangenome}.txt")

#Target files
rule all:
	input:
		expand("pangenomes/{pangenome}/{pangenome}.gfa", pangenome=pangenomes),
		expand("pangenomes/{pangenome}/{pangenome}.faa", pangenome=pangenomes),
		expand("pangenomes/{pangenome}/dram/annotations.tsv", pangenome=pangenomes)

rule bifrost:
	input:
		"input/{pangenome}.txt"
	output:
		gfa="pangenomes/{pangenome}/{pangenome}.gfa",
		bfg="pangenomes/{pangenome}/{pangenome}.gfa.color.bfg"
	threads:
		1
	resources:
		mem_gb=8,
		time='00:05:00'
	shell:
		"""
		module load bifrost/1.3.5
		Bifrost build -r {input} -o {output.gfa} -t {threads} -c -n
		"""

rule ggcaller:
	input:
		gfa="pangenomes/{pangenome}/{pangenome}.gfa",
		bfg="pangenomes/{pangenome}/{pangenome}.gfa.color.bfg"
	output:
		seq="pangenomes/{pangenome}/ggcaller/pangenome_reference.fa",
		tsv="pangenomes/{pangenome}/ggcaller/gene_presence_absence.Rtab"
	threads:
		8
	params:
		outdir="pangenomes/{pangenome}/ggcaller"
	resources:
		mem_gb=32,
		time='01:00:00'
	shell:
		"""
		set +eu
		source activate /home/jpl786/.conda/envs/ggc_env
		ggcaller --graph {input.gfa} --colours {input.bfg} --out {params.outdir} --threads {threads}
		source deactivate /home/jpl786/.conda/envs/ggc_env
		set -eu
		"""

rule translation:
	input:
		seq="pangenomes/{pangenome}/ggcaller/pangenome_reference.fa",
		tsv="pangenomes/{pangenome}/ggcaller/gene_presence_absence.Rtab"
	output:
		seq="pangenomes/{pangenome}/{pangenome}.faa",
		tsv="pangenomes/{pangenome}/{pangenome}.tsv"
	threads:
		1
	resources:
		mem_gb=8,
		time='00:05:00'
	shell:
		"""
		module load bbmap/39.01
		translate6frames.sh in={input.seq} out={output.seq} aain=f aaout=t frames=1 tag=f
		mv {input.tsv} {output.tsv}
		"""

rule dram:
	input:
		"pangenomes/{pangenome}/{pangenome}.faa"
	output:
		"pangenomes/{pangenome}/dram/annotations.tsv"
	threads:
		8
	params:
		outdir="pangenomes/{pangenome}/dram"
	resources:
		mem_gb=32,
		time='10:00:00'
	shell:
		"""
		set +eu
		source activate /projects/mjolnir1/people/ncl550/0_software/miniconda3/envs/DRAM_more_modules
		rm -rf {params.outdir}
		DRAM.py annotate_genes -i {input} -o {params.outdir} --threads {threads} --use_uniref
		source deactivate /projects/mjolnir1/people/ncl550/0_software/miniconda3/envs/DRAM_more_modules
		set -eu
		"""
