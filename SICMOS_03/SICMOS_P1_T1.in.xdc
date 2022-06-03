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
    ######## Modified ########
    set SCH_width   =1.00
    set SCH_w       =$SCH_width/2
    set sch_barrier =1.7
    ######## Modified ########
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
    set sch_x2=$SCH_w+0.05
    # set oxide_y2=0-($ILD_t+$gate_t+$gate_oxide_t)
    set sch_x3=$CELL-$sch_x2
    set sch_x4=$CELL
    set ohm_x1=$sch_x2
    set ohm_x2=$sch_x3
    # Schottky Source
    region reg=20 name=source mat=Aluminum elec.id=3 work.func=0 \
        polygon="0,0 $CELL,0 $CELL,$area_y1 0,$area_y1"
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
# interval

# Body diode at vgs = -5V and Ids = -0.1
# Body Drain diode characteristic
    go atlas simflags = "-80 -p 2"
    mesh infile = A_tmp_1.str width=0.3E6
    ################ SETTING ################
    set affin_4HSiC =3.2
    set workfunc_sch=$affin_4HSiC+$sch_barrier
    contact all neutral
    contact name=source BARRIER ALPHA=1.0e-7 SURF.REC workfunc=$workfunc_sch
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
    ################ SETTING ################
    method newton trap maxtrap=15
    solve init
    solve name=gate vstep=-1 vfinal=-5
    solve name=drain vstep=1 vfinal=2
    # $'SCH_width'
    ################ MODIFY ################
    log outfile=./LOG/B_Ids-Vds_BD=$'SCH_width'.log
    ################ MODIFY ################
    solve name=drain vstep=-0.25  vfinal=0
    solve name=drain vstep=-0.05 vfinal=-3.0
    solve name=drain vstep=-0.01 vfinal=-3.2
    solve name=drain vstep=-0.05 vfinal=-5.0
    ################ MODIFY ################
    extract name="Vforward=$'SCH_width'" \
    x.val from curve (abs(v."drain") ,abs(i."drain")) where y.val=0.1 \
    datafile="data03_BD.dat"
    ################ MODIFY ################
    quit
# Body Drain diode characteristic