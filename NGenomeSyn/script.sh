#!/usr/bin/bash

minimap2 -x asm5 -t 6 S4185.fa  KF11.fa > S4185_KF11.paf 
GetTwoGenomeSyn Paf2Link S4185_KF11.paf 5000 S4185_KF11.link  
NGenomeSyn -InConf S4185_KF11.conf -OutPut S4185_KF11.svg 
