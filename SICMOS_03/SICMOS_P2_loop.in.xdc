# sch_barrier

# 1. P2 toward Von
set filename = SICMOS_P2_T1
# LOOP
	go internal
	load inf="SICMOS_P2_T1.in"
	extract name="t1" clock.time
	# 0 0.1 0.2...
	sweep parameter=sch_barrier type=linear \
	range="1.0, 2.0, 21"
	save type=sdb outfile=D_$'filename'.dat
	endsave
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	tonyplot D_$'filename'.dat
	quit
# LOOP

tonyplot -overlay -st \
	B_Ids-Vds_BD=1.log		\
	B_Ids-Vds_BD=1.25.log	\
	B_Ids-Vds_BD=1.5.log	\
	B_Ids-Vds_BD=1.75.log	\
	B_Ids-Vds_BD=2.log		\
	-set SET_log_Ids-Vds_BD.set
quit



# 2. Ronsp
# None influence
set filename = SICMOS_P2_T2
sweep parameter=sch_barrier type=linear \
range="1.0, 2.0, 21"

# 3.BV
set filename = SICMOS_P2_T3
# LOOP
	go internal
	load infile = $'filename'.in
	extract name="t1" clock.time
	sweep parameter=sch_barrier type=linear \
	range="1.0, 2.0, 21"
	extract name="t2" clock.time
	extract name="Elapsed_second_01" $t2 - $t1
	extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
	quit
# LOOP
tonyplot -overlay -st \
	B_BV_SCH_w=1.log \
	B_BV_SCH_w=1.2.log \
	B_BV_SCH_w=1.4.log \
	B_BV_SCH_w=1.6.log \
	B_BV_SCH_w=1.8.log \
	B_BV_SCH_w=2.log  \
	-set SET_log_Ids-Vds_BV.set
quit
























# save type=sdb outf="<output file>"
# type=list data="0.1,0.2,0.3,0.4,0.5"
# type=list data="0.25, 0.5,1,1.5,2,2.5,3.0"
# type=power range="1e16,1e19,4"

# go internal
# set example=ancaex05
# load infile=$"example"_tmpl.in
# sweep parameter=theta0 type=linear range="1.0e8, 9.0e8, 5"  \
#       parameter=seg0 type=linear range="500, 2000, 7"
# save type=sdb outfile=$"example".dat
# tonyplot $"example".dat -set $"example".set