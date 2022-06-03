# whole cell
########
go DevEdit
set clear
    # @N_sub or $N_sub is the value defined here. The t is thickness.
set N_sub       =1e19
set N_drift     =1e16
    # the N type distributed all over the wafer.
set P_well      =1e18
set P_body      =1e18
    # P type account for parts of the N type
set P_plus      =1e19
set N_plus      =1e19

# thickness
set N_t         =0.5
set P_t         =0.5
set N_w         =1
set P_w         =1
set CH_w        =1
set JFET_w      =2

######## 1. threshold ########
set P_factor    =0.80
set P_ch        =$P_factor * 1e17
set P_ch_t      =0.2
##############################

set P_well_w    =$N_w + $P_w + $CH_w
set P_well_t    =3
# thickness
set source_t        =2
set oxide_top_t     =0.5
set gate_t          =0.5

######## 1. threshold ########
# set oxide_t         =0.100
# set oxide_t         =0.06，0.07
set oxide_t         =0.05
##############################

set N_drift_t       =6
set N_substrate_t   =1
set drain_t         =1
# width
set CELL_half   =$JFET_w + $P_well_w
set cell        =$CELL_half * 2

######## 2.BV ########





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
region reg=2 name=substrate mat=4H-SiC \
    polygon="0,@tmp_y1 $CELL,@tmp_y1 $CELL,@tmp_y2 0,@tmp_y2"
# reg.id = 2
impurity id=1 reg.id=2 imp=Phosphorus \
    peak.value=$N_sub ref.value=$N_sub comb.func=Multiply


# n drift and reg = 3
region reg=3 name=N_drift mat=4H-SiC \
    polygon="0,0 $CELL,0 $CELL,$N_drift_t 0,$N_drift_t"
# reg.id = 3
impurity id=2 reg.id=3 imp=Phosphorus \
    peak.value=$N_drift ref.value=$N_drift comb.func=Multiply





# P_body or P_wells reg.id = 3
# set P_well_t    =3
region reg=4 name=P_well_1 mat=4H-SiC \
    polygon="0,0 $P_well_w,0 $P_well_w,$P_well_t 0,$P_well_t"
impurity id=3 reg.id=4 imp=Boron \
    peak.value=$P_well ref.value=$P_well comb.func=Multiply

set P_well_2_x1 = $CELL-$P_well_w
region reg=5 name=P_well_2 mat=4H-SiC \
    polygon="$P_well_2_x1,0 $CELL,0 $CELL,$P_well_t $P_well_2_x1,$P_well_t"
impurity id=4 reg.id=5 imp=Boron \
    peak.value=$P_well ref.value=$P_well comb.func=Multiply


# P plus and N plus
    # $P_plus
    # reg.id = 3
region reg=6 name=P_plus_1 mat=4H-SiC \
    polygon="0,0 $P_w,0 $P_w,$P_t 0,$P_t"
impurity id=6 reg.id=6 imp=Boron \
    peak.value=$P_plus ref.value=$P_plus comb.func=Multiply
set P_plus_2_x1=$CELL-$P_w
region reg=7 name=P_plus_2 mat=4H-SiC \
    polygon="$P_plus_2_x1,0 $CELL,0 $CELL,$P_t $P_plus_2_x1,$P_t"
impurity id=7 reg.id=7 imp=Boron \
    peak.value=$P_plus ref.value=$P_plus comb.func=Multiply

# N plus
set N_plus_1_x2 = $P_w+$N_w
set N_plus_2_x1 = $CELL-($P_w+$N_w)
set N_plus_2_x2 = $CELL-$P_w
region reg=8 name=N_plus_1 mat=4H-SiC \
    polygon="$P_w,0 $N_plus_1_x2,0 $N_plus_1_x2,$N_t $P_w,$N_t"
impurity id=8 reg.id=8 imp=Phosphorus \
    peak.value=$N_plus ref.value=$N_plus comb.func=Multiply
region reg=9 name=N_plus_2 mat=4H-SiC \
    polygon="$N_plus_2_x1,0 $N_plus_2_x2,0 $N_plus_2_x2,$N_t $N_plus_2_x1,$N_t"
impurity id=9 reg.id=9 imp=Phosphorus \
    peak.value=$N_plus ref.value=$N_plus comb.func=Multiply

# CH1
set P_CH_1_x1 = $P_well_w-$CH_w
set P_CH_1_x2 = $P_well_w
set P_CH_2_x1 = $CELL-$P_well_w
set P_CH_2_x2 = $CELL-$P_well_w+$CH_w
region reg=10 name=P_CH_1 mat=4H-SiC \
    polygon="$P_CH_1_x1,0 $P_CH_1_x2,0 $P_CH_1_x2,$P_ch_t $P_CH_1_x1,$P_ch_t"
# impurity id=5 reg.id=3 imp=Boron peak.value=$channel_doping ref.value=$channel_doping comb.func=Multiply
impurity id=21 reg.id=10 imp=Boron \
    peak.value=$P_ch ref.value=$P_ch comb.func=Multiply \
    y1=0            y2=$P_ch_t    rolloff.y=both conc.func.y="Error Function" conc.param.y=0.01 \
    x1=$P_CH_1_x1   x2=$P_CH_1_x2 rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01
    # rolloff.y=both conc.func.y="Error Function" conc.param.y=0.2
    # rolloff.x=both conc.func.x="Error Function" conc.param.x=0.1
# CH2
region reg=11 name=P_CH_2 mat=4H-SiC \
    polygon="$P_CH_2_x1,0 $P_CH_2_x2,0 $P_CH_2_x2,$P_ch_t $P_CH_2_x1,$P_ch_t"
# impurity id=11 reg.id=11 imp=Boron \
#     peak.value=$P_ch ref.value=$P_ch comb.func=Multiply
impurity id=22 reg.id=11 imp=Boron \
    peak.value=$P_ch ref.value=$P_ch comb.func=Multiply \
    y1=0            y2=$P_ch_t    rolloff.y=both conc.func.y="Error Function" conc.param.y=0.01 \
    x1=$P_CH_2_x1   x2=$P_CH_2_x2 rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01










# upper source
# region reg=20 name=source mat=Aluminum elec.id=2 work.func=0
region reg=20 name=source mat=Titanium elec.id=2 work.func=0 \
    polygon = "0,0 $CELL,0 $CELL,-$source_t 0,-$source_t"
# $source_t
# Ni
# Ti

# oxide upper y
set tmp_y2=(-$source_t+$oxide_top_t)
set tmp_x1=0+$P_w
set tmp_x2=$CELL - $tmp_x1
# set oxide_x2 = $CELL-1
region reg=29 name=oxide mat=SiO2 \
    polygon="@tmp_x1,0 @tmp_x2,0 @tmp_x2,@tmp_y2 @tmp_x1,@tmp_y2"

# gate
set gate_y1= -($oxide_t+$gate_t)
set gate_y2= -($oxide_t)
set gate_x1= 0+$P_w+ 0.5
set gate_x2= $CELL-$gate_x1
region reg=30 name=gate mat=Polysilicon elec.id=3 work.func=0\
    polygon="@gate_x1,@gate_y1 @gate_x2,@gate_y1 @gate_x2,@gate_y2 @gate_x1,@gate_y2"
# polygon="1.5,@gate_y2  1.5,@gate_y1  @gate_x2,@gate_y1  @gate_x2,@gate_y2"


#set Meshing Parameters
base.mesh height=1 width=1
bound.cond !apply max.slope=30 max.ratio=10  rnd.unit=0.000001 line.straightening=1 align.points when=automatic
imp.refine imp=netdoping scale=log min.spacing=0.02 sensitivity=0.2 transition=1E10
mesh mode = meshbuild



################ edited ################
# struct outf = A_SICMOSFET_para-$'drain_t'.str
# struct outf=A_SICMOSFET_para-$'N_drift_t'.str
# struct outf=A_SICMOSFET_para-$'source_t'.str
struct outf = B_tmp.str
# tonyplot B_tmp.str -set SET_str.set







################ TEST ################
# To run on 4 processors, use:
# go atlas simflags="-V 5.14.0.R -P 4"
go atlas simflags = "-p 4"
################ MESH input ################
# mesh inf=SICMOSFET_para-$'drain_t'.str
# mesh inf=A_SICMOSFET_para-$'N_drift_t'.str
# mesh infile=A_SICMOSFET_para-$'source_t'.str
mesh inf=B_tmp.str






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

# Set models
# models cvt srh print
models print cvt consrh
impact selb
# method newton
method newton trap climit=1e-4












solve init
solve Vsource=0




# solving threshold
################ LOGGING ################
# log outf=A_SICMOSFET_para-$'N_drift_t'.log
# log outfile=A_SICMOSFET_para-$'source_t'.log
# log outfile=A_SICMOSFET_para-$'oxide_t'.log
log outfile=A_SICMOSFET_para-$'P_ch'.log
solve Vdrain=0.1
solve Vgate=0 vstep=0.2 vfinal=12.0 name=gate
solve previous
solve vstep=0.2 vfinal=15.0 name=gate
log close
# ERROR : Initialization has not been performed.
# solved:
# "SICMOSFET_para-$'drain_t'.log"
# extract init infile="temp.log"
# struct outf=A_SICMOSFET_para-$'N_drift_t'.str
################ EXTRACT ################
# extract init infile="A_SICMOSFET_para-$'N_drift_t'.log"
# extract init infile="A_SICMOSFET_para-$'source_t'.log"
# extract init infile="A_SICMOSFET_para-$'oxide_t'.log"
extract init infile="A_SICMOSFET_para-$'P_ch'.log"






# threshold
extract name="N_Vthreshold" (xintercept(maxslope(curve(abs(v."gate"),abs(i."drain")))) - abs(ave(v."drain"))/2.0)
# tonyplot A_SICMOSFET_para-$'oxide_t'.log
tonyplot A_SICMOSFET_para-$'P_ch'.log \
    -set SET_log.set
################
################
quit



