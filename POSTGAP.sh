#!/bin/bash

cd result_blocks

Rscript ../postgap1.R


for i in `cat ../heatmap_blocks/heatmap_blocks.tsv`
do
echo $i
cp $i ../heatmap_blocks/$i 
done

python ../postgap2.py

Rscript ../postgap3.R
