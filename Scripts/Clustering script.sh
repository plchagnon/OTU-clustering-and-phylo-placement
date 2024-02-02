vsearch --cluster_fast ../ASV.fasta --id 0.97 --centroids ../OTUclusters/centroids.fasta --clusterout_id --../OTUclusters/uc uclust.txt

Rscript uclust.R
