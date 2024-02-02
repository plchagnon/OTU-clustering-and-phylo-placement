#!/bin/bash
#SBATCH -N 4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --hint=compute_bound
#SBATCH -t 08:00:00
#SBATCH --job-name="SSU.MPI.tree"
#SBATCH --output=SSU.MPI.out
#SBATCH --mem-per-cpu=3G

./raxml-ng-mpi --all --msa refs.aligned.fasta --model GTR+G --bs-trees autoMRE{1000} --threads 8 -outgroup OR770595.1_Oppiella_falcata, KM043266.2_Philodina_gregaria, MT922832.1_Taraxacum_officinale, MN576773.1_Beauveria_yunnanensis, MN576764.1_Cordyceps_sp., KP114345.1_Fusarium_sp., KP114341.1_Cladosporium_sp., AF206999.1_Populus_tremuloides, AY284667.1_Eucephalobus_striatus, AY284653.1_Rhabditis_cf., HF571130.1_Trifolium_repens, JN939687.1_Nectria_pseudotrichia, JN940143.1_Cortinarius_roseoarmillatus, JN941670.1_Hypocrea_sulphurea, JN941237.1_Allomyces_reticulatus, JN941233.1_Allomyces_javanicus, JN941138.1_Amanita_subfrostiana, JN941134.1_Amanita_parvipantherina, JN940974.1_Candida_bokatorum, JN941117.1_Marasmius_tricolor, JQ040258.1_Mortierella_alpina, JQ040246.1_Umbelopsis_isabellina, JN939663.1_Trichoderma_sp., JN939394.1_Cryptococcus_neoformans, JN939046.1_Penicillium_crustosum, JN939014.1_Mucor_plumbeus, JN939010.1_Rhizopus_microsporus, JN939008.1_Rhizopus_oryzae, JN938995.1_Eurotium_herbariorum, JN938994.1_Sporobolomyces_roseus, JN938991.1_Aspergillus_candidus, JN938985.1_Kluyveromyces_marxianus, JN938976.1_Penicillium_verrucosum, JN938765.1_Pleurotus_pulmonarius, GU732640.1_Clematis_virginiana, AY839339.1_Vicia_cracca, AF163516.1_Fragaria_vesca, EF093780.1_Tectocepheus_velatus, AY605461.1_Acer_rubrum, AF217093.1_Clonorchis_sinensis, DQ016569.1_Papirinus_prodigiosus, AM747290.1_Homobasidiomycete_sp., X86686.2_Geosiphon_pyriformis, Exophiala_dermatitidis_AFTOL, Schizosaccharomyces_pombe_AFTOL, Henningsomyces_candidus_AFTOL, Rhodotorula_hordea_AFTOL
