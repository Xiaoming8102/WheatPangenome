#!/usr/bin/bash
###
 # @Author: Xie Xiaoming
 # @Date: 2024-09-29 14:46:46
 # @LastEditors: Xie Xiaoming
 # @LastEditTime: 2024-09-29 15:05:02
### 
set -uxo pipefail

arr=(`awk '{print $1}' ./samples_list.txt | tr '\n' ' '|sed s/' '$//g`) # one sample per line
WP=/data_path/ #path of bam files

# call gene depth

for SM in ${arr[@]};do

  mkdir -p ${SM}
  for CHR in `echo chr{1..3}{A,B,D}`;do
  ( bedtools coverage -a ./bed_CS/${CHR}.1.gene.bed -b $WP/${SM}/05.mergeAsplit/${CHR}.1.*.bam -counts -sorted > ${SM}/${CHR}.1.gene.DP 
    bedtools coverage -a ./bed_CS/${CHR}.2.gene.bed -b $WP/${SM}/05.mergeAsplit/${CHR}.2.*.bam -counts -sorted > ${SM}/${CHR}.2.gene.DP
  ) &
  done
  wait

  for CHR in `echo chr{4..7}{A,B,D}`;do
  ( bedtools coverage -a ./bed_CS/${CHR}.1.gene.bed -b $WP/${SM}/05.mergeAsplit/${CHR}.1.*.bam -counts -sorted > ${SM}/${CHR}.1.gene.DP 
    bedtools coverage -a ./bed_CS/${CHR}.2.gene.bed -b $WP/${SM}/05.mergeAsplit/${CHR}.2.*.bam -counts -sorted > ${SM}/${CHR}.2.gene.DP
  ) &
  done
  wait

  for CHR in `echo chr{1..7}{A,B,D}`;do
      paste ${SM}/${CHR}.1.gene.DP bed_CS/${CHR}.1.gene.length > ${SM}/${CHR}.1.gene.tmp
      paste ${SM}/${CHR}.2.gene.DP bed_CS/${CHR}.2.gene.length > ${SM}/${CHR}.2.gene.tmp
      # normlize DP by gene length
      gawk -vOFS="\t" '{$4=$4*1000/$5;print}' ${SM}/${CHR}.1.gene.tmp |sponge ${SM}/${CHR}.1.gene.tmp
      gawk -vOFS="\t" '{$4=$4*1000/$5;print}' ${SM}/${CHR}.2.gene.tmp |sponge ${SM}/${CHR}.2.gene.tmp
  done

  # normlize DP by whole genome
  awk '{if($4!=0) printf("%.2f\n",$4)}' ${SM}/*gene.tmp > ${SM}/combine_DP
  ave=`datamash mode 1 < "$SM"/combine_DP`

  for CHR in `echo chr{1..7}{A,B,D}`;do
    gawk -vOFS="\t" -vave=$ave '{print $4/ave}' ${SM}/${CHR}.1.gene.tmp > ${SM}/${CHR}.gene.norm
    gawk -vOFS="\t" -vave=$ave '{print $4/ave}' ${SM}/${CHR}.2.gene.tmp >> ${SM}/${CHR}.gene.norm
  done
done
