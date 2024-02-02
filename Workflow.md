# 1. Getting the reference sequences

Retrieving the MaarjAM ``.fasta`` release for VTX type sequences (SSUrDNA):

```sh
wget https://maarjam.ut.ee/resources/maarjam_database_SSU_TYPE.fasta.2019.zip 
unzip maarjam_database_SSU_TYPE.fasta.2019.zip 
rm maarjam_database_SSU_TYPE.fasta.2019.zip
### renaming...
mv maarjam_database_SSU_TYPE.fasta maarjam.fasta
```

Retrieving the Krüger's reference set from [here](https://drive.google.com/file/d/1EyyAI0qj3IIkJ0o543oZz8CqKo4PmUUt/view?usp=sharing) and download them.

```sh
### renaming...
mv SSU_alignment_Krueger_etal_2012_ver130407.fas kruger.fasta
```

Then assemble a list of SSUrDNA sequences for various taxa recognized for our purpose as outgroups. The sequences are in ``outgroups.txt``:

```sh
epost -db nuccore -input outgroups.txt -format acc   | efetch -format fasta > outgroups.fasta
```

<br>

For all these, simplify the sequence names to keep only "GB accession _ binome / VTX ID":

```sh
sed -i 's/ /_/g' maarjam.fasta
```
Then in R:
```r
rm(list=ls())
library(seqinr)
x=read.fasta("maarjam.fasta")
VTX=paste0("VTX",sapply(strsplit(names(x),"VTX"),'[',2))
GB_ID=sapply(strsplit(sapply(strsplit(names(x),"gb"),'[',2),"\\|"),'[',2)
names(x)=paste0(VTX,"_",GB_ID)
write.fasta(x,names=names(x),file.out="mar.fasta")
```

For Krüger's sequences:

```sh
sed -i 's/ /_/g' kruger.fasta
```

Then in R:

```r
rm(list=ls())
x=read.fasta("kruger.fasta")
ID=sapply(strsplit(sapply(strsplit(names(x),"org="),'[',1),"_"),'[',1)
binome=sapply(strsplit(sapply(strsplit(names(x),"org="),'[',2),"\\]"),'[',1)
x=x[2:length(x)]
names(x)=paste0(binome[2:length(binome)],"_",ID[2:length(ID)])
write.fasta(x,names=names(x),file.out="kru.fasta")
```

For the outgroups:

```sh
sed -i 's/ /_/g' outgroups.fasta
```

Then in R:

```r
rm(list=ls())
x=read.fasta("outgroups.fasta")
temp=sapply(strsplit(names(x),"_"),'[',1:3)
names=apply(temp,2,function(x)paste0(x[1],"_",x[2],"_",x[3]))
write.fasta(x,names=names,file.out="out.fasta")
```



Concatenate all this and move all ref sequences into a dedicated folder:

```sh
cat out.fasta kru.fasta mar.fasta > refs.fasta    
mkdir Ref_sequences
mv *.fasta ./Ref_sequences/
mv outgroups.txt ./Ref_sequences/ 
```
<br><br>

# 2. Build the reference phylogeny

We now have a ``refs.fasta`` file merging all these refence sequences, which we can aligne and assemble into a reference phylogeny:

```sh
### alignment
mafft-fftnsi --maxiterate 1000 --thread 10 refs.fasta  > refs.aligned.fasta

### deal with two problematic names
sed -i 's/_(?)//g' refs.aligned.fasta
sed -i 's/_(contam._?)//g' refs.aligned.fasta

### tree building
## In the root directory, make another one for phylogeny strictly
mkdir RAxML_phylogeny
cp ./Ref_sequences/refs.aligned.fasta ./RAxML_phylogeny/refs.aligned.fasta
cd RAxML_phylogeny
raxml-ng --all --msa refs.aligned.fasta --model GTR+G --bs-trees autoMRE{1000} --threads 10 -outgroup OR770595.1_Oppiella_falcata, KM043266.2_Philodina_gregaria, MT922832.1_Taraxacum_officinale, MN576773.1_Beauveria_yunnanensis, MN576764.1_Cordyceps_sp., KP114345.1_Fusarium_sp., KP114341.1_Cladosporium_sp., AF206999.1_Populus_tremuloides, AY284667.1_Eucephalobus_striatus, AY284653.1_Rhabditis_cf., HF571130.1_Trifolium_repens, JN939687.1_Nectria_pseudotrichia, JN940143.1_Cortinarius_roseoarmillatus, JN941670.1_Hypocrea_sulphurea, JN941237.1_Allomyces_reticulatus, JN941233.1_Allomyces_javanicus, JN941138.1_Amanita_subfrostiana, JN941134.1_Amanita_parvipantherina, JN940974.1_Candida_bokatorum, JN941117.1_Marasmius_tricolor, JQ040258.1_Mortierella_alpina, JQ040246.1_Umbelopsis_isabellina, JN939663.1_Trichoderma_sp., JN939394.1_Cryptococcus_neoformans, JN939046.1_Penicillium_crustosum, JN939014.1_Mucor_plumbeus, JN939010.1_Rhizopus_microsporus, JN939008.1_Rhizopus_oryzae, JN938995.1_Eurotium_herbariorum, JN938994.1_Sporobolomyces_roseus, JN938991.1_Aspergillus_candidus, JN938985.1_Kluyveromyces_marxianus, JN938976.1_Penicillium_verrucosum, JN938765.1_Pleurotus_pulmonarius, GU732640.1_Clematis_virginiana, AY839339.1_Vicia_cracca, AF163516.1_Fragaria_vesca, EF093780.1_Tectocepheus_velatus, AY605461.1_Acer_rubrum, AF217093.1_Clonorchis_sinensis, DQ016569.1_Papirinus_prodigiosus, AM747290.1_Homobasidiomycete_sp., X86686.2_Geosiphon_pyriformis, Exophiala_dermatitidis_AFTOL, Schizosaccharomyces_pombe_AFTOL, Henningsomyces_candidus_AFTOL, Rhodotorula_hordea_AFTOL
```


<br><br>

# 3. Placing OTU centroids (or ASV if we wanted so) in the reference phylogeny

This step is conducted using ``epa-ng``. However, before proceeding further, we need to make sure that our centroids and reference sequences are aligned with the exact same length. We thus have to first proceed with a global alignment, then parsing out the centroids and references into separated alignment files...

Centroids can be generated using any preferred method. One way is to use ``vsearch`` at a 97% similarity threshold, from an input file of ASVs (``ASV.fasta``):

```sh
vsearch --cluster_fast ASV.fasta --id 0.97 --centroids OTU_clusters/centroids.fasta --clusterout_id --uc OTU_clusters/uclust.txt
```
This exports a ``.fasta`` file with centroids sequences, and a uclust file from which we can extract cluster membership, which is essential for downstream merging of ASVs into proper clusters...Here, these outputs get stored in the ``OTU_clusters`` folder (created just to keep things clean in the parent folder!).


```sh

## From the root folder, create a new one for epa:
mkdir epa

## Then bring the centroids sequences in:
mv OTU_clusters/centroids.fasta epa/

## Also bring the aligned ref sequences in:
mv Ref_sequences/refs.aligned.fasta epa/

## Concetenate these together
cat epa/centroids.fasta epa/refs.aligned.fasta > epa/merged.fasta

## Perform the alignment
mafft-fftnsi --maxiterate 1000 --thread 10 epa/merged.fasta  > epa/merged.aligned.fasta
```

From there we can jump to R to parse the centroids vs reference sequences in this global alignment. This is available in [this R script](./Scripts/Parse%20aligned%20centroids%20and%20refs.R):

```r
rm(list=ls())
library(seqinr)
x=read.fasta("epa/merged.aligned.fasta")

cent=x[grepl("cluster",names(x))]
ref=x[!names(x)%in%names(cent)]

write.fasta(cent,names=names(cent),file.out="epa/centroids.glob.aligned.fasta")
write.fasta(ref,names=names(ref),file.out="epa/refs.glob.aligned.fasta")
```

<br>

Once this is done, we can run the epa algorithm, since we have our queries (centroids) and references with the same alignment length, and the RAxML tree for our reference sequences:

```sh
epa-ng -t [NOM DE TON ARBRE]  -s ref_al.fasta -q cent_al.fasta -m GTR+G --outdir epa/ --redo
```
