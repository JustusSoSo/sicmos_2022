################ STRUCTURE ################
# SET
    set N_sub       =1e19
    ######## Modified ########
    set N_drift     =3e15
    set N_drift     =9e15
    ######## Modified ########
    # set P_well      =10e17
    set P_well      =5e17
    ######## Modified ########
    set P_plus      =1e19
    set N_plus      =1e19
    ######## Modified ########
    set P_ch        =1e16
    set P_ch_t      =0.1
    ##############################
    set SCH_w       =0.50
    #
    set P_w         =1.00
    set N_w         =1.00
    set CH_w        =1.00
    set P_well_w    =$N_w+$P_w+$CH_w
    ######## Modified ########
    set JFET_w      =1.5
    ######## Modified ########
    set CELL_h      =$SCH_w+$P_well_w+$JFET_w
    set CELL        =$CELL_h*2
    ######################
    set source_t    =4
    # interlayer dielectric
    set ILD_t       =1.0
    set gate_t      =0.5
    ######## 1. threshold ########
    set gate_oxide_t=0.05
    ######## Modified ########
    set P_t         =0.5
    set N_t         =$P_t
    ######## Modified ########
    # set P_well_t    =3.0
    set P_well_t    =1.5
    set P_well_t    =2.0
    ######## 2.BV ########
    set N_drift_t   =10.0
    ######################
    set N_sub_t     =1.0
    set drain_t     =1.0
    ######################
    set DEVICE_W    =$CELL
    set DEVICE_D    =0.3E6
    # the area is 10um x 0.6m = 3mm2
    set DEVICE_A    =$DEVICE_D*$DEVICE_W*1e-8
# SET
######################
# Drain and Sub
    go DevEdit
    set area_y1=0-$source_t
    set area_y2=$N_drift_t+$N_sub_t+$drain_t
    work.area x1=0 x2=@cell \
        y1=@area_y1 y2=@area_y2
    # drain elec
    # sub of N plus region
    set tmp_y1=@N_drift_t+@N_sub_t
    set tmp_y2=@N_drift_t+@N_sub_t+@drain_t
    region reg=1 name=drain mat=Aluminum \
        elec.id=1 work.func=0 \
        polygon="0,@tmp_y1 @CELL,@tmp_y1 @CELL,@tmp_y2 0,@tmp_y2"
    set tmp_y1=@N_drift_t
    set tmp_y2=@N_drift_t+@N_sub_t
    region reg=2 name=N_substrate mat=4H-SiC \
        polygon="0,@tmp_y1 $CELL,@tmp_y1 $CELL,@tmp_y2 0,@tmp_y2"
        impurity id=1 reg.id=2 imp=Phosphorus \
            peak.value=$N_sub ref.value=$N_sub comb.func=Multiply
    # sub of N plus region
# Drain and Sub

# N- drift
    region reg=3 name=N_drift mat=4H-SiC \
        polygon="0,0 $CELL,0 $CELL,$N_drift_t 0,$N_drift_t"
    impurity id=1 reg.id=3 imp=Phosphorus \
        peak.value=$N_drift ref.value=$N_drift comb.func=Multiply
#### containing some else impurities ####
    # set P_well_1_x1=0
    set P_well_1_x1=$SCH_w
    set P_well_1_x2=$P_well_1_x1+$P_well_w
    set P_well_2_x1=$CELL-$P_well_1_x2
    set P_well_2_x2=$CELL-$P_well_1_x1
    # P well under P Channel part 1
    # under the plus region
    set tmp_conc_param_x=0.01
    set tmp_conc_param_y=0.05
    impurity id=11 reg.id=3 imp=Boron \
        peak.value=$P_well ref.value=$P_well comb.func=Multiply \
        x1=$P_well_1_x1 x2=$P_well_1_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=$P_t y2=$P_well_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y
    impurity id=12 reg.id=3 imp=Boron \
        peak.value=$P_well ref.value=$P_well comb.func=Multiply \
        x1=$P_well_2_x1 x2=$P_well_2_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=$P_t y2=$P_well_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y

    set P_CH_1_x1=$P_well_1_x2-$CH_w
    # CELL_h-$JFET_w-$CH_w
    set P_CH_1_x2=$P_well_1_x2
    set P_CH_2_x1=$CELL-$P_CH_1_x2
    set P_CH_2_x2=$CELL-$P_CH_1_x1
    # Channel of P type
    # CH1
    set tmp_conc_param_x=0.01
    set tmp_conc_param_y=0.01
    impurity id=21 reg.id=3 imp=Boron \
        peak.value=$P_ch ref.value=$P_ch comb.func=Multiply \
        x1=$P_CH_1_x1 \
        x2=$P_CH_1_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=0 \
        y2=$P_ch_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y
    # CH2
    impurity id=22 reg.id=3 imp=Boron \
        peak.value=$P_ch ref.value=$P_ch comb.func=Multiply \
        x1=$P_CH_2_x1 \
        x2=$P_CH_2_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=0 \
        y2=$P_ch_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y

    # P well under P Channel part 2
    set tmp_conc_param_x=0.01
    set tmp_conc_param_y=0.01
    impurity id=13 reg.id=3 imp=Boron \
        peak.value=$P_well ref.value=$P_well comb.func=Multiply \
        x1=$P_CH_1_x1 \
        x2=$P_CH_1_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=$P_ch_t y2=$P_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y
    impurity id=14 reg.id=3 imp=Boron \
        peak.value=$P_well ref.value=$P_well comb.func=Multiply \
        x1=$P_CH_2_x1 \
        x2=$P_CH_2_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=$P_ch_t y2=$P_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y

    # P plus pair, noting ref.value is N drift
    # P plus pair
    set P_plus_1_x1=0+$SCH_w
    set P_plus_1_x2=$P_plus_1_x1+$P_w
    set P_plus_2_x1=$CELL-$P_plus_1_x2
    set P_plus_2_x2=$CELL-$P_plus_1_x1
    set tmp_conc_param=0.02
    set tmp_conc_param=0.05
    set tmp_conc_param_x=0.01
    set tmp_conc_param_y=0.10
    impurity id=31 reg.id=3 imp=Boron \
        peak.value=$P_plus ref.value=$N_drift \
        comb.func=Multiply \
        x1=$P_plus_1_x1 x2=$P_plus_1_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=0 \
        y2=$P_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y
    impurity id=32 reg.id=3 imp=Boron \
        peak.value=$P_plus ref.value=$N_drift \
        comb.func=Multiply \
        x1=$P_plus_2_x1 x2=$P_plus_2_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=0 \
        y2=$P_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y

    # N plus pair, noting ref.value is N drift
    set N_plus_1_x1 = $P_plus_1_x2
    set N_plus_1_x2 = $N_plus_1_x1+$N_w
    set N_plus_2_x1 = $CELL-$N_plus_1_x2
    set N_plus_2_x2 = $CELL-$N_plus_1_x1
    set tmp_conc_param_x=0.01
    set tmp_conc_param_y=0.10
    impurity id=33 reg.id=3 imp=Phosphorus \
        peak.value=$N_plus ref.value=$N_drift \
        comb.func=Multiply \
        x1=$N_plus_1_x1 \
        x2=$N_plus_1_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=0 \
        y2=$N_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y
    impurity id=34 reg.id=3 imp=Phosphorus \
        peak.value=$N_plus ref.value=$N_drift \
        comb.func=Multiply \
        x1=$N_plus_2_x1 \
        x2=$N_plus_2_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=0 \
        y2=$N_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y

#### containing some else impurities ####
# N- drift

# Source Contact the upper source metal
    # ILD oxide
    # set tmp_factor=0
    set tmp_factor=0.50
    set oxide_x1=$N_plus_1_x1+$N_w*$tmp_factor
    set oxide_x2=$N_plus_2_x2-$N_w*$tmp_factor
    set oxide_y1=0
    set oxide_y2=0-($ILD_t+$gate_t+$gate_oxide_t)
    # gate
    set tmp_factor=0.15
    set gate_y1=0-($gate_oxide_t+$gate_t)
    set gate_y2=0-($gate_oxide_t)
    set gate_x1=$N_plus_1_x2-$N_w*$tmp_factor
    set gate_x2=$N_plus_2_x1+$N_w*$tmp_factor
    # metal source schottky over the oxide
    set sch_x1=0
    set sch_x2=$SCH_w+0.1
    set sch_x3=$CELL-$sch_x2
    set sch_x4=$CELL
    # Schottky Source
    region reg=20 name=source mat=Aluminum elec.id=3 work.func=0 \
        polygon="0,0 $CELL,0 $CELL,$area_y1 0,$area_y1"
    set ohm_x1=$sch_x2
    set ohm_x2=$sch_x3
    region reg=21 name=source_ohmic mat=Aluminum elec.id=4 work.func=0 \
            polygon="$ohm_x1,0 \
            $ohm_x2,0 \
            $ohm_x2,$oxide_y2 \
            $ohm_x1,$oxide_y2"
    # Oxide: Gate oxide and ILD
    region reg=31 name=oxide mat=SiO2 \
        polygon="@oxide_x1,0 @oxide_x2,0 @oxide_x2,@oxide_y2 @oxide_x1,@oxide_y2"
    # Gate metal
    region reg=32 name=gate mat=Aluminum elec.id=2 work.func=0 \
        polygon="@gate_x1,@gate_y1 @gate_x2,@gate_y1 @gate_x2,@gate_y2 @gate_x1,@gate_y2"
    # set oxide_y1=0
    # set oxide_y2=0-($ILD_t+$gate_t+$gate_oxide_t)
    set oxide_ohm1_x1=$sch_x2-0.1
    set oxide_ohm1_x2=$sch_x2+0.1
    set oxide_ohm2_x1=$sch_x3-0.1
    set oxide_ohm2_x2=$sch_x3+0.1
    # region reg=41 name=oxide_ohm1 mat=SiO2 \
    #     polygon="@oxide_ohm1_x1, 0 \
    #     @oxide_ohm1_x2, 0 \
    #     @oxide_ohm1_x2, @oxide_y2 \
    #     @oxide_ohm1_x1, @oxide_y2"
    # region reg=42 name=oxide_ohm2 mat=SiO2 \
    #     polygon="@oxide_ohm2_x1, 0 \
    #     @oxide_ohm2_x2, 0 \
    #     @oxide_ohm2_x2, @oxide_y2 \
    #     @oxide_ohm2_x1, @oxide_y2"
# Source Contact the upper source metal

#### set Meshing Parameters ####
    base.mesh height=1 width=1
    bound.cond !apply max.slope=30 max.ratio=10 rnd.unit=1E-6 line.straightening=1 align.points when=automatic
    imp.refine imp=netdoping scale=log min.spacing=0.04 sensitivity=0.2 transition=1E10
    # global constraints
    constr.mesh max.angle=90 max.ratio=300
    # region specific constraints
        # from top source to the bottom P well
        set tmp_y1=0-($source_t - $ILD_t)
        set tmp_constr_param_x=0.2
        set tmp_constr_param_y=0.2
        constr.mesh id=1 x1=0 x2=$CELL \
            y1=$tmp_y1 \
            y2=$P_well_t \
            default \
            max.width=$tmp_constr_param_x \
            max.height=$tmp_constr_param_y

        # at the vicinity of the interface of Gate oxide and Semiconductor y=0
        set tmp_delta=0.020
        set tmp_y1=0-$tmp_delta
        set tmp_y2=0+$tmp_delta
        set tmp_constr_param_x=0.1
        set tmp_constr_param_y=0.01
        constr.mesh id=21 x1=0 x2=$CELL \
            y1=$tmp_y1 y2=$tmp_y2 default \
            max.width=$tmp_constr_param_x \
            max.height=$tmp_constr_param_y
        # from the bottom P well to the bottom drain
        set tmp_delta = 1.0
        set tmp_y2=$N_drift_t+$N_sub_t+$drain_t
        set tmp_y1=$tmp_y2 - $tmp_delta
        set tmp_constr_param_x=1.0
        set tmp_constr_param_y=0.2
        constr.mesh id=22 \
        x1=0 x2=@cell y1=$tmp_y1 y2=$tmp_y2 \
        default \
        max.width=$tmp_constr_param_x \
        max.height=$tmp_constr_param_y
    # region specific constraints
    mesh mode=meshbuild
#### set Meshing Parameters ####

# interval
    struct outf = A_tmp_1.str
    tonyplot A_tmp_1.str -set SET_str.set
# interval

# modified
set sch_barrier =1.7
# 1. Transfer or transconductance
# Threshold simulation
    go atlas simflags = "-80 -p 8"
    mesh infile = A_tmp_1.str width=0.3E6
    extract name="t1" clock.time
    ################ contact ################
    set affin_4HSiC =3.2
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC workfunc=$workfunc_sch
    ################ contact ################
    mobility material=4H-SiC KN.CVT=2.35 N.LCRIT=1E-6
    models CVT
    models analytic
    models conmob
    models fldmob
    models srh
    models auger
    models fermidirac
    models optr
    models bgn
    models print
    method newton trap maxtrap=15
    solve init
    solve Vdrain=0.1 prev
    ################ LOGGING ################
    log outf=B_Ids-Vgs_Vds=0.1V.log
    solve Vgate=0 vstep=0.25 vfinal=20 name=gate
    log close
    tonyplot B_Ids-Vgs_Vds=0.1V.log -set SET_log_Ids-Vgs_Vds=0.1V.set
    extract init infile="B_Ids-Vgs_Vds=0.1V.log"
    extract name="Vthreshold" \
    (xintercept(maxslope(curve(abs(v."gate"),abs(i."drain")))) - abs(ave(v."drain"))/2.0) \
    datafile="data01_vth.txt"
    # PLOT
# Threshold simulation

# 2. MOSFET output IV
# Ids - Vds diode
    go atlas simflags = "-80 -p 16"
    mesh infile = A_tmp_1.str width=0.3E6
    ################ contact ################
    set affin_4HSiC =3.2
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC workfunc=$workfunc_sch
    ################ contact ################
    mobility material=4H-SiC KN.CVT=2.35 N.LCRIT=1E-6
    models CVT analytic conmob fldmob srh auger fermidirac optr bgn
    models print
    method climit=1e-4 maxtrap=15
    # load in temporary files and ramp Vds
    solve init
    set VDS_final   =50
    solve vgate=0  outf     =A_solve_tmp1
    solve vgate=5  outf     =A_solve_tmp2
    solve vgate=10 outf     =A_solve_tmp3
    solve vgate=15 outf     =A_solve_tmp4
    solve vgate=20 outf     =A_solve_tmp5
    load infile         =A_solve_tmp1
    log outfile=B_Ids-Vds_MOS_1.log
    solve name=drain vstep=0.2  vfinal=5
    solve name=drain vstep=1    vfinal=$VDS_final
    load infile         =A_solve_tmp2
    log outfile=B_Ids-Vds_MOS_2.log
    solve name=drain vstep=0.2  vfinal=5
    solve name=drain vstep=1    vfinal=$VDS_final
    load infile         =A_solve_tmp3
    log outfile=B_Ids-Vds_MOS_3.log
    solve name=drain vstep=0.2  vfinal=5
    solve name=drain vstep=1    vfinal=$VDS_final
    load infile         =A_solve_tmp4
    log outfile=B_Ids-Vds_MOS_4.log
    solve name=drain vstep=0.2  vfinal=5
    solve name=drain vstep=1    vfinal=$VDS_final
    load infile         =A_solve_tmp5
    log outfile=B_Ids-Vds_MOS_5.log
    solve name=drain vstep=0.2  vfinal=5
    solve name=drain vstep=1    vfinal=$VDS_final
    # PLOT
    tonyplot -overlay -st \
    B_Ids-Vds_MOS_1.log \
    B_Ids-Vds_MOS_2.log \
    B_Ids-Vds_MOS_3.log \
    B_Ids-Vds_MOS_4.log \
    B_Ids-Vds_MOS_5.log \
    -set SET_log_Ids-Vds_MOS_overlay.set
    # Ron（Vgs=20V,Vds=2V) Vds = 0-2V
    set tmp_x1=1
    set tmp_x2=5
    extract init infile="B_Ids-Vds_MOS_5.log"
    extract name="Ronsp_20V" \
    min(curve(v."drain", v."drain"/i."drain", x.min=$tmp_x1 x.max=$tmp_x2)) \
    * 1e3 * $DEVICE_A \
    datafile="data02_ronsp.txt"
    # time
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# Ids - Vds diode



set sch_barrier =1.7
# 3. MOSFET Body Diode
# Body Drain diode characteristic
    go atlas simflags = "-80 -p 4"
    mesh infile = A_tmp_1.str width=0.3E6
    ################ contact ################
    set affin_4HSiC =3.2
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC workfunc=$workfunc_sch
    contact name=drain resist=5e03
    # Specifies a lumped resistance value Ohm um
    mobility material=4H-SiC KN.CVT=2.35 N.LCRIT=1E-6
    ################ contact ################
    models CVT analytic
    models srh fermidirac
    models conmob fldmob
    models auger optr bgn
    models print
    method newton trap maxtrap=15
    solve init
    solve vgate=-0 outf =A_solve_tmp1
    solve vgate=-3 outf =A_solve_tmp2
    solve vgate=-5 outf =A_solve_tmp3

    # tmp1
    load infile=A_solve_tmp1
    log outfile=B_Ids-Vds_BD_1.log
    solve name=drain vstep=-0.05 vfinal=-3.0
    solve name=drain vstep=-0.01 vfinal=-3.2
    # tmp2
    load infile=A_solve_tmp2
    log outfile=B_Ids-Vds_BD_2.log
    solve name=drain vstep=-0.05 vfinal=-3.0
    solve name=drain vstep=-0.01 vfinal=-3.2

    # tmp3
    load infile=A_solve_tmp3
    log outfile=B_Ids-Vds_BD_3.log
    solve name=drain vstep=-0.05 vfinal=-3.0
    solve name=drain vstep=-0.01 vfinal=-3.2
    # solve name=drain vstep=-0.01 vfinal=-1.35
    # save outfile=C_Body_Diode_Vds=-1.35.str
    # solve name=drain vstep=-0.01 vfinal=-3.01
    # save outfile=C_Body_Diode_Vds=-3.01.str
    # solve name=drain vstep=-0.01 vfinal=-3.20
    # save outfile=C_Body_Diode_Vds=-3.20.str
    tonyplot -overlay -st \
    B_Ids-Vds_BD_1.log \
    B_Ids-Vds_BD_2.log \
    B_Ids-Vds_BD_3.log \
    -set SET_log_Ids-Vds_BD_overlay.set
    extract init inf="B_Ids-Vds_BD_3.log"
    extract name="Von-Body-diode" x.val from curve (abs(v."drain") ,abs(i."drain"))  \
    where y.val=0.1 \
    datafile="data03_BD.txt"
    quit
# Body Drain diode characteristic



set sch_barrier =1.7
# 4.BV
# Breakdwon Voltage
    go atlas simflags = "-128 -P 16"
    mesh infile = A_tmp_1.str width=0.3E6
    extract name="t1" clock.time
    ################ contact ################
    set affin_4HSiC =3.2
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC workfunc=$workfunc_sch
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
    log outfile=B_Ids-Vds_Vgs=0V_BV.log
        solve prev vdrain=0.001
        save outfile=C_BV_Vds=0.001V.str
        solve prev vdrain=0.01
        save outfile=C_BV_Vds=0.01V.str
        solve prev vdrain=0.1
        save outfile=C_BV_Vds=0.1V.str
        solve prev vdrain=1
        save outfile=C_BV_Vds=1V.str
        #
        solve prev vfinal=100 vstep=20 name=drain
        save outfile=C_BV_Vds=100V.str
        solve prev vfinal=200 vstep=50 name=drain
        save outfile=C_BV_Vds=200V.str
        solve prev vfinal=1200 vstep=100 name=drain
        save outfile=C_BV_Vds=1200V.str
        solve prev vfinal=1600 vstep=100 name=drain
        save outfile=C_BV_Vds=1600V.str
        solve prev vfinal=1800 vstep=100 name=drain
        save outfile=C_BV_Vds=1800V.str
    log close
    tonyplot B_Ids-Vds_Vgs=0V_BV.log \
    -set SET_log_Ids-Vds_Vgs=0_BV.set
    # time
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# Breakdwon Voltage
extract init inf="B_Ids-Vds_Vgs=0V_BV.log"
extract name="BV" x.val from curve (abs(v."drain") ,abs(i."drain")) where y.val=1e-22 \
    datafile="data04_BV.txt"
quit
# 1603

# PLOT
    tonyplot B_Ids-Vgs_Vds=0.1V.log -set SET_log_Ids-Vgs_Vds=0.1V.set
    tonyplot -overlay -st \
    B_Ids-Vds_MOS_1.log \
    B_Ids-Vds_MOS_2.log \
    B_Ids-Vds_MOS_3.log \
    B_Ids-Vds_MOS_4.log \
    B_Ids-Vds_MOS_5.log \
    -set SET_log_Ids-Vds_MOS_overlay.set
    tonyplot -overlay -st \
    B_Ids-Vds_BD_1.log \
    B_Ids-Vds_BD_2.log \
    B_Ids-Vds_BD_3.log \
    -set SET_log_Ids-Vds_BD_overlay.set
    # tonyplot B_Ids-Vds_Vgs=0V_BV.log \
    # -set SET_log_Ids-Vds_Vgs=0_BV.set
    quit
# PLOT

set sch_barrier =1.7
# 5. CV
# Capacitances simulation
    go atlas simflags = "-128 -P 16"
    mesh infile = A_tmp_1.str width=0.3E6
    extract name="t1" clock.time
    ################ contact ################
    set affin_4HSiC =3.2
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC workfunc=$workfunc_sch
    mobility material=4H-SiC KN.CVT=2.35 N.LCRIT=1E-6
    ################ contact ################
    models consrh
    models cvt fermidirac
    models print
    # DS Capacitance
    # Cds
    # Cgs
    # Cgd
    method newton trap
    set freq_tmp=1e6
    solve init
    log outfile = B_Cds-Vds_f=1MHz.log
    solve vstep=0.2 vfinal=4 name=drain ac  freq=$freq_tmp
    solve vstep=1 vfinal=15 name=drain ac   freq=$freq_tmp
    solve vstep=5 vfinal=50 name=drain ac   freq=$freq_tmp
    solve vstep=10 vfinal=100 name=drain ac freq=$freq_tmp
    solve vstep=50 vfinal=200 name=drain ac freq=$freq_tmp
    solve vstep=100 vfinal=1200 name=drain ac freq=$freq_tmp
    tonyplot B_Cds-Vds_f=1MHz.log \
    -set SET_log_Cds-Vds.set
    # time
    extract name="t2" clock.time
    extract name="Elapsed_second_01" $t2 - $t1
    extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
    quit
# Capacitances simulation




set sch_barrier =1.7
# 6. transient
# Transient Response
    go atlas
    mesh infile = A_tmp_1.str width=0.3E6
    ################ contact ################
    set affin_4HSiC =3.2
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC workfunc=$workfunc_sch
    mobility material=4H-SiC KN.CVT=2.35 N.LCRIT=1E-6
    save outfile=A_tmp_2.str
    ################ contact ################
    go atlas simflags="-P 16"
    # BEGIN of the circuit
    .begin
        # voltage source
            # Keyword is PWL waveform
            # 0             0V
            # 1us           0V
            # 1us+0.01us    20V
            # 22.51us       20V
            # 22.52us       0V
            # 24us          0V
            # 24us+0.01us   20V
            # 26us          20V
            # 26us+0.01us   0V
            # 27us          0V

        # node 1 and 0
        Vinput 1 0 pwl 0 0  10e-6 0  10.01e-6 20  22.51e-6 20  22.52e-6 0  24e-6 0  24.01e-6 20  26e-6 20  26.01e-6 0  27e-6 0

        # MOSFET 1
        # node 3 - drain
        # node 2 - gate
        # node 0 - source
        Amos1 0=source 2=gate 3=drain infile=A_tmp_2.str width=0.3E6

        # Resistance gate#1 20ohm
        # node 1 and node 2
        Rg1 1 2 20

        # MOSFET 2
        # node 4 - drain
        # node 6 - gate
        # node 3 - source
        Amos2 3=source 6=gate 4=drain infile=A_tmp_2.str width=0.3E6

        # R gate#2 20ohm
        # node 5 and 6
        Rg2 5 6 20

        # VDC2
        # node 5 3
        Vgs2 5 3 -5

        # Capacitor 42.3miuF
        # node 4 and 0
        C  4 0 42.3u

        # VDD voltage source DC 800V
        # node 4 and 0
        # 800Volts
        VDD 4 0 800

        # inductance 1mH
        # node 4 and 3
        L1 4 3 1mH
        #
        .numeric lte=0.3 toltr=1.e-4 vchange=2 IMAXDC=1000
        .options print relpot write=300
        # save time
        .save tsave=22.5us
        .save tsave=22.515us
        .save tsave=23us
        .save tsave=24.005us
        .save tsave=25us
        # log
        .log outfile=B_SICMOS01
        # save simulation result
        .save master=C_SICMOS01_FWD
        # which transient analysis to be performed
        # step = 50 ns
        # final = 28 us
        .tran 50ns 28us
    .end
    # END of the circuit
    # solve
    models device=amos1 temp=300 CVT analytic conmob fldmob srh auger fermi optr bgn print
    models device=amos2 temp=300 CVT analytic conmob fldmob srh auger fermi optr bgn print
    impact device=amos1 selb gradqfl
    impact device=amos2 selb gradqfl
    #
    go atlas
    tonyplot B_SICMOS01_tr.log-set SET_log_trans_01.set
    quit
# Transient Response
tonyplot B_SICMOS01_tr.log -set SET_log_tr_MOS2_OFF.set
tonyplot B_SICMOS01_tr.log -set SET_log_tr_MOS1_ON.set
tonyplot B_SICMOS01_tr.log -set SET_log_tr_MOS1_OFF.set
quit
# PLOT














set sch_barrier =1.7
# Plot MOSFET Body Diode
# Body Drain diode characteristic
    go atlas simflags = "-80 -p 4"
    mesh infile = A_tmp_1.str width=0.3E6
    ################ contact ################
    set affin_4HSiC =3.2
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC workfunc=$workfunc_sch
    contact name=drain resist=5e03
    # Specifies a lumped resistance value Ohm um
    mobility material=4H-SiC KN.CVT=2.35 N.LCRIT=1E-6
    ################ contact ################
    models CVT analytic
    models srh fermidirac
    models conmob fldmob
    models auger optr bgn
    models print
    method newton trap maxtrap=15
    solve init
    solve vgate=-0 outf =A_solve_tmp1
    solve vgate=-3 outf =A_solve_tmp2
    solve vgate=-5 outf =A_solve_tmp3
    # tmp3
    load infile=A_solve_tmp3
    # log outfile=B_Ids-Vds_BD_3.log
    solve name=drain vstep=-0.01 vfinal=-1.35
    save outfile=C_Body_Diode_Vds=-1.35.str
    solve name=drain vstep=-0.01 vfinal=-3.01
    save outfile=C_Body_Diode_Vds=-3.01.str
    solve name=drain vstep=-0.01 vfinal=-3.20
    save outfile=C_Body_Diode_Vds=-3.20.str
    # tonyplot -overlay -st B_Ids-Vds_BD_3.log -set SET_log_Ids-Vds_BD_overlay.set
    quit
# Body Drain diode characteristic
tonyplot C_Body_Diode_Vds=-1.35.str \
-set SET_str_Jtol.set
tonyplot C_Body_Diode_Vds=-3.01.str \
-set SET_str_Jtol.set
tonyplot C_Body_Diode_Vds=-3.20.str \
-set SET_str_Jtol.set
quit







# EF CUTLINE
    # sbd vdmosfet 1200V
    # line 1
        # x1 = 2.35
        # x2 = 7.65
        # set gate_x1=$N_plus_1_x2-$N_w*$tmp_factor
        # set gate_x2=$N_plus_2_x1+$N_w*$tmp_factor
        # y = -0.025
    # line 2
        # x=3.4
        # y1=0
        # y2=4
    tonyplot C_BV_Vds=1200V.str \
    -set SET_str_ef_cutlines.set
    quit
# EF CUTLINE

# Band Energy Cutline
    go atlas
    set sch_barrier =1.7
    set affin_4HSiC =3.2
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    mesh infile = A_tmp_1.str
    extract name="t1" clock.time
    contact all neutral
    contact name=source \
    BARRIER ALPHA=1.0e-7 SURF.REC \
    workfunc=$workfunc_sch
    models print
    solve initial
    output con.band val.band
    save outfile=A_tmp_2_band.str
    # sbd band
    tonyplot A_tmp_2_band.str \
    -set SET_str_band_cutlines.set
    quit
# Band Energy Cutline


# models print
# solve initial
# output con.band val.band
# struct outf = ../STR/A_tmp_1_band.str
# tonyplot ../STR/A_tmp_1_band.str -set ../STR/SET_str_band.set