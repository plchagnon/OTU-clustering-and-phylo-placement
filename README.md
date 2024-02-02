# OTU-evolutionary-placement

Taxonomy assignment for AM fungi remains a conundrum. In another pipeline, we have developed a way to take a list of amplicon sequence variants (ASVs), and assign them a taxonomy based on a set of reference sequences published by [Krüger et al. 2012](https://doi.org/10.1111/j.1469-8137.2011.03962.x). This approach uses an evolutionary placement algorithm to insert these ASVs into a solid phylogenetic backbone (i.e., a good tree with long, high-quality reference sequences belonging to reference cultures). This has obviously merit, but suffers from some drawbacks:

- Because these reference sequences have been rarely used for taxonomy assignment, we know relatively little about the ecology of many species found in this reference sequences set;
- Because these references sequences belong to reference cultures, it neglects any (potentially significant) part of the mycorrhizal diversity that is unlikely to be brought into culture [Öpik et al. 2014](https://doi.org/10.1139/cjb-2013-0110);
- Because the pipeline is meant to place very short sequences (typically Illumina MiSeq-derived ASVs), more often than anything the placement won't go to the species level. This leads to a strong asymmetry in the treatment of sequences ascribed to species and those ascribed only to higher levels: if we lump ASVs belonging to the same species, while we keep poorly assigned ASVs separated, this can distort in a severe manner the relative abundances of our taxa. If we keep all ASVs separated, then it suggests that a single nucleotide difference in a gene not expected to be under natural selection is of significant ecological importance...


To address these limitations, we propose an alternative strategy to assign taxonomy:

1. Cluster ASVs into OTUs
2. Build a reference set of sequences including Krüger et al.'s 2012 sequences, the representative VTX sequences of MaarjAM and some outgroups (to facilitate detection of OTUs that may not belong to Glomeromycota/Glomeromycotina) and assemble them into a reference phylogeny
3. Insert OTUs into this phylogeny and infer their taxonomy this way