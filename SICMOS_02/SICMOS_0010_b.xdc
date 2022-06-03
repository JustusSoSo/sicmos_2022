################ SIMULATION TEST ################
# 转移特性
# Threshold simulation
    go atlas simflags = "-80 -p 4"
    set DEVICE_D    =0.8E2
    set DEVICE_W    =10
    set DEVICE_AREA =$DEVICE_D * $DEVICE_W * 1e-8
    # set DEVICE_W    =10
    mesh infile = ../STR/A_tmp_1.str width=$DEVICE_D
    ################ contact ################
    contact all neutral
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
    # solve Vsource=0
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



# 4.9V 80um
# MOSFET输出特性
# Ids - Vds diode
    go atlas simflags = "-80 -p 8"
    set DEVICE_D    =0.8E2
    set DEVICE_W    =10
    set DEVICE_AREA =$DEVICE_D * $DEVICE_W * 1e-8
    mesh infile = ../STR/A_tmp_1.str width=$DEVICE_D
    extract name="t1" clock.time
    ################ contact ################
    contact all neutral
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
    # method newton trap maxtrap=5 itlimi=20
    # method newton trap maxtrap=15
    # method newton trap maxtrap=5 itlimi=20
    # method newton trap maxtrap=10 itlimi=20
    # method climit=1e-4 maxtrap=15 itlimi=20
    method climit=1e-4 maxtrap=15
    # load in temporary files and ramp Vds
    set VDS_final   =50
    set VDS_step    =0.25
    solve init
    solve vdrain=-1
    solve vgate=0  outf     =A_solve_tmp1
    solve vgate=5  outf     =A_solve_tmp2
    solve vgate=10 outf     =A_solve_tmp3
    solve vgate=15 outf     =A_solve_tmp4
    solve vgate=20 outf     =A_solve_tmp5
    load infile         =A_solve_tmp1
    log outfile=B_Ids-Vds_MOS_1.log
    solve name=drain vstep=$VDS_step vfinal=$VDS_final
    load infile         =A_solve_tmp2
    log outfile=B_Ids-Vds_MOS_2.log
    solve name=drain vstep=$VDS_step vfinal=$VDS_final
    load infile         =A_solve_tmp3
    log outfile=B_Ids-Vds_MOS_3.log
    solve name=drain vstep=$VDS_step vfinal=$VDS_final
    load infile         =A_solve_tmp4
    log outfile=B_Ids-Vds_MOS_4.log
    solve name=drain vstep=$VDS_step vfinal=$VDS_final
    load infile         =A_solve_tmp5
    log outfile=B_Ids-Vds_MOS_5.log
    solve name=drain vstep=$VDS_step vfinal=$VDS_final
    # PLOT
    tonyplot -overlay \
        B_Ids-Vds_MOS_1.log \
        B_Ids-Vds_MOS_2.log \
        B_Ids-Vds_MOS_3.log \
        B_Ids-Vds_MOS_4.log \
        B_Ids-Vds_MOS_5.log \
        -set SET_log_Ids-Vds_MOS_overlay.set
    set tmp_x1=0
    set tmp_x2=2
    # Vgs = 20V extract 0-2V
    extract init infile="B_Ids-Vds_MOS_5.log"
    extract name="MOS_20V_Ronsp" min(v."drain"/i."drain") \
        * 1e3 * $DEVICE_AREA \
        datafile="data02_ronsp.txt"
    # PLOT


    # time
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# Ids - Vds diode
# MOSFET RON measure
    # Ron（Vgs=20V,Vds=2V)
    # Vth(Ids=5mA)
    # Vds = 0-2V
    set DEVICE_D    =0.8E2
    set DEVICE_W    =10
    set DEVICE_AREA =$DEVICE_D * $DEVICE_W * 1e-8


    set tmp_x1=0
    set tmp_x2=2
    extract init infile="B_Ids-Vds_MOS_9.log"
    extract name="MOS_20V_Ronsp" min(v."drain"/i."drain") \
        * 1e3 * $DEVICE_AREA \
        datafile="data02_Ron.txt"
    quit
# MOSFET RON measure



# 体二极管特性
# Ids - Vds diode
    go atlas simflags = "-80 -p 8"
    set DEVICE_D = 0.8E2
    mesh infile = ../STR/A_tmp_1.str width=$DEVICE_D
    extract name="t1" clock.time
    ################ contact ################
    contact all neutral
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
    tonyplot -overlay -st \
        B_Ids-Vds_BD_1.log \
        B_Ids-Vds_BD_2.log \
        B_Ids-Vds_BD_3.log \
        B_Ids-Vds_BD_4.log \
        B_Ids-Vds_BD_5.log \
        -set SET_log_Ids-Vds_BD.set
    # time
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# Ids - Vds diode




# Breakdwon
    go atlas simflags = "-128 -P 16"
    # mesh infile = ../STR/A_tmp_1.str
    set DEVICE_W = 0.8E2
    mesh infile = ../STR/A_tmp_1.str
    # width=$DEVICE_W
    extract name="t1" clock.time
    ################ contact ################
    contact all neutral
    ################ contact ################
    extract name="t1" clock.time
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
        # itlimit
            # Specifies the maximum number of allowed outer loops (Newton loops or Gummel continuity iterations).
        # climit
            # Specifies a concentration normalization factor. See “Carrier Concentrations and CLIM.DD (CLIMIT)” on page 1012 for a complete description.
        # ix.tol
            # Specifies relative current convergence criteria.
        # ir.tol
            # Specifies absolute current convergence criteria



    # output flowlines e.mobility h.mobility
    solve init previous
    # log outfile=B_tmp_3.log
    log outfile=B_Ids-Vds_Vgs=BV_1600V.log
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


# Extract the gate oxide thickness...
    extract name="gate ox" thickness oxide mat.occno=1
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




























tonyplot B_tmp_1.log -set SET_log_Vgs=0_Ids-Vds.set
# find MAX derivative
    # This further example calculates to the 2nd derivative.
    # extract name="dydx2" deriv(v."gate", i."drain", 2)
    # extract name="Second_Derivative" \
    #     max(deriv(i."drain", v."drain", 2)) \
    #     outfile="temp.dat"

tonyplot B_tmp_1.log -set SET_log_Vgs=0_Ids-Vds.set
extract init infile="B_tmp_1.log"
# extract name="d2V/dI2" \
#     max(deriv(v."drain", i."drain", 2)) \
#     outfile="temp.dat"
extract name="d2V/dI2" \
    max(deriv(v."drain", i."drain", 2)) \
    outfile="B_tmp_11.log"
extract init infile="B_tmp_11.log"
tonyplot B_tmp_11.log
# x.val from curve("dydx 2","drain bias")
# extract name="VTurn-On" max(y.val)
quit

# find MAX of something and give the x or y there
    # The following command creates a collector current against collector current divided by base current curve and calculates the intercepting collector current where Ic/Ib is at a maximum value.
    # extract name="Ic at Ic/Ib[Max]" x.val from curve(i."collector", i."collector"/i."base") where y.val=max(i."collector"/i."base")
    # extract name="VTurn-On" \
    #     x.val from curve \
    #     (i."drain", i."drain"/v."drain") \
    #     where y.val=max(i."drain"/v."drain")
# find MAX of something and give the x or y there
################
################