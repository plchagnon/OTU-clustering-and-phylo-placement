rm(list=ls())
library(seqinr)
x=read.fasta("epa/merged.aligned.fasta")

cent=x[grepl("cluster",names(x))]
ref=x[!names(x)%in%names(cent)]

write.fasta(cent,names=names(cent),file.out="epa/centroids.glob.aligned.fasta")
write.fasta(ref,names=names(ref),file.out="epa/refs.glob.aligned.fasta")
