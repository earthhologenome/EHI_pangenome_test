# EHI pangenome test
This is a comparison between traditional MAG dereplication and pangenome generation relying on dRep clusters. The number of genomes and final annotations are compared using multiple clusters from dereplication and mapping batch DMB0162 belonging to Mediterranean lizards.

## Versions

- **Original:** default bifrost and ggcaller options.
- **v2:** ggcaller changes: ```--max-path-length 50000 --max-ORF-overlap 100 --min-path-score 80 --min-orf-score 80```
- **v3:** bifrost change: ```-k 19```
- **v4:** default pggb options.

## Dependencies

- slurm
- miniconda
- dnakemake
- bifrost
- ggcaller
- bbmap
- pggb
- odgi
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

## Stats extraction

Length is estimated by Bandage from the pangenome graph.

Gene sequence length calculation

```{sh}
cat pangenomes/{pangenome}/{pangenome}.faa | grep -v ">" | tr -d '\n' | wc -c | awk '{print $1 * 3}'
```

Core and auxiliary genomes

```{sh}
cat pangenomes/{pangenome}/ggcaller/summary_statistics.txt
```

## Clusters

### cluster35

#### Genomes

| MAG | Selection | Completeness | Contamination | Length | Genes | Annotated |
| --- | --- | --- | --- | --- | --- | --- |
| EHA02915_bin.85.fa.gz | * | 95.48 | 0.60 | 1.33 | 1515 | 983 |
| EHA00564_bin.1.fa.gz  |   | 82.69 | 1.14 | 1.48 | 1440 | 935 |

#### Pangenome (default ggcaller options)

- **Estimated length:** 1.67 Mb
- **Cumulative gene length**: 0.60 Mb
- **Estimated coding density**: 36%
- **Number of genes:** 737
  - **Core**: 725
  - **Auxiliary**: 11
- **Number of annotated genes:** 493
  
#### Pangenome v3 (reduced kmer-size: k19)

- **Estimated length:** 1.67 Mb
- **Cumulative gene length**:  Mb
- **Estimated coding density**: 60%
- **Number of genes:** 1271
  - **Core**: 1252
  - **Auxiliary**: 18
- **Number of annotated genes:** 826

### cluster38
| MAG | Selection | Completeness | Contamination | Length | Genes | Annotated |
| --- | --- | --- | --- | --- | --- | --- |
| EHA00679_bin.17.fa.gz |   | 99.10 | 1.43 | 3.02 | 1479 | 1152 |
| EHA00645_bin.14.fa.gz |   | 98.66 | 0.00 | 1.84 | 1486 | 1148 |
| EHA00717_bin.5.fa.gz  |   | 99.10 | 1.34 | 2.99 | 1488 | 1149 |
| EHA00724_bin.10.fa.gz |   | 77.08 | 1.00 | 0.69 | 1515 | 1150 |
| EHA03586_bin.4.fa.gz  |   | 95.65 | 0.20 | 1.7 | 1535 | 1155 |
| EHA03447_bin.18.fa.gz | * | 100.00 | 0.08 | 2.45 | 1311 | 966 |

#### Pangenome (default ggcaller options)

- **Estimated length:** 1.84 Mb
- **Cumulative gene length**: 1.40 Mb
- **Estimated coding density**: 76%
- **Number of genes:** 1661
  - **Core**: 1359
  - **Auxiliary**: 302 

#### Pangenome v3 (reduced kmer-size: k19)

- **Estimated length:** 1.80 Mb
- **Cumulative gene length**: 1.41 Mb
- **Estimated coding density**: 78%
- **Number of genes:** 1704
  - **Core**: 1381
  - **Auxiliary**: 324  
- **Number of annotated genes:** 1187


### cluster43
- EHA03755_bin.377.fa.gz
- EHA03694_bin.654.fa.gz
- EHA03584_bin.13.fa.gz *selected
- EHA03452_bin.1.fa.gz
