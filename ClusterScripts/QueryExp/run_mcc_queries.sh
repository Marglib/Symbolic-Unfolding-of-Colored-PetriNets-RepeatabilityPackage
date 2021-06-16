#!/bin/bash
#SBATCH --time=17:00:00
#SBATCH --mail-type=FAIL
#SBATCH --partition=naples

let "m=$3*1024*1024"
ulimit -v $m

F=$5
i=$6
t=$7

unzip ../$F/$i/$i-mcc-unfolded.pnml.zip -d temp/$t
unzip ../$F/$i/$t-mcc-unfolded.xml.zip -d temp/$t
unzippedmodel="temp/$t/$F/$i/$i-mcc-unfolded.pnml"
unzippedquery="temp/$t/$F/$i/$t-mcc-unfolded.xml"


for i in $(seq 1 16) ; do
    CMD=$(echo $1 | sed -e "s/SLURM_ARRAY_TASK_ID/$i/g")
    OUT=$(echo $2 | sed -e "s/SLURM_ARRAY_TASK_ID/$i/g")

    echo "$CMD &> $OUT" 
    RES=$(timeout ${4}m /usr/bin/time -f "@@@%e,%M@@@" $CMD 2>&1 )
    echo "$RES" > $OUT
done

rm $unzippedmodel
rm $unzippedquery

exit 0
