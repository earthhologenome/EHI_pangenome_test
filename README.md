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
snakemake -j 20 --cluster 'sbatch -o logs/{rule}.{wildcards.pangenome}-%j.out --mem {resources.mem_gb}G --time {resources.time} -c {threads} --job-name={rule}.{wildcards.pangenome} -v' --use-conda --conda-frontend mamba --conda-prefix conda --latency-wait 600 --keep-going --keep-incomplete
```

## Clusters

### cluster35

#### Genomes

| MAG | Selection | Completeness | Contamination | Length | Genes | Annotated |
| --- | --- | --- | --- | --- | --- | --- |
| EHA02915_bin.85.fa.gz | * | 95.48 | 0.60 | 1.33 | 1515 | 983 |
| EHA00564_bin.1.fa.gz  |   | 82.69 | 1.14 | 1.48 | 1440 | 935 |

#### Pangenome

- **Estimated length:** 1.67 Mb
- **Cumulative gene length**: 0.60 Mb
- **Estimated coding density**: 36%
- **Number of genes:** 737
  - **Core**: 725
  - **Auxiliary**: 11 

### cluster38
| MAG | Selection | Completeness | Contamination | Length | Genes | Annotated |
| --- | --- | --- | --- | --- | --- | --- |
| EHA00679_bin.17.fa.gz |   |  |  |  |  |  |
| EHA00645_bin.14.fa.gz |   |  |  |  |  |  |
| EHA00717_bin.5.fa.gz  |   |  |  |  |  |  |
| EHA00724_bin.10.fa.gz |   |  |  |  |  |  |
| EHA03586_bin.4.fa.gz  |   |  |  |  |  |  |
| EHA03447_bin.18.fa.gz | * |  |  |  |  |  |

#### Pangenome

- **Estimated length:** 1.84 Mb
- **Cumulative gene length**: 1.40 Mb
- **Estimated coding density**: 76%
- **Number of genes:** 1661
  - **Core**: 1359
  - **Auxiliary**: 302 

### cluster43
- EHA03755_bin.377.fa.gz
- EHA03694_bin.654.fa.gz
- EHA03584_bin.13.fa.gz *selected
- EHA03452_bin.1.fa.gz
