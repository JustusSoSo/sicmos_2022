# P well concentration
# P_well
# now is 5e17
# P ch should be	1e16 - 1e17
# P well should be	1e17 - 1e18



# 1. Von
set filename = SICMOS_P4_T1
# LOOP
	go internal
	load infile = $'filename'.in
	extract name="t1" clock.time
	sweep parameter=P_well type=linear \
	range="1E17,  50E17,  50"
	save type=sdb outfile=D_$'filename'.dat
	endsave
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	tonyplot D_$'filename'.dat
	quit
# LOOP

tonyplot -overlay -st \
B_Ids-Vds_BD_1e+17.log \
B_Ids-Vds_BD_1e+18.log \
B_Ids-Vds_BD_2e+18.log \
B_Ids-Vds_BD_3e+18.log \
B_Ids-Vds_BD_4e+18.log \
B_Ids-Vds_BD_5e+18.log \
-set SET_log_Ids-Vds_BD.set
quit







# 2. Ronsp
set filename = SICMOS_P4_T2
# LOOP
	go internal
	load infile = $'filename'.in
	extract name="t1" clock.time
	sweep parameter=P_well type=linear \
	range="1E17,  50E17,  50"
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	quit
# LOOP

