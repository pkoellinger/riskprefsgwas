#!/bin/bash
#THISISATEST
for i in {1..22}
do
	snptest_v2.5.1_linux_x86_64_static/snptest_v2.5.1 \
	-data impv1.maf005.info30.euro/chr${i}impv1.maf005.info30.euro.order.bgen GWAS_RISK/input/UKB_RISK_snptest_order_chr${i}_resid.pheno \
	-frequentist 1 \
	-method expected \
	-chunk 2500 \
	-o GWAS_RISK/output/UKB_RISK_chr${i}.maf005.info30.euro.snptest.expected.order.chunk2500.resid.out \
	-log GWAS_RISK/output/UKB_RISK_chr${i}.maf005.info30.euro.snptest.expected.order.chunk2500.resid.log \
	-use_raw_phenotypes \
	-pheno resid \
	-miss_thresh 0.9 \
	-hwe \
	-missing_code -999 & 
done
