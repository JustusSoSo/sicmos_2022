# struct
########
go DevEdit
set clear
# @N_sub or $N_sub is the value defined here. The t is thickness.
set N_sub       =1e19
set N_drift     =10e15
set N_drift     =3e15
    # the N type distributed all over the wafer.
set P_well      =10e17
set P_well      =4.0e17
    # P type account for parts of the N type
set P_plus      =1e19
set N_plus      =1e19
# thickness
set N_t         =0.5
set P_t         =0.5
set N_w         =1.50
set P_w         =1.50
set CH_w        =1.00
set JFET_w      =1.00
######## 1. threshold ########
set P_factor    =0.80
set P_ch        =$P_factor * 1e17
set P_ch_t      =0.2
##############################
set P_well_w    =$N_w + $P_w + $CH_w
set P_well_t    =1.0
# thickness
set source_t    =2
set oxide_top_t =0.5
set gate_t      =0.5

######## 1. threshold ########
# set oxide_t   =0.100
# set oxide_t   =0.06，0.07
set oxide_t     =0.05
##############################
set N_drift_t       =6
set N_substrate_t   =1
set drain_t         =1
set CELL_half   =$JFET_w + $P_well_w
set CELL        =$CELL_half * 2



######## 2.BV ########








# regions
set P_plus_2_x1=$CELL-$P_w
set N_plus_1_x1 = $P_w
set N_plus_1_x2 = $P_w+$N_w
set N_plus_2_x1 = $CELL-($P_w+$N_w)
set N_plus_2_x2 = $CELL-$P_w
# CHannel and Well
set P_well_2_x1=$CELL-$P_well_w
set P_well_2_x2=$CELL
set P_CH_1_x1 = $P_well_w-$CH_w
set P_CH_1_x2 = $P_well_w
set P_CH_2_x1 = $CELL-$P_well_w
set P_CH_2_x2 = $CELL-$P_well_w+$CH_w
# oxide upper y
set oxide_x1=$P_w+0.50
set oxide_x2=$CELL-$oxide_x1
set oxide_y2=(-$source_t+$oxide_top_t)
# Gate
set gate_y1= -($oxide_t+$gate_t)
set gate_y2= -($oxide_t)
set gate_x1=$P_w+$N_w-0.20
set gate_x2=$CELL-$gate_x1





# y gauss func
# x error func
set CONC_FUNC_0=gauss
set CONC_FUNC_1=Error Function

#
work.area x1=0 x2=@cell y1=0-@source_t \
    y2=(@N_drift_t+@N_substrate_t+@drain_t+1)

# drain elec
set tmp_y1=@N_drift_t+@N_substrate_t
set tmp_y2=@N_drift_t+@N_substrate_t+@drain_t
region reg=1 name=drain mat=Aluminum \
    elec.id=1 work.func=0 \
    polygon="0,@tmp_y1 @CELL,@tmp_y1 @CELL,@tmp_y2 0,@tmp_y2"

# sub of N plus region
set tmp_y1=@N_drift_t
set tmp_y2=@N_drift_t+@N_substrate_t
# reg.id = 2
region reg=2 name=N_substrate mat=4H-SiC \
    polygon="0,@tmp_y1 $CELL,@tmp_y1 $CELL,@tmp_y2 0,@tmp_y2"
# impurity id=1 reg.id=2 imp=Phosphorus
impurity reg.id=2 imp=Phosphorus \
    peak.value=$N_sub ref.value=$N_sub comb.func=Multiply

#### containing some else impurities ####
# n drift and reg = 3
region reg=3 name=N_drift mat=4H-SiC \
    polygon="0,0 $CELL,0 $CELL,$N_drift_t 0,$N_drift_t"
# reg.id = 3
impurity id=1 reg.id=3 imp=Phosphorus \
    peak.value=$N_drift ref.value=$N_drift comb.func=Multiply
#
#
#
#
#
#
# P well under P Channel part 1
# reg.id = 3
    #
    # set P_well_t    =3
    # region reg=4 name=P_well_1 mat=4H-SiC polygon="0,0 $P_well_w,0 $P_well_w,$P_well_t 0,$P_well_t"
    # region reg=5 name=P_well_2 mat=4H-SiC polygon="$P_well_2_x1,0 $P_well_2_x2,0 $P_well_2_x2,$P_well_t $P_well_2_x1,$P_well_t"
# param.y = 0.05 or 0.10

# set tmp_conc_param_x=0.01
# set tmp_conc_param_x=0.02
# set tmp_conc_param_y=0.01
set tmp_conc_param_x=0.1
set tmp_conc_param_y=0.05
impurity id=11 reg.id=3 imp=Boron \
    peak.value=$P_well ref.value=$P_well comb.func=Multiply \
    x1=0 x2=$P_well_w \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param_x \
    y1=$P_t y2=$P_well_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_0 \
    conc.param.y=$tmp_conc_param_y
impurity id=12 reg.id=3 imp=Boron \
    peak.value=$P_well ref.value=$P_well comb.func=Multiply \
    x1=$P_well_2_x1 x2=$P_well_2_x2 \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param_x \
    y1=$P_t y2=$P_well_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_0 \
    conc.param.y=$tmp_conc_param_y
set tmp_conc_param_y=0.02
set tmp_conc_param_y=0.05
# P well under P Channel part 2
impurity id=13 reg.id=3 imp=Boron \
    peak.value=$P_well ref.value=$P_well comb.func=Multiply \
    x1=$P_CH_1_x1 \
    x2=$P_CH_1_x2 \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param_x \
    y1=$P_ch_t y2=$P_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_1 \
    conc.param.y=$tmp_conc_param_y
impurity id=14 reg.id=3 imp=Boron \
    peak.value=$P_well ref.value=$P_well comb.func=Multiply \
    x1=$P_CH_2_x1 \
    x2=$P_CH_2_x2 \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param_x \
    y1=$P_ch_t y2=$P_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_1 \
    conc.param.y=$tmp_conc_param_y


# CH1
    # region reg=10 name=P_CH_1 mat=4H-SiC \
    #     polygon="$P_CH_1_x1,0 $P_CH_1_x2,0 $P_CH_1_x2,$P_ch_t $P_CH_1_x1,$P_ch_t"
    # impurity id=5 reg.id=3 imp=Boron peak.value=$channel_doping ref.value=$channel_doping comb.func=Multiply
# set tmp_conc_param=0.01
set tmp_conc_param_x=0.02
set tmp_conc_param_y=0.01
set tmp_conc_param_x=0.1
set tmp_conc_param_y=0.05
impurity id=21 reg.id=3 imp=Boron \
    peak.value=$P_ch ref.value=$P_ch comb.func=Multiply \
    x1=$P_CH_1_x1 \
    x2=$P_CH_1_x2 \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param_x \
    y1=0 \
    y2=$P_ch_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_1 \
    conc.param.y=$tmp_conc_param_y
# CH2
impurity id=22 reg.id=3 imp=Boron \
    peak.value=$P_ch ref.value=$P_ch comb.func=Multiply \
    x1=$P_CH_2_x1 \
    x2=$P_CH_2_x2 \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param_x \
    y1=0 \
    y2=$P_ch_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_1 \
    conc.param.y=$tmp_conc_param_y

# P plus pair
    # region reg=6 name=P_plus_1 mat=4H-SiC \
    #     polygon="0,0 $P_w,0 $P_w,$P_t 0,$P_t"
    # region reg=7 name=P_plus_2 mat=4H-SiC \
    #     polygon="$P_plus_2_x1,0 $CELL,0 $CELL,$P_t $P_plus_2_x1,$P_t"
set tmp_conc_param=0.02
set tmp_conc_param=0.05
impurity id=31 reg.id=3 imp=Boron \
    peak.value=$P_plus ref.value=$P_plus comb.func=Multiply \
    x1=0 \
    x2=$P_w \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param \
    y1=0 \
    y2=$P_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_0 \
    conc.param.y=$tmp_conc_param
impurity id=32 reg.id=3 imp=Boron \
    peak.value=$P_plus ref.value=$P_plus comb.func=Multiply \
    x1=$P_plus_2_x1 \
    x2=$CELL \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param \
    y1=0 \
    y2=$P_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_0 \
    conc.param.y=$tmp_conc_param
# N plus pair
    # region reg=8 name=N_plus_1 mat=4H-SiC \
    #     polygon="$P_w,0 $N_plus_1_x2,0 $N_plus_1_x2,$N_t $P_w,$N_t"
    # region reg=9 name=N_plus_2 mat=4H-SiC \
    #     polygon="$N_plus_2_x1,0 $N_plus_2_x2,0 $N_plus_2_x2,$N_t $N_plus_2_x1,$N_t"
impurity id=33 reg.id=3 imp=Phosphorus \
    peak.value=$N_plus ref.value=$N_plus comb.func=Multiply \
    x1=$N_plus_1_x1 \
    x2=$N_plus_1_x2 \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param \
    y1=0 \
    y2=$N_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_0 \
    conc.param.y=$tmp_conc_param
impurity id=34 reg.id=3 imp=Phosphorus \
    peak.value=$N_plus ref.value=$N_plus comb.func=Multiply \
    x1=$N_plus_2_x1 \
    x2=$N_plus_2_x2 \
    rolloff.x=both conc.func.x=$CONC_FUNC_1 \
    conc.param.x=$tmp_conc_param \
    y1=0 \
    y2=$N_t \
    rolloff.y=both conc.func.y=$CONC_FUNC_0 \
    conc.param.y=$tmp_conc_param



# Upper source # Ni # Ti
# 77 "Nickel" "Ni"
# region reg=20 name=source mat=Aluminum elec.id=2 work.func=0
# region reg=20 name=source mat=Titanium elec.id=2 work.func=0
# region reg=20 name=source mat=Nickel elec.id=2 work.func=0
region reg=20 name=source mat=Aluminum elec.id=2 work.func=0 \
    polygon = "0,0 $CELL,0 $CELL,-$source_t 0,-$source_t"
# oxide upper y
region reg=29 name=oxide mat=SiO2 \
    polygon="@oxide_x1,0 @oxide_x2,0 @oxide_x2,@oxide_y2 @oxide_x1,@oxide_y2"
# gate
# region reg=30 name=gate mat=Polysilicon elec.id=3 work.func=0
region reg=30 name=gate mat=Aluminum elec.id=3 work.func=0\
    polygon="@gate_x1,@gate_y1 @gate_x2,@gate_y1 @gate_x2,@gate_y2 @gate_x1,@gate_y2"











#set Meshing Parameters
base.mesh height=1 width=1
boundary.conditioning noapply max.slope=30 max.ratio=10 rnd.unit=1E-6 line.straightening=1 align.points when=automatic
    # bound.cond
    # boundary.conditioning
    # rnd.unit=0.000001 line.straightening=1 align.points when=automatic
    # noapply
    # max slope is H/W in each boundary
    # max ratio is H/W in each triangle
    # rounding.unit - All boundary points are rounded to an even multiple of this unit.
# bound.cond !apply max.slope=30 max.ratio=10  rnd.unit=0.000001 line.straightening=1 align.points when=automatic
# bound.cond !apply max.slope=30 max.ratio=100 rnd.unit=0.001 line.straightening=1 align.points when=automatic
#
imp.refine imp=netdoping scale=log min.spacing=0.02 sensitivity=0.2 transition=1E10
    # If a triangle is shorter than this, it is not shortened
# imp.refine imp=netdoping scale=log min.spacing=0.02 sensitivity=0.2 transition=1E10
# impurity.refine min.spacing=0.02
# imp.refine min.spacing=0.02
#
#
# The constraints are arranged in a hierarchy: global constraints, material type constraints, and region specific constraints.
#
# global constraints
constr.mesh max.angle=90 max.ratio=300
    # Maximum ratio of a triangles H/W is 300
# material type constraints
    # doesn't matter
    # constr.mesh type=Semiconductor default
    # constr.mesh type=Insulator default
    # constr.mesh type=Metal default
    # constr.mesh type=Other default
# region specific constraints
constr.mesh id=1 \
    x1=0 x2=@cell y1=0-@source_t \
    y2=(@N_drift_t+@N_substrate_t+@drain_t+1) default \
    max.height=1 max.width=1

# Source Gate
constr.mesh id=2 \
    x1=0 x2=@CELL \
    y1=0 y2=0-@source_t default \
    max.height=0.5 max.width=0.5

# oxide upper y, gate's Oxide_layer
set tmp_delta=0.02
constr.mesh id=3 \
    x1=$oxide_x1 \
    x2=$oxide_x2 \
    y1=$gate_y2-$tmp_delta \
    y2=0+$tmp_delta \
    default \
    max.height=0.02 max.width=0.05

#JFET_region
constr.mesh \
    x1=$P_well_w x2=$P_well_2_x1 \
    y1=0 y2=$P_t default \
    max.height=0.05 max.width=0.05
constr.mesh \
    x1=$P_well_w x2=$P_well_2_x1 \
    y1=$P_t y2=$P_well_t default \
    max.height=0.2 max.width=0.2
# the JFET region beneath the gate into the channels
# Polysilicon
constr.mesh \
    under.mat=PolySilicon \
    depth=($oxide_t+$P_ch_t) default \
    max.height=0.05 max.width=0.05

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
# y tmp
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
# build
mesh mode=meshbuild
################ edited ################
# struct outf = A_SICMOSFET_para-$'drain_t'.str
# struct outf=A_SICMOSFET_para-$'N_drift_t'.str
# struct outf=A_SICMOSFET_para-$'source_t'.str
struct outf = B_tmp_1.str
tonyplot B_tmp_1.str -set SET_str.set
quit







































################ TEST ################
set clear
# thickness
set N_t         =0.5
set P_t         =0.5
set N_w         =1.50
set P_w         =1.50
set CH_w        =1.00
set JFET_w      =1.00
######## 1. threshold ########
set P_factor    =0.80
set P_ch        =$P_factor * 1e17
set P_ch_t      =0.2
##############################
set P_well_w    =$N_w + $P_w + $CH_w
set P_well_t    =3
set P_well_t    =1.0
# thickness
set source_t    =2
set oxide_top_t =0.5
set gate_t      =0.5
######## 1. threshold ########
set oxide_t     =0.05
##############################
set N_drift_t       =6
set N_substrate_t   =1
set drain_t         =1
set CELL_half   =$JFET_w + $P_well_w
set CELL        =$CELL_half * 2
# regions
set P_plus_2_x1=$CELL-$P_w
set N_plus_1_x1 = $P_w
set N_plus_1_x2 = $P_w+$N_w
set N_plus_2_x1 = $CELL-($P_w+$N_w)
set N_plus_2_x2 = $CELL-$P_w
# CHannel and Well
set P_well_2_x1=$CELL-$P_well_w
set P_well_2_x2=$CELL
set P_CH_1_x1 = $P_well_w-$CH_w
set P_CH_1_x2 = $P_well_w
set P_CH_2_x1 = $CELL-$P_well_w
set P_CH_2_x2 = $CELL-$P_well_w+$CH_w
# oxide upper y
set oxide_x1=$P_w+0.50
set oxide_x2=$CELL-$oxide_x1
set oxide_y2=(-$source_t+$oxide_top_t)
# Gate
set gate_y1= -($oxide_t+$gate_t)
set gate_y2= -($oxide_t)
set gate_x1=$P_w+$N_w-0.20
set gate_x2=$CELL-$gate_x1
################ TEST ################
go atlas simflags = "-p 4"
################ MESH input ################
# mesh inf = B_tmp.str
mesh infile = B_tmp_1.str
# mesh inf=SICMOSFET_para-$'drain_t'.str
# mesh inf=A_SICMOSFET_para-$'N_drift_t'.str
# mesh infile=A_SICMOSFET_para-$'source_t'.str
# mesh infile=A_SICMOSFET_para-$'source_t'.str
extract name="t1" clock.time

# contact
electrode name=source   top
electrode name=drain    bottom
electrode name=gate     x.min=@gate_x1 x.max=@gate_x2 y.min=@gate_y1 y.max=@gate_y2
    # set gate_y1= -($oxide_t+$gate_t)
    # set gate_y2= -($oxide_t)
    # set gate_x1= 0+$P_w+ 0.5
    # set gate_x2= $CELL-$gate_x1
# Set workfunction for poly gate and interface charge
contact name=gate n.polysilicon
# QF oxide charge density cm(-2), at Semi-Insulator surface
interface qf=3e10

# struct outf = B_tmp_2.str








# 2. solving bv
    # keep Vgs = 0 both, and Vdrain goes down to the minus
    # Solution for a Vds ramp with Vgs=0.0V to get breakdown
# material material=4H-SiC taun0=1e-6 taup0=1e-6 ni.min=1e6
# material material=4H-SiC permitti=9.64 eg300=3.26 \
# 			edb=0.1 gcb=2 eab=0.2 gvb=4 \
# 			nsrhn=3e17 nsrhp=3e17 taun0=5e-10 taup0=1e-10 \
# 			tc.a=100 THETA=90 ZETA=90
material material=4H-SiC permitti=9.64 eg300=3.26 \
			edb=0.1 gcb=2 eab=0.2 gvb=4 \
			nsrhn=3e17 nsrhp=3e17 taun0=5e-10 taup0=1e-10 \
			tc.a=100



# models srh conmob bgn auger fldmob hcte print
models srh
    # srh: recombination of Schottky Read Hall
models cvt fermidirac
    # cvt: mobility
    # fermidirac: fermi and dirac statistics
models conmob
    # cnomb: mobility with respect to concentration
models fldmob
    # fldmob: mobility with respect to elec field
# models cvt consrh srh
models print
#
# impact selb
# impact selb
impact aniso sic4h0001 e.side
# impact aniso e.side
# impact aniso sic4h0001 e.side
# impact aniso sic4h0001 e.side
#



# method newton trap maxtrap=5 itlimi=25
method newton trap maxtrap=5 itlimi=20
    # maxtrap参数定义计算的最大折半次数
    # itlimit表示最大计算次数（如果超了这个次数还没计算出来就折半，折半超过最大折半次数，计算失败。所以可以通过增大这个数值来延长计算量，但是感觉治标不治本）
# method newton trap climit=1e-4
# method newton trap ir.tol=1.e-25 ix.tol=1.e-25 climit=1e-4
# method zip.bicgst climit=1e-4 maxtraps=30 itlimit=30 ir.tol=1.e-30 ix.tol=1.e-30
# method block newton
# method newton trap climit=1e-4

set tmp_compliance=1e-12
solve init
solve previous
log outfile=B_tmp_1.log
    solve vdrain=0.000 previous
    solve vdrain=0.001 previous
    solve vdrain=0.005 previous
    solve vdrain=0.01 previous
    solve vdrain=0.1 previous
    solve vdrain=0.5 previous
    solve vdrain=1  previous
    solve vdrain=3  previous
    solve vdrain=5  previous
        struct outf=C_BV_5V.str
    solve vdrain=10  previous
        struct outf=C_BV_10V.str
    solve vdrain=15  previous
    solve vdrain=20  previous
        struct outf=C_BV_20V.str
    solve vstep=20 vfinal=100 name=drain  previous
        struct outf=C_BV_100V.str
    solve vstep=20 vfinal=500 name=drain  previous
        struct outf=C_BV_500V.str
    solve vstep=20 vfinal=1000 name=drain  previous
        struct outf=C_BV_100V.str
    solve vstep=20 vfinal=1200 name=drain  previous
        struct outf=C_BV_1200V.str
    solve vstep=20 vfinal=1500 name=drain  previous
        struct outf=C_BV_1500V.str
    solve vstep=20 vfinal=2000 name=drain  previous
        struct outf=C_BV_2000V.str
    # $tmp_compliance



    # solve vstep=10 vfinal=400 name=drain cname=drain compliance=$tmp_compliance previous
    # solve vstep=20 vfinal=1220 name=drain cname=drain compliance=$tmp_compliance previous
    # solve vstep=10 vfinal=400 name=drain cname=drain compliance=1e-12 previous
    # solve vstep=20 vfinal=1220 name=drain cname=drain compliance=1e-12 previous
    # solve vstep=20 vfinal=1250 name=drain cname=drain compliance=1e-24 previous
    # compliance=1e-12

        # Warning: Convergence problem.  Taking smaller bias step(s).  Bias step reduced 1 times.
        # Sets a limit on the current from the electrode which has been specified by the CNAME or E.COMPLIANCE parameter. When the COMPLIANCE value is reached, any bias ramp is stopped and the program continues with the next line of the input file. The COMPLIANCE parameter is normally specified in A. If the GRAD parameter is specified, COMPLIANCE is specified in A/V.
log close


# Extract the design parameter, Vbd
# extract init infile="A_SICMOSFET_para.log"
# extract init infile="B_tmp.log"
extract init infile="B_tmp_1.log"
#
# extract name="N_VBreakdown" x.val from curve(abs(v."drain"),abs(i."drain")) where y.val=1e-12
# extract name="N_VBreakdown" x.val from curve(abs(v."drain"),abs(i."drain")) where y.val=1e-11
# extract name="N_VBreakdown" x.val from curve(abs(v."drain"),abs(i."drain")) where y.val=1e-9
# extract name="N_VBreakdown" x.val from curve(abs(v."drain"),abs(i."drain")) where y.val=1e-9
#
# tonyplot A_SICMOSFET_para.log -set C_SET_BV_log.set
# tonyplot B_tmp.log -set SET_log.set

struct outf = B_tmp_2.str
tonyplot B_tmp_1.log -set SET_log.set
tonyplot B_tmp_2.str -set SET_str.set

extract name="t2" clock.time
extract name="Elapsed_second_01" $t2 - $t1
extract name="Elapsed_minute_01" ($t2 - $t1)/60.00
# extract name="elapsed_time_80" $t3 - $t2
quit





        # solve vdrain=0.05   vstep=0.05 vfinal=0.5 name=drain
        # solve vstep=0.5 vfinal=5 name=drain
        # solve vstep=5 vfinal=50 name=drain
        # solve vdrain=100
        # solve vstep=100 vfinal=1600 name=drain


        # compl=1e-11 cname=drain
        # solve vstep=100 vfinal=1200 name=drain compl=5e-9 cname=drain

        # tonyplot B_tmp_1.str -set SET_str.set





















################ TEST ################
set oxide_t     =0.05
set gate_t      =0.5
set P_w         =1
set CELL        =10
set gate_y1= -($oxide_t+$gate_t)
set gate_y2= -($oxide_t)
set gate_x1= 0+$P_w+ 0.5
set gate_x2= $CELL-$gate_x1
# To run on 4 processors, use:
# go atlas simflags="-V 5.14.0.R -P 4"
go atlas simflags = "-p 4"
################ MESH input ################
mesh infile = B_tmp_1.str
# mesh inf=SICMOSFET_para-$'drain_t'.str
# mesh inf=A_SICMOSFET_para-$'N_drift_t'.str
# mesh infile=A_SICMOSFET_para-$'source_t'.str
# mesh infile=A_SICMOSFET_para-$'source_t'.str
extract name="TIME_01" clock.time

# contact
electrode name=source   top
electrode name=drain    bottom
electrode name=gate y.min=@gate_y1 y.max=@gate_y2 \
    x.min=@gate_x1 x.max=@gate_x2
# Set workfunction for poly gate and interface charge
# contact name=gate n.polysilicon
# QF oxide charge density cm(-2), at Semi-Insulator surface
interface qf=3e10

# 1. solving threshold
models cvt srh print
method newton
solve init
solve Vsource=0
################ LOGGING ################
# log outf=A_SICMOSFET_para-$'N_drift_t'.log
# log outfile=A_SICMOSFET_para-$'source_t'.log
# log outfile=A_SICMOSFET_para-$'oxide_t'.log
# log outfile=A_SICMOSFET_para-$'P_ch'.log
log outfile=B_tmp.log
solve Vdrain=0.1
# solve Vgate=0 vstep=0.2 vfinal=12.0 name=gate
solve Vgate=0 vstep=0.5 vfinal=8.0 name=gate
# solve previous
# solve vstep=0.2 vfinal=15.0 name=gate
log close
################ EXTRACT ################
# extract init infile="A_SICMOSFET_para-$'P_ch'.log"
extract init infile="B_tmp.log"
# threshold
extract name="N_Vthreshold" (xintercept(maxslope(curve(abs(v."gate"),abs(i."drain")))) - abs(ave(v."drain"))/2.0)
# tonyplot A_SICMOSFET_para-$'oxide_t'.log
# tonyplot A_SICMOSFET_para-$'P_ch'.log -set SET_log.set
extract name="TIME_02" clock.time
struct outf = B_tmp_2.str
# tonyplot B_tmp_2.str -set SET_str.set
quit
















################
################
quit