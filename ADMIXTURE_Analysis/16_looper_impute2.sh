#!/bin/bash
#$ -cwd
CHR=$1 
LOOPTIMES=$2
for ((i=0;i<=LOOPTIMES;i++));
do
    x=$(( (i * 5000000) + 1))
    y=$(( (i+1) * 5000000))
    #echo "chr $CHR looping $LOOPTIMES times"
    #echo "chr $CHR position $x to $y"
    #echo "loop $i"
    echo "bash code/22_Impute2_two_references.sh $CHR $x $y"
done
##Este iterador requiere cromosoma y cantidad de veces a repetir. Por cada iteracion imputa 5M de pares de bases.
