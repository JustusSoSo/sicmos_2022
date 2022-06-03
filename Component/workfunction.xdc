# the substrate is n-type silicon with an affinity of 4.17 and the height is about 1.00
# contact name=drain workfunc=4.97









# An example
# 1. Devedit sketch the region and name of the electrode
go DevEdit
work.area x1=0 x2=$cell y1=0-$source_t \
    y2=(@N_drift_t+@N_sub_t+@drain_t+1)

set drain_y1=@N_drift_t+@N_sub_t
set drain_y2=@N_drift_t+@N_sub_t+@drain_t
region reg=1 name=drain material=Aluminum \
	elec.id=1 \
    polygon="0,@drain_y1 @CELL,@drain_y1 @CELL,@drain_y2 0,@drain_y2"
	# you don't have to write "electrode" statement again.
	# By prepending the electrode name with "V" for voltage, "I" for current and "Q" for charge, you can directly and conveniently set the electrode bias, current or charge respectively.






# 2. Atlas define the contact with its workfunction
struct outf = B_tmp_1.str
go atlas
mesh infile=B_tmp_1.str
#
# set workfunc_drain=0.0
contact name=drain workfunc=4.97
# the substrate is n-type silicon with an affinity of 4.17 and the height is about 1.00

contact name=drain neutral
# another contact
# Note that contact statements are also cumulative.






# 3. testing the init structure
    # EXAMPLE:
        # OUTPUT FLOWLINES EX.VELO EY.VELO
        # SOLVE PREVIOUS V5=2 OUTF=data1.str MASTER
        # SAVE OUTF=data2.str

# output the band of the struct
    solve init
    output con.band val.band
    struct outf = B_tmp_2.str
    tonyplot B_tmp_2.str -set SET_str_band.set
quit
















# Another Example in Atlas
################ contact ################

# MATERIAL NAME=Material2 AFFINITY=VALUE
set affin_4HSiC     =3.6
material name=4H-SiC affinity=$affin_4HSiC

# the barrier height = Phi(metal) - X(semi)
    # barrier height = ??.?? eV
    # --> WorkFunction = $affin + ??.?? eV
set affin_4HSiC         =3.6
set sch_barrier         =1.20
set workfunc_sch        =$affin_4HSiC+$sch_barrier
set workfunc_ohm        =0
contact name=drain neutral
contact name=source neutral
contact name=SCH1 workfunc=$workfunc_sch
contact name=SCH2 workfunc=$workfunc_sch
contact name=OHM1 workfunc=$workfunc_ohm
##########################################