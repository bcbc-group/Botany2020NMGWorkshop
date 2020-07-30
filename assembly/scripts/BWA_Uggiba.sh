mkdir SAM
mkdir bam
mkdir sorted_bam
mkdir Transcriptome



#Run cutadapt, need to tell it where the raw sequencing files are
#if [[ $start_step -le 1 ]]
#then
#	for file in Illumina_data_for_SNPs/*.fastq.gz
#	do
#		name=`basename $file .fastq.gz`
#		echo "Running fastp on $name"
#		forward=$name".fastq.gz"
#		/media/kcn2/12TBarray/jacob/Installed_programs/fastp -i Illumina_data_for_SNPs/$forward -o /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/$forward -z 4 --adapter_sequence=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA --adapter_sequence_r2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -q 20 --length_required 100 --thread 8
#	done
#fi


#to index a fasta file
#bwa index Ugibba_pruned_assembly.fasta

#Read group information starts with "@RG
#ID: is unique identifier of the samples, for now doing the sample name and the barcode info
#SM: is the sample name
#PL: is the sequencing equipment, in almost all cases this will be Illumina
#PU: is the run identifier, the lane, followed by the specific barcode of the sample
#LB: is the library count


bwa mem -t 8 -R "@RG\tID:bladderR1\tSM:Rep1\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_bladderR1.fastq.gz > SAM/Ugibba_bladderR1.sam
bwa mem -t 8 -R "@RG\tID:rhizoidR1\tSM:Rep1\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_rhizoidR1.fastq.gz > SAM/Ugibba_rhizoidR1.sam
bwa mem -t 8 -R "@RG\tID:bladderR2\tSM:Rep2\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_bladderR2.fastq.gz > SAM/Ugibba_bladderR2.sam
bwa mem -t 8 -R "@RG\tID:stemR2\tSM:Rep2\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_stemR2.fastq.gz > SAM/Ugibba_stemR2.sam
bwa mem -t 8 -R "@RG\tID:leafR3\tSM:Rep3\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_leafR3.fastq.gz > SAM/Ugibba_leafR3.sam
bwa mem -t 8 -R "@RG\tID:bladderR3\tSM:Rep3\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_bladderR3.fastq.gz > SAM/Ugibba_bladderR3.sam
bwa mem -t 8 -R "@RG\tID:stemR3\tSM:Rep3\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_stemR3.fastq.gz > SAM/Ugibba_stemR3.sam
bwa mem -t 8 -R "@RG\tID:rhizoidR3\tSM:Rep3\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_rhizoidR3.fastq.gz > SAM/Ugibba_rhizoidR3.sam
bwa mem -t 8 -R "@RG\tID:leafR1\tSM:Rep1\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_leafR1.fastq.gz > SAM/Ugibba_leafR1.sam
bwa mem -t 8 -R "@RG\tID:stemR1\tSM:Rep1\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_stemR1.fastq.gz > SAM/Ugibba_stemR1.sam
bwa mem -t 8 -R "@RG\tID:leafR2\tSM:Rep2\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_leafR2.fastq.gz > SAM/Ugibba_leafR2.sam
bwa mem -t 8 -R "@RG\tID:rhizoidR2\tSM:Rep2\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_rhizoidR2.fastq.gz > SAM/Ugibba_rhizoidR2.sam
bwa mem -t 8 -R "@RG\tID:shootstraps\tSM:Rep\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_shootstraps.fastq.gz > SAM/Ugibba_shootstraps.sam
bwa mem -t 8 -R "@RG\tID:veg\tSM:Rep\tPL:HiSeq\tPU:HTNMKDSXX\tLB:RNA-Seq" Ugibba_pruned_assembly.fasta /scratch/Botany2020NMGWorkshop/raw_data/Ugibba/transcriptome/Ugibba_vegetative.fastq.gz > SAM/Ugibba_vegetative.sam






#convert SAM to BAM for sorting

for file in SAM/*.sam
do
	echo "Convert $file to to BAM"
	name=`basename $file .sam`
	samtools view -S -b $file > bam/$name.bam
	rm $file
done

#Sort BAM for SNP calling
for file in bam/*.bam
do
	echo "Sort $file"
	name=`basename $file .bam`
	readid=$name
	samtools sort -o sorted_bam/$readid.bam $file
	rm $file
done



hostname
