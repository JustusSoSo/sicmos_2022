
go DevEdit
set clear
set N_sub       =1e19
set N_drift     =10e15
set N_drift     =3e15

set P_well      =10e17
set P_well      =4.0e17

set P_plus      =1e19
set N_plus      =1e19

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

set P_well_w    =$N_w + $P_w + $CH_w
set P_well_t    =3
set P_well_t    =1.0
# thickness
set source_t    =2
set oxide_top_t =0.5
set gate_t      =0.5

######## 1. threshold ########

set oxide_t     =0.05

set N_drift_t       =6
set N_substrate_t   =1
set drain_t         =1
set CELL_half   =$JFET_w + $P_well_w
set CELL        =$CELL_half * 2


set P_plus_2_x1=$CELL-$P_w
set N_plus_1_x1 = $P_w
set N_plus_1_x2 = $P_w+$N_w
set N_plus_2_x1 = $CELL-($P_w+$N_w)
set N_plus_2_x2 = $CELL-$P_w

set P_well_2_x1=$CELL-$P_well_w
set P_well_2_x2=$CELL
set P_CH_1_x1 = $P_well_w-$CH_w
set P_CH_1_x2 = $P_well_w
set P_CH_2_x1 = $CELL-$P_well_w
set P_CH_2_x2 = $CELL-$P_well_w+$CH_w

set oxide_x1=$P_w+0.50
set oxide_x2=$CELL-$oxide_x1
set oxide_y2=(-$source_t+$oxide_top_t)

set gate_y1= -($oxide_t+$gate_t)
set gate_y2= -($oxide_t)
set gate_x1=$P_w+$N_w-0.20
set gate_x2=$CELL-$gate_x1





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
region reg=20 name=source mat=Aluminum elec.id=2 work.func=0 \
    polygon = "0,0 $CELL,0 $CELL,-$source_t 0,-$source_t"
# oxide upper y
region reg=29 name=oxide mat=SiO2 \
    polygon="@oxide_x1,0 @oxide_x2,0 @oxide_x2,@oxide_y2 @oxide_x1,@oxide_y2"
# gate
region reg=30 name=gate mat=Aluminum elec.id=3 work.func=0\
    polygon="@gate_x1,@gate_y1 @gate_x2,@gate_y1 @gate_x2,@gate_y2 @gate_x1,@gate_y2"











#set Meshing Parameters
base.mesh height=1 width=1
boundary.conditioning noapply max.slope=30 max.ratio=10 rnd.unit=1E-6 line.straightening=1 align.points when=automatic
# bound.cond !apply max.slope=30 max.ratio=10  rnd.unit=0.000001 line.straightening=1 align.points when=automatic
# bound.cond !apply max.slope=30 max.ratio=100 rnd.unit=0.001 line.straightening=1 align.points when=automatic
#
imp.refine imp=netdoping scale=log min.spacing=0.02 sensitivity=0.2 transition=1E10
# imp.refine imp=netdoping scale=log min.spacing=0.02 sensitivity=0.2 transition=1E10
# impurity.refine min.spacing=0.02
# imp.refine min.spacing=0.02
#
#

#
# global constraints
constr.mesh max.angle=90 max.ratio=300
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
struct outf =vdmos_zxd.str
tonyplot vdmos_zxd.str -set SET_str.set
quit







