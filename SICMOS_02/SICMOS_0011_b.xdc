################ SIMULATION TEST ################
# 转移特性
# Threshold simulation
    set affin_4HSiC =3.2
    set sch_barrier =1.5
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    go atlas simflags = "-80 -p 4"
    set DEVICE_W    =0.8E2
    mesh infile = ../STR/A_tmp_1.str width=$DEVICE_W
    ################ contact ################
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC workfunc=$workfunc_sch
    ################ contact ################
    extract name="t1" clock.time
    models srh
    models cvt fermidirac
    models conmob
    models fldmob
    models auger
    models analytic
    models optr
    models bgn
    models print
    method newton trap maxtrap=10
    solve init prev
    # solve Vsource   =0
    solve Vdrain=0.1
    ################ LOGGING ################
        log outf=B_Ids-Vgs_Vds=0.1V.log
        # vgate
        solve Vgate=-2.0 vstep=0.25 vfinal=8.0 name=gate
        log close
    ################ LOGGING ################
    tonyplot B_Ids-Vgs_Vds=0.1V.log -set SET_log_Ids-Vgs_Vds=0.1V.set
    # threshold
        extract init infile="B_Ids-Vgs_Vds=0.1V.log"
        extract name="Vthreshold" \
            (xintercept(maxslope(curve(abs(v."gate"),abs(i."drain")))) - abs(ave(v."drain"))/2.0) \
            datafile="data01_vth.txt"
    # threshold
    # time
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# Threshold simulation
tonyplot B_Ids-Vgs_Vds=0.1V.log -set SET_log_Ids-Vgs_Vds=0.1V.set



# 4.9V
# MOSFET输出特性
# Ids - Vds diode
    set affin_4HSiC =3.2
    set sch_barrier =1.7
    # barrier of SiC should be 1.2 ~ 1.7
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    go atlas simflags = "-80 -p 8"
    set DEVICE_D    =0.8E2
    set DEVICE_W    =10
    set DEVICE_AREA =$DEVICE_D * $DEVICE_W * 1e-8
    mesh infile = ../STR/A_tmp_1.str width=$DEVICE_D
    # width=0.799E6
    extract name="t1" clock.time
    ################ contact ################
    contact all neutral
    contact name=source \
        BARRIER ALPHA=1.0e-7 SURF.REC \
        workfunc=$workfunc_sch
    ################ contact ################
        # models print
        # solve initial
        # output con.band val.band
        # struct outf = ../STR/A_tmp_1_band.str
        # tonyplot ../STR/A_tmp_1_band.str -set ../STR/SET_str_band.set
    ################ contact ################
    # models
    models srh
    models cvt fermidirac
    models conmob
    models fldmob
    models auger
    models optr
    models analytic
    models bgn
    models print
    # method
    # method newton trap maxtrap=15
    # method climit=1e-4 maxtrap=10
    # method newton trap maxtrap=5 itlimi=20
    # method newton trap maxtrap=10 itlimi=20
    method climit=1e-4 maxtrap=15
    # load in temporary files and ramp Vds
    solve init
    solve vdrain=-1
    set VDS_final = 50
    solve vgate=0 outf  =A_solve_tmp1
    solve vgate=2 outf  =A_solve_tmp2
    solve vgate=4 outf  =A_solve_tmp3
    solve vgate=5 outf  =A_solve_tmp4
    solve vgate=6 outf  =A_solve_tmp5
    solve vgate=8 outf  =A_solve_tmp6
    solve vgate=10 outf =A_solve_tmp7
    solve vgate=15 outf =A_solve_tmp8
    solve vgate=20 outf =A_solve_tmp9
    solve vgate=25 outf =A_solve_tmp10
    load infile         =A_solve_tmp1
    log outfile=B_Ids-Vds_MOS_1.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    load infile         =A_solve_tmp2
    log outfile=B_Ids-Vds_MOS_2.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    load infile         =A_solve_tmp3
    log outfile=B_Ids-Vds_MOS_3.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    load infile         =A_solve_tmp4
    log outfile=B_Ids-Vds_MOS_4.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    load infile         =A_solve_tmp5
    log outfile=B_Ids-Vds_MOS_5.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    load infile         =A_solve_tmp6
    log outfile=B_Ids-Vds_MOS_6.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    load infile         =A_solve_tmp7
    log outfile=B_Ids-Vds_MOS_7.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    load infile         =A_solve_tmp8
    log outfile=B_Ids-Vds_MOS_8.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    load infile         =A_solve_tmp9
    log outfile=B_Ids-Vds_MOS_9.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    load infile         =A_solve_tmp10
    log outfile=B_Ids-Vds_MOS_10.log
    solve name=drain vstep=0.2 vfinal=$VDS_final
    # PLOT
        tonyplot -overlay \
        B_Ids-Vds_MOS_1.log B_Ids-Vds_MOS_2.log B_Ids-Vds_MOS_3.log B_Ids-Vds_MOS_4.log B_Ids-Vds_MOS_5.log B_Ids-Vds_MOS_6.log B_Ids-Vds_MOS_7.log B_Ids-Vds_MOS_8.log B_Ids-Vds_MOS_9.log B_Ids-Vds_MOS_10.log \
        -set SET_log_Ids-Vds_MOS_overlay.set
        #
        set tmp_x1=0
        set tmp_x2=2
        extract init infile="B_Ids-Vds_MOS_9.log"
        extract name="MOS_20V_Ronsp" min(v."drain"/i."drain") \
        * 1e3 * $DEVICE_AREA \
        datafile="data02_Ron.txt"
    # PLOT

    # time
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# Ids - Vds diode
tonyplot -overlay \
B_Ids-Vds_MOS_1.log B_Ids-Vds_MOS_2.log B_Ids-Vds_MOS_3.log B_Ids-Vds_MOS_4.log B_Ids-Vds_MOS_5.log B_Ids-Vds_MOS_6.log B_Ids-Vds_MOS_7.log B_Ids-Vds_MOS_8.log B_Ids-Vds_MOS_9.log B_Ids-Vds_MOS_10.log \
-set SET_log_Ids-Vds_MOS_overlay.set
# MOSFET RON measure
    # Ron（Vgs=20V,Vds=2V)
    # Vth(Ids=5mA)
    # Vds = 0-2V
    set tmp_x1=0
    set tmp_x2=2
    extract init infile="B_Ids-Vds_MOS_9.log"
    # min()
    extract name="MOSFET_RON_20V" \
        min(curve(v."drain", v."drain"/i."drain", x.min=$tmp_x1 x.max=$tmp_x2) ) \
        datafile="data02_mosRon.txt"
    quit
# MOSFET RON measure



# 体二极管特性
# Ids - Vds diode
    set affin_4HSiC =3.2
    set sch_barrier =1.7
    # barrier of SiC should be 1.2 ~ 1.7
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    go atlas simflags = "-80 -p 8"
    set DEVICE_D = 0.8E2
    mesh infile = ../STR/A_tmp_1.str width=$DEVICE_D
    # width=0.799E6
    extract name="t1" clock.time
    ################ contact ################
    contact all neutral
    contact name=source \
        BARRIER ALPHA=1.0e-7 SURF.REC \
        workfunc=$workfunc_sch
    ################ contact ################
        # models print
        # solve initial
        # output con.band val.band
        # struct outf = ../STR/A_tmp_1_band.str
        # tonyplot ../STR/A_tmp_1_band.str -set ../STR/SET_str_band.set
    ################ contact ################
    # models
    models srh
    models cvt fermidirac
    models conmob
    models fldmob
    models auger
    models optr
    models analytic
    models bgn
    models print
    # method
    # method newton trap maxtrap=10 itlimi=20
    # method climit=1e-4 maxtrap=15 itlimi=20
    method climit=1e-4 maxtrap=15
    #
    # load in temporary files and ramp Vds
    solve init
    solve name=drain vstep=0.2 vfinal=10.0
    solve vgate=-1 outf=solve_tmp1
    solve vgate=-2 outf=solve_tmp2
    solve vgate=-3 outf=solve_tmp3
    solve vgate=-4 outf=solve_tmp4
    solve vgate=-5 outf=solve_tmp5
    load infile=solve_tmp1
    log outfile=B_Ids-Vds_BD_1.log
        solve name=drain vstep=-0.5 vfinal=0
        solve name=drain vstep=-0.1 vfinal=-3.0
        solve name=drain vstep=-0.01 vfinal=-5.0
        solve name=drain vstep=-0.1 vfinal=-10
    load infile=solve_tmp2
    log outfile=B_Ids-Vds_BD_2.log
        solve name=drain vstep=-0.5 vfinal=0
        solve name=drain vstep=-0.1 vfinal=-3.0
        solve name=drain vstep=-0.01 vfinal=-5.0
        solve name=drain vstep=-0.1 vfinal=-10
    load infile=solve_tmp3
    log outfile=B_Ids-Vds_BD_3.log
        solve name=drain vstep=-0.5 vfinal=0
        solve name=drain vstep=-0.1 vfinal=-3.0
        solve name=drain vstep=-0.01 vfinal=-5.0
        solve name=drain vstep=-0.1 vfinal=-10
    load infile=solve_tmp4
    log outfile=B_Ids-Vds_BD_4.log
        solve name=drain vstep=-0.5 vfinal=0
        solve name=drain vstep=-0.1 vfinal=-3.0
        solve name=drain vstep=-0.01 vfinal=-5.0
        solve name=drain vstep=-0.1 vfinal=-10
    load infile=solve_tmp5
    log outfile=B_Ids-Vds_BD_5.log
        solve name=drain vstep=-0.5 vfinal=0
        solve name=drain vstep=-0.1 vfinal=-3.0
        solve name=drain vstep=-0.01 vfinal=-5.0
        solve name=drain vstep=-0.1 vfinal=-10
    # plot
    tonyplot -overlay \
        B_Ids-Vds_BD_1.log \
        B_Ids-Vds_BD_2.log \
        B_Ids-Vds_BD_3.log \
        B_Ids-Vds_BD_4.log \
        B_Ids-Vds_BD_5.log \
        -set SET_log_Ids-Vds_BD_overlay.set
    # time
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# Ids - Vds diode




# Breakdwon
    set affin_4HSiC =3.2
    set sch_barrier =1.5
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    go atlas simflags = "-128 -P 16"
    # mesh infile = ../STR/A_tmp_1.str
    set DEVICE_W = 0.8E2
    mesh infile = ../STR/A_tmp_1.str
    # width=$DEVICE_W
    extract name="t1" clock.time
    ################ contact ################
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC \
        workfunc=$workfunc_sch
    ################ contact ################
    models srh cvt fermidirac
    models conmob
    models fldmob
    models auger
    models analytic
    models optr
    models bgn
    models temperature=300
    models CVT
    models print
    impact selb aniso sic4h0001 e.side
    method itlimit=70 climit=1e-20 \
        ix.tol=1e-38 ir.tol=1e-38 \
        px.tol=1.e-20 pr.tol=1.e-43 \
        cx.tol=1.e-20 cr.tol=1.e-35
    # output flowlines e.mobility h.mobility
    solve init previous
    # log outfile=B_tmp_3.log
    log outfile=B_Ids-Vds_BV_1600V.log
        # 1. first stage
        # solve vdrain=0.001 prev
        # save outfile=A_BV_Vds=0.001V.str
        # solve vdrain=0.01 prev
        # save outfile=A_BV_Vds=0.01V.str
        # solve vfinal=0.1 vstep=0.01 name=drain prev
        # save outfile=A_BV_Vds=0.1V.str
        # solve prev vdrain=0.10
        # 2.
        solve prev vdrain=0.01
        solve prev vdrain=0.1
        solve prev vdrain=1
        solve prev vfinal=100 vstep=20 name=drain
        solve prev vfinal=200 vstep=50 name=drain
        solve prev vfinal=1000 vstep=100 name=drain
        save outfile=A_BV_Vds=1000V.str
        solve prev vfinal=1200 vstep=100 name=drain
        save outfile=A_BV_Vds=1200V.str
        solve prev vfinal=1600 vstep=100 name=drain
        save outfile=A_BV_Vds=1600V.str
    log close
    # tonyplot B_tmp_3.log
    tonyplot B_Ids-Vds_BV_1600V.log -set SET_log_Ids-Vds_Vgs=0_BV.set
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# Breakdwon
tonyplot B_Ids-Vds_BV_1600V.log -set SET_log_Ids-Vds_Vgs=0_BV.set
quit




# Breakdown Electric Field
    set P_w         =1.00
    set N_w         =1.00
    set CH_w        =0.50
    set P_well_w    =$N_w+$P_w+$CH_w
    set JFET_w      =2.5
    set CELL_h      =$P_well_w+$JFET_w
    set CELL        =$CELL_h*2
    set N_plus_1_x1=$P_w
    set N_plus_1_x2=$P_w+$N_w
    set N_plus_2_x1=$CELL-($P_w+$N_w)
    set N_plus_2_x2=$CELL-$P_w
    set tmp_factor=0.25
    set tmp_factor=0.15
    set gate_x1=$N_plus_1_x2-$N_w*$tmp_factor
    set gate_x2=$N_plus_2_x1+$N_w*$tmp_factor
    go atlas
    mesh infile=A_BV_Vds=1200V.str
    extract init infile="A_BV_Vds=1200V.str"


    tonyplot A_BV_Vds=1200V.str -set SET_str_electric_field_cutlines.set

    quit
# Breakdown Electric Field



# PLOT
    tonyplot -overlay B_Ids-Vds_MOS_1.log B_Ids-Vds_MOS_2.log B_Ids-Vds_MOS_3.log B_Ids-Vds_MOS_4.log B_Ids-Vds_MOS_5.log B_Ids-Vds_MOS_6.log B_Ids-Vds_MOS_7.log B_Ids-Vds_MOS_8.log B_Ids-Vds_MOS_9.log B_Ids-Vds_MOS_10.log \
    -set SET_log_Ids-Vds_MOS_overlay.set
    # tonyplot -overlay -st  B_Ids-Vds_BD_1.log B_Ids-Vds_BD_2.log B_Ids-Vds_BD_3.log B_Ids-Vds_BD_4.log B_Ids-Vds_BD_5.log -set SET_log_Ids-Vds_BD_overlay.set
    # tonyplot B_Ids-Vds_BV_1600V.log -set SET_log_Ids-Vds_Vgs=0_BV.set
    # tonyplot A_BV_Vds=1200V.str -set SET_str_electric_field_cutlines.set
    quit
# PLOT


tonyplot -overlay -st \
B_Ids-Vds_BD_1.log \
B_Ids-Vds_BD_2.log \
B_Ids-Vds_BD_3.log \
B_Ids-Vds_BD_4.log \
B_Ids-Vds_BD_5.log \
-set SET_log_Ids-Vds_BD_overlay.set
quit



















#
    # single SBD which can stand BV well
# IV normal forward diode application
    set affin_4HSiC =3.2
    set sch_barrier =2.2
    set sch_barrier =1.7
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    # set workfunc_ohm=0
    go atlas simflags = "-80 -p 8"
    mesh infile = ../STR/A_tmp_2_SBD.str
    ################ contact ################
    contact all neutral
    # contact name=drain neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC \
        workfunc=$workfunc_sch
    contact name=source_ohmic neutral
    ################ contact ################
    extract name="t1" clock.time
    # models
    models srh
    # Specifies Shockley-Read-Hall recombination using fixed lifetimes
    models cvt fermidirac
    # cvt: mobility
    # fermidirac: fermi and dirac statistics
    models conmob
    # cnomb: mobility with respect to concentration
    models fldmob
    # fldmob: mobility with respect to elec field
    models auger
    # Specifies Auger recombination
    models optr
    # Selects the optical recombination model.
    models analytic
    # Specifies an analytic concentration dependent mobility model for silicon which includes temperature dependence
    models bgn
    # Specifies bandgap narrowing model (see Equation 3-46) with Slotboom default values.
    models print
    # method
    # method newton trap maxtrap=5 itlimi=20
    method newton trap maxtrap=5 itlimi=20
    # Ids - Vds Curve
    solve initial previous
    output con.band val.band
    log outfile=B_tmp_1.log
        solve prev initial
        save outfile=A_FW_Vds=-0V.str
        solve vstep=-0.1 vfinal=-3 name=drain
        save outfile=A_FW_Vds=-3V.str
        solve vstep=-0.1 vfinal=-8.0 name=drain
    log close
    tonyplot B_tmp_1.log -set SET_log_Ids-Vds_Vgs=0V.set
    # time
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# IV normal forward diode application














# single SBD which can stand BV well
# Breakdwon
################ TEST ################
go atlas simflags = "-128 -P 16"
    # solving bv
    # Keeping Vgs = 0 for both electrode, and Vdrain goes down from 0 to the minus 1kV
    # Solution for a Vds ramp with Vgs=0.0V to get breakdown
    set affin_4HSiC =3.2
    set sch_barrier =1.20
    set sch_barrier =2.20
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    set workfunc_ohm=0
    mesh infile = ../STR/A_tmp_2_SBD.str
    ################ contact ################
    contact all neutral
    # contact name=drain neutral
    # contact name=source_ohmic neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC \
        workfunc=$workfunc_sch
    ################ contact ################
    extract name="t1" clock.time
    #
    models srh
    # srh: recombination of Schottky Read Hall
    models cvt fermidirac
    # cvt: mobility
    # fermidirac: fermi and dirac statistics
    models conmob
    # cnomb: mobility with respect to concentration
    models fldmob
    # fldmob: mobility with respect to elec field
    models auger
    # Specifies Auger recombination
    models analytic
    # Specifies an analytic concentration dependent mobility model for silicon which includes temperature dependence
    models optr
    # Selects the optical recombination model. When this parameter is specified, the COPT parameter of the MATERIAL statement should be specified
    models bgn
    # Specifies bandgap narrowing model (see Equation 3-46) with Slotboom default values.
    models temperature=300
    # models temp=300 CVT
    models CVT
    # Specifies that the CVT transverse field dependent mobility model is used for the simulation. The alias for this parameter is LSMMOB.
    models print
    #
    impact selb aniso sic4h0001 e.side
    #
    solve init previous
    # method newton trap maxtrap=10
    method itlimit=70 climit=1e-20 \
        ix.tol=1e-38 ir.tol=1e-38 \
        px.tol=1.e-20 pr.tol=1.e-43 \
        cx.tol=1.e-20 cr.tol=1.e-35

    # output flowlines e.mobility h.mobility
    solve init previous
    log outfile=B_tmp_3_SBD.log
        solve vdrain=0.001 prev
        save outfile=A_BV_Vds=0.001V.str
        solve vdrain=0.01 prev
        save outfile=A_BV_Vds=0.01V.str
        solve vfinal=0.1 vstep=0.01 name=drain prev
        save outfile=A_BV_Vds=0.1V.str
        solve prev vdrain=0.10
        # solve vdrain=1
        # solve prev vfinal=100 vstep=20 name=drain
        # solve prev vfinal=200 vstep=50 name=drain
        # solve prev vfinal=1000 vstep=100 name=drain
        # save outfile=A_BV_Vds=1000V.str
        # solve prev vfinal=1200 vstep=100 name=drain
        # save outfile=A_BV_Vds=1200V.str
        # solve prev vfinal=1600 vstep=100 name=drain
        # save outfile=A_BV_Vds=1600V.str
    log close
    # tonyplot B_tmp_3.log -set SET_log_Ids-Vds_Vgs=0_BV.set
    tonyplot B_tmp_3_SBD.log -set SET_log_Ids-Vds_Vgs=0_BV.set
    tonyplot A_BV_Vds=0.001V.str    -set SET_str_elec.set






    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
quit
# Breakdwon

tonyplot A_BV_Vds=0.001V.str    -set SET_str_curr.set
tonyplot A_BV_Vds=0.01V.str     -set SET_str_curr.set
tonyplot A_BV_Vds=0.1V.str      -set SET_str_curr.set
tonyplot A_BV_Vds=0.001V.str    -set SET_str_elec.set
# tonyplot A_BV_Vds=0.01V.str     -set SET_str_curr.set
# tonyplot A_BV_Vds=0.1V.str      -set SET_str_curr.set










# tonyplot B_tmp_2.log -set SET_log_Vds=0.1_Ids-Vgs.set
# tonyplot B_tmp_3.log -set SET_log_BV.set
quit










# CONTACT
    set affin_4HSiC =3.2
    set sch_barrier =1.7
    # barrier of SiC should be 1.2 ~ 1.7
    set workfunc_drain=0
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    set workfunc_ohm=0
    go atlas
    mesh infile = ../STR/A_tmp_1.str
    ################ contact ################
    contact all neutral
    contact name=drain neutral
    contact name=drain BARRIER ALPHA=1.0e-7 SURF.REC \
        workfunc=$workfunc_drain
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC \
        workfunc=$workfunc_sch
    contact name=source_ohmic neutral
    ################ contact ################
    models print
    solve initial
    output con.band val.band
    # struct outf = ../STR/A_tmp_1_band.str
    # tonyplot B_tmp_2.str -set SET_str_band.set
    quit
# CONTACT
    set DEVICE_W = 0.8E2
    go atlas simflags = "-80 -p 8"
    mesh infile = ../STR/A_tmp_1.str \
        width=$DEVICE_W
        # width=0.799E6















# Plot
    # tonyplot -overlay -st mos1ex02_1.log  mos1ex02_2.log mos1ex02_3.log -set mos1ex02_1.set
# Plot