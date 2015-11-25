#!/bin/bash

awk 'NR > 15 { print }' GWAS_RISK/output/UKB_RISK_chr1.maf005.info30.euro.snptest.expected.order.chunk2500.resid.out > GWAS_RISK/temp/UKB_RISK_chr1.maf005.info30.euro.snptest.expected.order.chunk2500.resid.header.out

for i in {2..22}
do

awk 'NR > 16 { print }' GWAS_RISK/output/UKB_RISK_chr${i}.maf005.info30.euro.snptest.expected.order.chunk2500.resid.out > GWAS_RISK/temp/UKB_RISK_chr${i}.maf005.info30.euro.snptest.expected.order.chunk2500.resid.noheader.out

done

cat GWAS_RISK/temp/UKB_RISK_chr1.maf005.info30.euro.snptest.expected.order.chunk2500.resid.header.out GWAS_RISK/temp/UKB_RISK_chr*.maf005.info30.euro.snptest.expected.order.chunk2500.resid.noheader.out > GWAS_RISK/output/UKB_RISK_allchr.maf005.info30.euro.snptest.expected.resid.out
