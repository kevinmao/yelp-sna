#!/bin/bash

# global vars
source ../../config.sh 

OUTDIR=${PREDICT_DATA}/summary
mkdir -p ${OUTDIR}

topnlist="10 20 30 40 50"
Threshold=${1:-30}

############################################
### precision at $Threshold
############################################
LOGGER "Processing precision at $Threshold"

for n in `echo ${topnlist}`; do
    bash precision_at_n.sh $n > ${OUTDIR}/precision.AT$n.tsv
done

# combine
fout=${OUTDIR}/precision.T$Threshold.tsv
ftmp=tmp.`date +%s`
fheader=${ftmp}.header
fcol1=${ftmp}.col1
rm -f ${fout}
printf "%s\n" "position" > ${fcol1}
for n in `echo ${topnlist}`; do
    printf "%d\n" "$n" >> ${fcol1}
    F=${OUTDIR}/precision.AT$n.tsv
    cat $F | grep "^$Threshold" | cut -f2- >> ${fout}
done

cat ${OUTDIR}/precision.AT10.tsv ${fout} | cut -f2- | grep 'common_nbr' > ${fheader}
cat ${fheader} ${fout} > ${fout}.1
paste ${fcol1} ${fout}.1 > ${fout}
rm -f ${fout}.* ${ftmp}*
rm -f ${OUTDIR}/*AT*

############################################
### mf precision at $Threshold
############################################
LOGGER "Processing mf_precision at $Threshold"

for n in `echo ${topnlist}`; do
    bash precision_at_n.sh $n mf > ${OUTDIR}/mf_precision.AT$n.tsv
done

# combine
fout=${OUTDIR}/mf_precision.T$Threshold.tsv
ftmp=tmp.`date +%s`
fheader=${ftmp}.header
fcol1=${ftmp}.col1
rm -f ${fout}
printf "%s\n" "position" > ${fcol1}
for n in `echo ${topnlist}`; do
    printf "%d\n" "$n" >> ${fcol1}
    F=${OUTDIR}/mf_precision.AT$n.tsv
    cat $F | grep "^$Threshold" | cut -f2- >> ${fout}
done

cat ${OUTDIR}/mf_precision.AT10.tsv ${fout} | cut -f2- | grep 'common_nbr' > ${fheader}
cat ${fheader} ${fout} > ${fout}.1
paste ${fcol1} ${fout}.1 > ${fout}
rm -f ${fout}.* ${ftmp}*
rm -f ${OUTDIR}/*AT*

LOGGER "Done."
