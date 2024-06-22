# EHI pangenome test
This is a comparison between traditional MAG dereplication and pangenome generation relying on dRep clusters. The number of genomes and final annotations are compared using multiple clusters from dereplication and mapping batch DMB0162 belonging to Mediterranean lizards.

## Dependencies

- slurm
- miniconda
- dnakemake
- bifrost
- ggcaller
- bbmap
- dram

## Pipeline

Clone the repository.

```{sh}
git clone https://github.com/earthhologenome/EHI_pangenome_test.git
```

Create a screen session to run the snakemake pipeline and enter into the working directory

```{sh}
screen -S EHI_pangenome_test
cd EHI_pangenome_test
```

Load required modules to launch the pipeline if needed (common in HPC servers)

```{sh}
module purge && module load snakemake/7.20.0 mamba/1.3.1
```

Launch the snakemake pipeline.

```{sh}
snakemake -j 20 --cluster 'sbatch -o logs/{rule}.{wildcards.pangenome}-%j.out --mem {resources.mem_gb}G --time {resources.time} -c {threads} --job-name={rule}.{wildcards.pangenome} -v'   --use-conda --conda-frontend mamba --conda-prefix conda --latency-wait 600
```
