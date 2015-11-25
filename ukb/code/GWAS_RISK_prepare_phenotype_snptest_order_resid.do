clear all
set more off
use "clean/4902_abbrev_merged_4904.dta"
drop _merge
merge 1:1 n_eid using "clean/impv1.euro.sample.order.dta",keep(3)

/*
n_2040_0_0      int     %20.0g     m_100349   `pheno' taking
n_2040_1_0      int     %20.0g     m_100349   `pheno' taking

         risk taking |      Freq.     Percent        Cum.
---------------------+-----------------------------------
Prefer not to answer |      1,028        0.20        0.20 CODED: -3
         Do not know |     18,513        3.69        3.89 CODED: -1
                  No |    352,319       70.22       74.11 CODED: 0
                 Yes |    129,887       25.89      100.00 CODED: 1
---------------------+-----------------------------------
               Total |    501,747      100.00

         risk taking |      Freq.     Percent        Cum.
---------------------+-----------------------------------
Prefer not to answer |         22        0.11        0.11
         Do not know |        646        3.18        3.28
                  No |     14,872       73.12       76.40
                 Yes |      4,799       23.60      100.00
---------------------+-----------------------------------
               Total |     20,339      100.00
		   			   
*/

// Phenotype preparation
// drop "Prefer not to answer" or "Do not know"
replace n_2040_0_0 = . if n_2040_0_0 < 0
replace n_2040_1_0 = . if n_2040_1_0 < 0
// keep first observation
g RISK = n_2040_0_0 
replace RISK = n_2040_1_0 if n_2040_0_0 == .

//Covariates preparation
gen SEX = n_22001_0_0
// take age from first meausre only
gen AGE = n_21003_0_0
replace AGE = n_21003_1_0 if n_2040_0_0 == .
egen Z_AGE = std(AGE)
gen Z_AGE2 = Z_AGE*Z_AGE
gen PC1 = n_22009_0_1
gen PC2 = n_22009_0_2
gen PC3 = n_22009_0_3
gen PC4 = n_22009_0_4
gen PC5 = n_22009_0_5
gen PC6 = n_22009_0_6
gen PC7 = n_22009_0_7
gen PC8 = n_22009_0_8
gen PC9 = n_22009_0_9
gen PC10 = n_22009_0_10
gen PC11 = n_22009_0_11
gen PC12 = n_22009_0_12
gen PC13 = n_22009_0_13
gen PC14 = n_22009_0_14
gen PC15 = n_22009_0_15
gen Array = n_22000_0_0 > 0

/*
-SNPTEST want a column with the header 'missing' after the first two columns with IDs. 
I made it equal to 0 for every individual that we want to include in the GWAS, and 1 for the others.
-I replaced all the covariates and the phenotype to -999 for all the individuals 
that should not be included (I don't think it's strictly necessary given the above)
-I manually merged in the attached file as header. 
Description can be found here: http://www.stats.ox.ac.uk/~marchini/software/gwas/file_format.html
*/

//Restrict sample to people with phenotype
//drop if phenotype==.
// cannot just drop bc snptest requires # individuals in geneotype files be the same as phenotype files

g missing = 0 
replace missing = 1 if RISK == .
replace missing = 1 if AGE == .
sum AGE RISK if missing == 0

// just save residuals!
xi: reg RISK i.SEX i.AGE i.SEX*i.AGE PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 PC11 PC12 PC13 PC14 PC15 i.n_22000_0_0 if missing == 0
predict resid if missing == 0, residuals
replace resid = -999 if missing == 1 
sort order

//Export files
//Need to create one per chromosome or else SNPTEST must take turns sharing 1 file among 22 jobs
forval i = 1/22 {
	export delimited n_eid n_eid missing resid using "GWAS_RISK/temp/UKB_RISK_snptest_order_noheader_chr`i'_resid.pheno", noq delim(" ") replace novarnames
	shell cat "GWAS_RISK/input/header_snptest_resid.txt" "GWAS_RISK/temp/UKB_RISK_snptest_order_noheader_chr`i'_resid.pheno" > "GWAS_RISK/input/UKB_RISK_snptest_order_chr`i'_resid.pheno"
}
