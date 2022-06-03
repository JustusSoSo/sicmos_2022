go internal
# loop .in
load inf="SIC1.in"


# sweep parameter=<参数> type=<type> [range|list]="num1, num2, ..."
# save type=sdb outf="<output file>"
# sweep parameter=drain_t		type=list data="0.1,0.2,0.3,0.4,0.5,1.0,1.5,2.0,3.0,4.0,5.0"
# sweep parameter=N_substrate_t
# sweep parameter=N_drift_t
# sweep parameter=source_t
# sweep parameter=oxide_t
# sweep parameter=P_ch_t
# type=list data="0.1,0.2,0.3,0.4,0.5"

# sweep parameter=CH_w \
# 		type=list data="0.25, 0.5,1,1.5,2,2.5,3.0"

sweep parameter=P_ch \
	type=power range="1e16,1e19,4"














# save type=sdb outfile="tmp_save.sdb"
quit