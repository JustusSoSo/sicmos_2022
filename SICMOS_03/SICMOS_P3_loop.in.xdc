# P trench
# P_well_t

# 1. Von
set filename = SICMOS_P3_T1
# LOOP
	go internal
	load infile = $'filename'.in
	extract name="t1" clock.time
	sweep parameter=P_well_t type=linear \
	range="0.6,  3.5,  30"
	save type=sdb outfile=D_$'filename'.dat
	endsave
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	tonyplot D_$'filename'.dat
	quit
# LOOP
tonyplot -overlay -st \
	B_Ids-Vds_BD_1.log	\
	B_Ids-Vds_BD_1.5.log	\
	B_Ids-Vds_BD_2.log	\
	B_Ids-Vds_BD_2.5.log	\
	B_Ids-Vds_BD_3.log	\
	B_Ids-Vds_BD_3.5.log	\
	-set SET_log_Ids-Vds_BD.set
quit








# 2. Ronsp
set filename = SICMOS_P3_T2
# LOOP
	go internal
	load infile = $'filename'.in
	extract name="t1" clock.time
	sweep parameter=P_well_t type=linear \
	range="0.6,  3.5,  30"
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	quit
# LOOP
