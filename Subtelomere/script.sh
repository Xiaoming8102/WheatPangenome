#!/usr/bin/bash
###
 # @Author: Xie Xiaoming
 # @Date: 2024-09-29 15:08:52
 # @LastEditors: Xie Xiaoming
 # @LastEditTime: 2024-09-29 15:08:52
### 

for i in ZM16 Lo7 WN;do
	/software/RepeatMasker -e ncbi \
		-parallel 14 \
		-lib subtelomere.fasta \
		-html \
		-gff \
		-dir ./ ${i}.fa
done
