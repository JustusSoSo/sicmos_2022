################ STRUCTURE ################
# SET
    set N_sub       =1e19
    ######## Modified ########
    set N_drift     =3e15
    set N_drift     =9e15
    ######## Modified ########

    ######## Modified ########
    # set P_well      =1e16
    # set P_well      =5e17
    set P_well      =10e17

    set P_plus      =1e19
    set N_plus      =1e19
    ######## 1. threshold ########
    # set P_factor    =0.10
    # set P_ch        =$P_factor * 1e17
    ######## Modified ########
    set P_ch        =1e16
    set P_ch_t      =0.1
    ##############################
    # set SCH_w       =1
    set SCH_w       =2
    set P_w         =1.00
    set N_w         =1.00
    set CH_w        =0.50
    set P_well_w    =$N_w+$P_w+$CH_w
    ######## Modified ########
    set JFET_w      =1.5
    ######## Modified ########
    set CELL_h      =$SCH_w+$P_well_w+$JFET_w
    set CELL        =$CELL_h*2
    #
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
    # set P_well_t    =1.0
    # set P_well_t    =3.0
    set P_well_t    =1.5
    set P_well_t    =2.0
    ######## 2.BV ########
    set N_drift_t   =10.0
    ######################
    set N_sub_t     =1.0
    set drain_t     =1.0
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
    impurity id=2 reg.id=3 imp=Phosphorus \
        peak.value=$N_drift ref.value=$N_drift comb.func=Multiply
#### containing some else impurities ####
    # P well under P Channel part 1
    # under the plus region
    set P_well_1_x1=0
    set P_well_1_x2=$P_well_w
    set P_well_2_x1=$CELL-$P_well_w
    set P_well_2_x2=$CELL
    set tmp_conc_param_x=0.01
    set tmp_conc_param_y=0.05
    # CONC_FUNC_1 = error
    impurity id=3 reg.id=3 imp=Boron \
        peak.value=$P_well ref.value=$P_well comb.func=Multiply \
        x1=$P_well_1_x1 \
        x2=$P_well_1_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=$P_t \
        y2=$P_well_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y
    impurity id=4 reg.id=3 imp=Boron \
        peak.value=$P_well ref.value=$P_well comb.func=Multiply \
        x1=$P_well_2_x1 \
        x2=$P_well_2_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=$P_t \
        y2=$P_well_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y

    # Channel of P type
    set P_CH_1_x1  =$P_well_w-$CH_w
    set P_CH_1_x2  =$P_well_w
    set P_CH_2_x1  =$CELL-$P_CH_1_x2
    set P_CH_2_x2  =$CELL-$P_CH_1_x1
    # CH1
    set tmp_conc_param_x=0.01
    set tmp_conc_param_y=0.01
    impurity id=5 reg.id=3 imp=Boron \
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
    impurity id=6 reg.id=3 imp=Boron \
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
    impurity id=7 reg.id=3 imp=Boron \
        peak.value=$P_well ref.value=$P_well comb.func=Multiply \
        x1=$P_CH_1_x1 \
        x2=$P_CH_1_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=$P_ch_t \
        y2=$P_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y
    impurity id=8 reg.id=3 imp=Boron \
        peak.value=$P_well ref.value=$P_well comb.func=Multiply \
        x1=$P_CH_2_x1 \
        x2=$P_CH_2_x2 \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=$P_ch_t \
        y2=$P_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y

    # P plus pair, noting ref.value is N drift
    set P_plus_2_x1=$CELL-$P_w
    set tmp_conc_param_x=0.01
    set tmp_conc_param_y=0.1
    impurity id=11 reg.id=3 imp=Boron \
        peak.value=$P_plus ref.value=$N_drift \
        comb.func=Multiply \
        x1=0 \
        x2=$P_w \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=0 \
        y2=$P_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y
    impurity id=12 reg.id=3 imp=Boron \
        peak.value=$P_plus ref.value=$N_drift \
        comb.func=Multiply \
        x1=$P_plus_2_x1 \
        x2=$CELL \
        rolloff.x=both conc.func.x="Error Function" \
        conc.param.x=$tmp_conc_param_x \
        y1=0 \
        y2=$P_t \
        rolloff.y=both conc.func.y="Error Function" \
        conc.param.y=$tmp_conc_param_y

    # N plus pair, noting ref.value is N drift
    set N_plus_1_x1=$P_w
    set N_plus_1_x2=$P_w+$N_w
    set N_plus_2_x1=$CELL-($P_w+$N_w)
    set N_plus_2_x2=$CELL-$P_w
    set tmp_conc_param_x=0.01
    set tmp_conc_param_y=0.1
    impurity id=13 reg.id=3 imp=Phosphorus \
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
    impurity id=14 reg.id=3 imp=Phosphorus \
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
    set tmp_factor=0.50
    set oxide_x1=$N_plus_1_x1+$N_w*$tmp_factor
    set oxide_x2=$N_plus_2_x2-$N_w*$tmp_factor
    set oxide_y1=0
    set oxide_y2=0-($ILD_t+$gate_t+$gate_oxide_t)
    # Gate metal
    set tmp_factor=0.25
    set tmp_factor=0.15
    set gate_y1=0-($gate_oxide_t+$gate_t)
    set gate_y2=0-($gate_oxide_t)
    set gate_x1=$N_plus_1_x2-$N_w*$tmp_factor
    set gate_x2=$N_plus_2_x1+$N_w*$tmp_factor
    # region reg=20 name=source mat=Titanium
    # region reg=20 name=source mat=Nickel
    region reg=20 name=source mat=Aluminum elec.id=3 work.func=0 \
        polygon ="0,0 $oxide_x1,0 \
        $oxide_x1,$oxide_y2 \
        $oxide_x2,$oxide_y2 \
        $oxide_x1,0 $CELL,0 \
        $CELL,$area_y1 0,$area_y1"

    # Oxide
    # Gate oxide and ILD
    region reg=31 name=oxide mat=SiO2 \
        polygon="@oxide_x1,0 @oxide_x2,0 @oxide_x2,@oxide_y2 @oxide_x1,@oxide_y2"

    region reg=32 name=gate mat=Aluminum elec.id=2 work.func=0 \
        polygon="@gate_x1,@gate_y1 @gate_x2,@gate_y1 @gate_x2,@gate_y2 @gate_x1,@gate_y2"
# Source Contact the upper source metal

#### set Meshing Parameters ####
    base.mesh height=1 width=1
    # boundary.conditioning noapply max.slope=30
    bound.cond !apply max.slope=30 max.ratio=10 rnd.unit=1E-6 line.straightening=1 align.points when=automatic
    imp.refine imp=netdoping scale=log min.spacing=0.04 sensitivity=0.2 transition=1E10
    # imp.refine imp=netdoping scale=log min.spacing=0.02 sensitivity=0.2 transition=1E10
    # global constraints
    constr.mesh max.angle=90 max.ratio=300
    # material type constraints
        # doesn't matter
        # constr.mesh type=Semiconductor default
        # constr.mesh type=Insulator default
        # constr.mesh type=Metal default
        # constr.mesh type=Other default
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
        # set tmp_y1=0-0.008
        # set tmp_y2=0+0.008
        # set tmp_delta=0.01
        # set tmp_y1=0-$tmp_delta
        # set tmp_y2=0+$tmp_delta
        # set tmp_constr_param_x=0.2
        # set tmp_constr_param_y=0.005
        # set tmp_y1=0-0.008
        # set tmp_y2=0+0.008
        set tmp_delta=0.020
        set tmp_y1=0-$tmp_delta
        # $gate_oxide_t
        set tmp_y2=0+$tmp_delta
        # $P_t+
        # set tmp_constr_param_x=0.01
        # set tmp_constr_param_y=0.01
        # set tmp_constr_param_x=0.20
        # set tmp_constr_param_y=0.005
        set tmp_constr_param_x=0.1
        set tmp_constr_param_y=0.01
        constr.mesh id=21 x1=0 x2=$CELL \
            y1=$tmp_y1 y2=$tmp_y2 default \
            max.width=$tmp_constr_param_x \
            max.height=$tmp_constr_param_y
            # max.height=0.004 max.width=0.2
            # x1=0 y1=-0.008 x2=$CELL y2=0.008
            # default max.height=0.004 max.width=0.2

        # from the bottom P well to the bottom drain
        set tmp_delta = 1.0
        set tmp_y2=$N_drift_t+$N_sub_t+$drain_t
        set tmp_y1=$tmp_y2 - $tmp_delta
        # set tmp_y2=@N_drift_t+@N_sub_t+@drain_t
        set tmp_constr_param_x=1.0
        set tmp_constr_param_y=0.2
        constr.mesh id=22 \
        x1=0 x2=@cell y1=$tmp_y1 y2=$tmp_y2 \
        default \
        max.width=$tmp_constr_param_x \
        max.height=$tmp_constr_param_y
        # constr.mesh id=3 x1=0 y1=29 x2=$CELL y2=32
        # max.height=0.2 max.width=1
    # region specific constraints
    mesh mode=meshbuild
#### set Meshing Parameters ####
struct outf = A_tmp_1.str
tonyplot A_tmp_1.str -set SET_str.set
quit



























































































################ del. ################
    base.mesh height=1 width=1
    bound.cond !apply max.slope=30 max.ratio=10 rnd.unit=1E-6 line.straightening=1 align.points when=automatic
    imp.refine imp=netdoping scale=log min.spacing=0.04 sensitivity=0.2 transition=1E10
    # Channel
    set tmp_delta=0.10
    constr.mesh \
        y1=0 x1=$P_CH_1_x1 \
        y2=$P_ch_t x2=$P_CH_1_x2 \
        default \
        max.height=0.05 max.width=0.05
    constr.mesh \
        y1=0 x1=$P_CH_2_x1 \
        y2=$P_ch_t x2=$P_CH_2_x2 \
        default \
        max.height=0.05 max.width=0.05
    # the vicinity of the PN junction from P_well to N_drift
    set tmp_delta=0.1
    set tmp_x_delta=0.1
    # horizontal lines
    constr.mesh \
        x1=0 \
        x2=$P_well_w+$tmp_x_delta \
        y1=$P_well_t-$tmp_delta \
        y2=$P_well_t+$tmp_delta default \
        max.height=0.05 max.width=0.01
    constr.mesh \
        x1=$P_well_2_x1-$tmp_x_delta \
        x2=$P_well_2_x2 \
        y1=$P_well_t-$tmp_delta \
        y2=$P_well_t+$tmp_delta default \
        max.height=0.05 max.width=0.01
    # vertical lines
    constr.mesh \
        x1=$P_well_w-$tmp_delta \
        x2=$P_well_w+$tmp_delta \
        y1=0 y2=$P_well_t-$tmp_delta default \
        max.height=0.05 max.width=0.01
    constr.mesh \
        x1=$P_well_2_x1-$tmp_delta \
        x2=$P_well_2_x1+$tmp_delta \
        y1=0 y2=$P_well_t-$tmp_delta default \
        max.height=0.05 max.width=0.01
################ del. ################

################ del. ################
    # from the top oxide to the bottom of P well
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
    set tmp_y1=0-0.008
    set tmp_y2=0+0.008
    set tmp_constr_param_x=0.2
    set tmp_constr_param_y=0.004
    constr.mesh id=2 x1=0 x2=$CELL \
        y1=$tmp_y1 y2=$tmp_y2 default \
        max.width=$tmp_constr_param_x \
        max.height=$tmp_constr_param_y
    # from the bottom P well to the bottom drain
    set tmp_y1=0-@oxide_y2
    set tmp_y2=@N_drift_t+@N_sub_t+@drain_t
    set tmp_constr_param_x=1.0
    set tmp_constr_param_y=0.2
    constr.mesh id=3 \
    x1=0 x2=@cell y1=$tmp_y1 y2=$tmp_y2 \
    default \
    max.width=$tmp_constr_param_x \
    max.height=$tmp_constr_param_y
################ del. ################
################
################