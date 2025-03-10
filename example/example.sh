ctg=/example/test.fa.gz
outpref=/example/hla-test-run

script=/immuannot/scripts/immuannot.sh
refdir=/refdata/Data-2024Feb02
bash ${script} -c ${ctg} -r ${refdir} -o ${outpref}
