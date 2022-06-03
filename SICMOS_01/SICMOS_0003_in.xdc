# whole cell
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
# OX gate
set ox_t    = 0.100
set gate_t  = 0.5
# thickness
set N_t         =0.5
set P_t         =0.5
set N_w         =1
set P_w         =1
set CH_w        =1
set JFET_w      =2

# CH
set P_ch        =1e17
set P_ch_t       = 0.1

# widths
set P_well_w    =$N_w + $P_w + $CH_w
set P_well_t    =3
# half cell width
set CELL_half   = $JFET_w + $P_well_w
set cell        = $CELL_half * 2




set N_drift_t       =6
set N_substrate_t   =1
set drain_t         =2




work.area x1=0 x2=@cell \
    y1=-2 \
    y2=(@N_drift_t+@N_substrate_t+@drain_t)
# drain elec
set tmp_y1=@N_drift_t+@N_substrate_t
set tmp_y2=@N_drift_t+@N_substrate_t+@drain_t
region reg=1 name=drain mat=Aluminum elec.id=1 work.func=0 \
    polygon="0,@tmp_y1 @CELL,@tmp_y1 \
            @CELL,@tmp_y2 0,@tmp_y2"
# elec.id = n
    # Specifies the bias voltage for electrode, n. Normally, Vn, defaults to the potential from the previous bias point. It is more usual to use electrode names rather than numbers. This parameter is superseded by V<name>.


# sub of N plus region
set tmp_y1=@N_drift_t
set tmp_y2=@N_drift_t+@N_substrate_t
region reg=2 name=substrate mat=4H-SiC \
    polygon="0,@tmp_y1 $CELL,@tmp_y1 \
            $CELL,@tmp_y2 0,@tmp_y2"
# reg.id = 2
impurity id=1 reg.id=2 imp=Phosphorus \
    peak.value=$N_sub ref.value=$N_sub comb.func=Multiply



# n drift and reg = 3
region reg=3 name=N_drift mat=4H-SiC \
    polygon="0,0 $CELL,0 \
            $CELL,$N_drift_t 0,$N_drift_t"
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

# CH
set P_CH_1_x1 = $P_well_w-$CH_w
set P_CH_2_x1 = $CELL-$P_well_w
set P_CH_2_x2 = $CELL-$P_well_w+$CH_w
region reg=10 name=P_CH_1 mat=4H-SiC \
    polygon="$P_CH_1_x1,0 $P_well_w,0 $P_well_w,$P_ch_t $P_CH_1_x1,$P_ch_t"
impurity id=10 reg.id=10 imp=Boron \
    peak.value=$P_ch ref.value=$P_ch comb.func=Multiply
region reg=11 name=P_CH_2 mat=4H-SiC \
    polygon="$P_CH_2_x1,0 $P_CH_2_x2,0 $P_CH_2_x2,$P_ch_t $P_CH_2_x1,$P_ch_t"
impurity id=11 reg.id=11 imp=Boron \
    peak.value=$P_ch ref.value=$P_ch comb.func=Multiply





# upper source
# elec = 2
# region reg=20 name=source mat=Aluminum elec.id=2 work.func=0
region reg=20 name=source mat=Titanium elec.id=2 work.func=0 \
    polygon = "0,0 $CELL,0 $CELL,-2 0,-2"
# Ni
# Ti

# oxide 1(left)
set oxide_x2 = $CELL-1
region reg=29 name=oxide mat=SiO2 \
    polygon="1,0 @oxide_x2,0 @oxide_x2,-1 1,-1"

# gate
set gate_y1 = -@ox_t - @gate_t
set gate_y2 = -@ox_t
set gate_x2 = @CELL - 1.5
region reg=30 name=gate mat=Polysilicon elec.id=3 work.func=0\
    polygon="1.5,@gate_y2  1.5,@gate_y1  @gate_x2,@gate_y1  @gate_x2,@gate_y2"
# region reg=22 name=gate mat=Aluminum elec.id=3 work.func=0\
# set ox_t    = 0.100
# set gate_t  = 0.5


#set Meshing Parameters
base.mesh height=1 width=1
# base.mesh height=1 width=0.5
# base.mesh height=1 width=1
# base.mesh height=0.1 width=0.125
# base.mesh height=2 width=0.5
#
bound.cond !apply max.slope=30 max.ratio=10  rnd.unit=0.000001 line.straightening=1 align.points when=automatic
# bound.cond !apply max.slope=30 max.ratio=10  rnd.unit=0.000001 line.straightening=1 align.points when=automatic
# bound.cond !apply max.slope=30 max.ratio=100 rnd.unit=0.001 line.straightening=1 align.points when=automatic
imp.refine imp=netdoping scale=log min.spacing=0.02 sensitivity=0.2 transition=1E10
# imp.refine imp=netdoping scale=log min.spacing=0.04 sensitivity=0.2 transition=1E10
mesh mode = meshbuild

# electrode name=substrate backside
# struct outf = SICMOSFET_01.str
# tonyplot -st SICMOSFET_01.str
# mirroring
# mirror side = right auto.split=true
# mirror side = right auto.split=false
struct outf = SICMOSFET_para-$'drain_t'.str
# tonyplot SICMOSFET_01.str -set SICMOSFET_01.set
# quit













############# Test ################
# go atlas simflags="-P 10"
go atlas simflags="-P 8"
# Starting Parallel Atlas
# The -P option is used to set the number of processors to use in a parallel Atlas run. If the number set by -P is greater than the number of processors available or than the number of parallel thread licenses, the number is automatically reduced to this cap number.
# To run on 4 processors, use:
    # go atlas simflags="-V 5.14.0.R -P 4"

# mesh inf = SICMOSFET_01.str
mesh inf=SICMOSFET_para-$'drain_t'.str
electrode name=gate \
    x.min=3 x.max=7 y.min=0.2 y.max=0.3
electrode name=source   top
electrode name=drain    bottom

# Model
models cvt srh print
# interface qf=3e10
interface qf=3e10
    # QF oxide charge density cm(-2), at Semi-Insulator surface

# solving
method newton
# Bias the drain
    # elec 1 = drain
    # 2 = source
    # 3 = gate
solve init
solve Vsource=0
#




# logging
log outf = SICTEST_01.log
    # log outf=mos1ex01_1.log master
    # master default: AC and IV
solve Vdrain=0.1
solve Vgate=0 vstep=0.1 vfinal=15.0 name=gate
    # name = gate
    # Specifies that the named electrode is to be ramped. Custom electrode names are supported by name. See also the V<name> parameter
extract name="IDS1" max(i."drain") \
    datafile="extract_01.final"
# threshold
extract name="N_Vthreshold" (xintercept(maxslope(curve(abs(v."gate"),abs(i."drain")))) - abs(ave(v."drain"))/2.0)
log close





# EXTRACT INIT INFILE="SICTEST_01.log"
extract init infile="SICTEST_01.log"
extract name="IDS2" max(i."drain")
# A typical example of using EXTRACT is the extraction of the threshold voltage of an MOS transistor. In the following example, the threshold voltage is extracted by calculating the maximum slope of the Id / Vg curve, finding the intercept with the X axis and then subtracting half of the applied drain bias.
    # extract device parameters
    # extract name="N_Vthreshold" (xintercept(maxslope(curve(abs(v."gate"),abs(i."drain")))) \
    # 	- abs(ave(v."drain"))/2.0)
    # extract name="N_beta" slope(maxslope(curve(abs(v."gate"),abs(i."drain")))) \
    # 	* (1.0/abs(ave(v."drain")))
    # extract name="N_theta" ((max(abs(v."drain")) * $"nbeta")/max(abs(i."drain"))) \
    # 	- (1.0 / (max(abs(v."gate")) - ($"nvt")))







log outf = SICTEST_02.log
solve Vdrain=0.5
solve Vgate=0 vstep=0.1 vfinal=15.0 name=gate
# threshold
extract name="N_Vthreshold" (xintercept(maxslope(curve(abs(v."gate"),abs(i."drain")))) - abs(ave(v."drain"))/2.0)
log close




log outf = SICTEST_03.log
solve Vdrain=1
solve Vgate=0 vstep=0.1 vfinal=15.0 name=gate
# threshold
extract name="N_Vthreshold" (xintercept(maxslope(curve(abs(v."gate"),abs(i."drain")))) - abs(ave(v."drain"))/2.0)
log off





tonyplot SICTEST_01.log
# tonyplot SICTEST_01.log -set SICTEST_01.set
quit
# log off
# struct outf = SICMOSFET_02.str
# tonyplot SICMOSFET_02.str -set SICMOSFET_02.set

