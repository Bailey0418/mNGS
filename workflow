conda create --name myenv python=3.9
#1.查看数据质量
 #（1）FastQC质控(FastQC v0.12.1 )
fastqc -t 12 -o /mnt/raid5/User/bailin/project/Metagenomics/test_result/2.FastQC /mnt/raid5/User/bailin/project/Metagenomics/test_result/1.preprocess/raw/*.fastq.gz #conda运行，
 #-o --outdir:输出路径；--extract：结果文件解压缩；--noextract：结果文件压缩；-f --format:输入文件格式.支持bam,sam,fastq文件格式；-t --threads:线程数；-c --contaminants：制定污染序列，文件格式 name[tab]sequence；
 #-a --adapters：指定接头序列，文件格式name[tab]sequence；-k --kmers：指定kmers长度（2-10bp,默认7bp）；-q --quiet：安静模式
 #（2）MultiQC批量生成质控结果文件(multiqc, version 1.26)
multiqc .
 #-o output_directory 是你想要保存报告的路径；--export-csv：指定导出 CSV 文件。
#2.去接头和低质量序列
 #Trimmomatic(version 0.39)
 #（1）单样本代码：
trimmomatic PE -phred33 /mnt/raid5/User/bailin/project/Metagenomics/test_result/1.preprocess/raw/SRR5886303_1.fastq.gz /mnt/raid5/User/bailin/project/Metagenomics/test_result/1.preprocess/raw/SRR5886303_2.fastq.gz output_forward_paired.fq.gz output_forward_unpaired.fq.gz output_reverse_paired.fq.gz output_reverse_unpaired.fq.gz ILLUMINACLIP:adapters_path:2:30:10 SLIDINGWINDOW:4:20 MINLEN:50
 #（2）多样本代码
for *_1.fq.gz in /mnt/raid5/User/bailin/project/Metagenomics/test_result/1.preprocess/raw
do i=$(basename $filename _1.fq.gz)
echo $i
java -jar Trimmomatic-0.39/trimmomatic-0.39.jar PE -phred33 \
${i}_1.fastq.gz ${i}_2.fastq.gz \
${i}_1_paired.fastq  ${i}_1_unpaired.fastq ${i}_2_paired.fastq  ${i}_2_unpaired.fastq \
ILLUMINACLIP:adapters_path:2:30:10 SLIDINGWINDOW:4:20 MINLEN:50\
done
#3.去宿主序列
 #Bowtie2（）
