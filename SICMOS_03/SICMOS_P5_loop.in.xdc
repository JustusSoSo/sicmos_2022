# set N_SCH       =1e17
# N_SCH

# save type=sdb outf="<output file>"
# type=list data="0.1,0.2,0.3,0.4,0.5"
# type=list data="0.25, 0.5,1,1.5,2,2.5,3.0"
# type=power range="1e16,1e19,4"

# 1. Von
set filename = SICMOS_P5_T1
# LOOP
	go internal
	load infile = $'filename'.in
	extract name="t1" clock.time
	sweep parameter=N_SCH type=list \
	data="0,1e14"
	sweep parameter=N_SCH type=power \
	range="1e15,1e19,5"
	# sweep parameter=N_SCH type=linear
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	quit
# LOOP
tonyplot -overlay \
	B_Ids-Vds_BD_0.log \
	B_Ids-Vds_BD_1e+14.log \
	B_Ids-Vds_BD_1e+15.log \
	B_Ids-Vds_BD_1e+16.log \
	B_Ids-Vds_BD_1e+17.log \
	B_Ids-Vds_BD_1e+18.log \
	B_Ids-Vds_BD_1e+19.log \
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







