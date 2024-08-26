#! /bin/bash -login
#SBATCH -J ABC_Pipeline
#SBATCH -t 2-00:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -p norm
#SBATCH --mem=2gb
#SBATCH -o "%x-%j.out"

## Exit if any command fails
set -e

## Source conda/mamba
source /data/$USER/conda/etc/profile.d/conda.sh && source /data/$USER/conda/etc/profile.d/mamba.sh

## Activate the already configurd ABC environment
conda activate abc-env

## Make directory for slurm logs
mkdir -p results/logs_slurm

## Execute snakemake workflow
snakemake -j 100 --max-jobs-per-second 5 --max-status-checks-per-second 5 --rerun-incomplete --restart-times 3 -p -s workflow/Snakefile --latency-wait 500 --cluster-config "config/cluster.yaml" --cluster "sbatch -J {cluster.name} -p {cluster.partition} -t {cluster.time} -c {cluster.cpusPerTask} -N {cluster.nodes} --output {cluster.output} --error {cluster.error} --parsable" --cluster-status ./workflow/scripts/status.py

## Success message
echo "Entire workflow completed successfully!"
