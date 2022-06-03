# SCH_width


set filename = SICMOS_P1_T1
# 1. Von
# LOOP
	go internal
	load infile = $'filename'.in
	extract name="t1" clock.time
	sweep parameter=SCH_width type=linear \
	range="0.0,5.0,51"
	save type=sdb outfile=D_$'filename'.dat
	endsave
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	tonyplot D_$'filename'.dat
	quit
# LOOP
tonyplot -overlay -st \
	B_Ids-Vds_BD=1.log	\
	B_Ids-Vds_BD=1.5.log	\
	B_Ids-Vds_BD=2.log	\
	B_Ids-Vds_BD=2.5.log	\
	B_Ids-Vds_BD=3.log	\
	B_Ids-Vds_BD=3.5.log	\
	-set SET_log_Ids-Vds_BD.set
quit



# 2. Ronsp
# linear influence
set filename = SICMOS_P1_T2
# LOOP
	go internal
	load infile = $'filename'.in
	extract name="t1" clock.time
	sweep parameter=SCH_width type=linear \
		range="0,5.0,51"
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	quit
# LOOP




tonyplot -overlay -st \
B_Ids-Vds_MOS_SCH_w=0.log \
B_Ids-Vds_MOS_SCH_w=1.log \
B_Ids-Vds_MOS_SCH_w=2.log \
B_Ids-Vds_MOS_SCH_w=3.log \
B_Ids-Vds_MOS_SCH_w=4.log \
B_Ids-Vds_MOS_SCH_w=5.log \
-set B_Ids-Vds_MOS_SCH_w.set
quit









# 3.BV
set filename = SICMOS_P1_T3
# LOOP
	go internal
	load infile = $'filename'.in
	extract name="t1" clock.time
	sweep parameter=SCH_width type=linear \
		range="0,5,21"
	# 0,0.25,0.50...1.0 = 4+1
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	save type=sdb outfile=D_SCH_w_$'filename'.dat
	endsave
	tonyplot D_SCH_w_$'filename'.dat
	quit
# LOOP


















# save type=sdb outf="<output file>"
# type=list data="0.1,0.2,0.3,0.4,0.5"
# type=list data="0.25, 0.5,1,1.5,2,2.5,3.0"
# type=power range="1e16,1e19,4"