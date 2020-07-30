# Botany2020NMGWorkshop
A repo for scripts and associated files for the Botany 2020 Virtual Nonmodel Genomics Workshop

The contributors to this workshop are:
Suzy Strickler (srs57@cornell.edu)
Fay-Wei Li (fl329@cornell.edu)
Jacob Landis (jbl256@cornell.edu)
Andrew Nelson (an425@cornell.edu)

The focus of the workshop is long-read genome sequencing, assembly, annotation, and downstream analyses.
The taxonomic focus is Utricularia gibba, with a 78 MB genome and recent high quality published genome
in the paper "Long-read sequencing uncovers the adaptive topography of a carnivorous plant genome" by 
Lan et al. 2017 in PNAS.

All the provided data was downloaded from SRA, including Illumina genome sequencing (SRR10676752),
PacBio long-read data (from authors of Lan et al. 2017), and RNA-Seq (SRR10676739,SRR10676740,
SRR10676741,SRR10676742,SRR10676743,SRR10676744,SRR10676745,SRR10676746,SRR10676747,SRR10676748,
SRR10676749,SRR10676750,SRR5046448,SRR10676751).

The packaged data for the workshop can all be downloaded from the Discovery Environment of CyVerse
using icommands and the following path: /iplant/home/shared/Botany2020NMGWorkshop

The programs that are needed for workshop have all been downloaded to a virtual machine 
with the Botany2020NMGWorkshop image. A large3 instance (8 CPU, 64 GB RAM, and 480 GB storage),
which is enough resources to run all the steps. Some of the programs that are used in this workshop
are: BUSCO, fastp, Flye, fmlrc, hisat2, Maker, MaSuRCA, Nanoplot, Orthofinder, Stacks, Stringtie,
Transdecoder, and VCFtools.

Structure of the workshop is as follows: Basic Linux commands, generating sequence data,
genome assembly, genome annotation, and downstream analyses with CoGe and SNP calling. For both
the genome assembly and annotation portion, small test data sets are provided to easily run all the steps.
The full data sets are also provided for comparisons, but many of the analyses may take between 6-18 hours to run.
For each section there is a presentation (found in slides), and walkthroughs (except for the sequencing section).
For the assembly module, steps can be found in assembly/Genome_assembly_workshop_steps.pdf.
Annotation scripts are numbered 1 to 6 to be done in order.
The CoGe steps are in CoGe_overview.pdf.
SNP calling steps are found in SNP_calling.pdf.

Additional data that is supplied in the shared Botany2020NMGWorkshop directory:

assemblies
/Acarambola/
Genome fasta, proteins fasta, and gene model gff of Averrhoa carambola
Data sources (Wu et al, 2020): https://www.nature.com/articles/s41438-020-0307-3 https://bigd.big.ac.cn/search/?dbId=gwh&q=GWHABKE00000000
/Acoerulea/
Genome fasta, protein fasta, and gene model gff of Aquilegia coerulea
Data sources (Filiault et al, 2018): https://elifesciences.org/articles/36426 https://www.ncbi.nlm.nih.gov/genome/?term=aquilegia
/Avesiculosa/
Genome fasta, protein fasta, and gene model gff of Aldrovanda vesiculosa
Data sources (Palfalvi et al 2020): https://www.sciencedirect.com/science/article/pii/S0960982220305674 https://www.biozentrum.uni-wuerzburg.de/carnivorom/resources
/Bvulgaris/
Genome fasta, protein fasta, and gene model gff of Beta vulgaris
Data sources (Del Rio et al, 2019): https://pubmed.ncbi.nlm.nih.gov/31104348/ https://www.ncbi.nlm.nih.gov/genome/221
/Cfollicularis/
Genome fasta, protein fasta, and gene model gff of Cephalotus follicularis
Data sources (Fukushima et al, 2017): https://www.nature.com/articles/s41559-016-0059 https://www.ncbi.nlm.nih.gov/genome/?term=Cephalotus
/Dmuscipula/
Genome fasta, protein fasta, and gene model gff of Dionaea muscipula
Data sources (Palfalvi et al 2020): https://www.sciencedirect.com/science/article/pii/S0960982220305674 https://www.biozentrum.uni-wuerzburg.de/carnivorom/resources
/Dspatulata/
Genome fasta, protein fasta, and gene model gff of Drosera spatulata
Data sources (Palfalvi et al 2020): https://www.sciencedirect.com/science/article/pii/S0960982220305674 https://www.biozentrum.uni-wuerzburg.de/carnivorom/resources
/Gaurea/
Genome fasta, protein fasta, and gene model gff of Genlisea aurea
Data sources (Leushkin et al., 2013): https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3728226/ https://www.ncbi.nlm.nih.gov/genome/24580
/Sindicum/
Genome fasta, protein fasta, and gene model gff of Sesamum indicum
Data sources (Wang et al., 2014): https://pubmed.ncbi.nlm.nih.gov/24576357/ https://www.ncbi.nlm.nih.gov/genome/11560
/Ugibba/
Genome fasta, protein fasta, and gene model gff of Utricularia gibba
Data sources (Lan et al., 2017): https://www.pnas.org/content/114/22/E4435.short
/Ureniformis/
Genome fasta, protein fasta, and gene model gff of Utricularia reniformis
Data sources: https://www.ncbi.nlm.nih.gov/genome/44110

embryophyta_odb9
Lineage file for BUSCO

raw_data
/Ugibba/genome/
Illumina (SRR10676752; ) and PacBio (Ugibba_PacBio_to_use; Lan et al., 2017) reads of Utricularia gibba
/Ugibba/transcriptome/
Transcriptome (PRJNA595351)
/Ureniformis/genome/
Illumina MiSeq reads of Utricularia reniformis
Data sources: https://www.ncbi.nlm.nih.gov/sra/?term=SRR5349713
/Utricularia_spp/transcriptomes
RNA-seq from five species of Utricularia
Data source: https://www.ncbi.nlm.nih.gov/bioproject/PRJNA354080
