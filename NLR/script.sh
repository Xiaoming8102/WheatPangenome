#!/usr/bin/bash
###
 # @Author: Xie Xiaoming
 # @Date: 2024-09-29 15:06:16
 # @LastEditors: Xie Xiaoming
 # @LastEditTime: 2024-09-29 15:06:16
### 

export toolpath=/data2/user2/xiexm/src/NLR-Annotator_2.1

#function to run NLR-Annotator
function run_NLR_Annotator(){
    local genome=$1

    java -jar $toolpath/NLR-Annotator-v2.1.jar -i "$genome".fa \
        -x $toolpath/src/mot.txt \
        -y $toolpath/src/store.txt \
        -o "$genome".txt \
        -g "$genome".gff \
        -b "$genome".bed \
        -t 8
}

export -f run_NLR_Annotator

#run NLR-Annotator in parallel
cat $toolpath/genomes.list.txt | xargs -I {} -P 2 sh -c "run_NLR_Annotator {}"
