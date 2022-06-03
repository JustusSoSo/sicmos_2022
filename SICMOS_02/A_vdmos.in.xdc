go DevEdit
set N_sub=1e19
set P_well=1e19
set P_body=1e18
set N_well=1e19
set NDRIFT=3E15
set channel_doping=1e16
set channel_t=0.1

set N_t=0.5
set N_w=1
set P_t=0.5
set P_w=1

set Channel=0.5
set ox_t=0.050
set gate_t=0.5
set JFET=3

set P_body_w=$N_w+$P_w+$Channel
set P_body_t=3
set CELL=$JFET+$P_body_w+$P_body_w
#
set x01 = $CELL-1.5
set x02 = $CELL-1.75
set x03 = $P_w-0.2
set x04 = $P_w+0.2
set x05 = $CELL-($P_w-0.2)
set x06 = $CELL-($P_w+0.2)
set x07 = $P_w+$N_w+0.2
set x08 = $P_w+$N_w-0.2
set x09 = $CELL-$x07
set x10 = $CELL-$x08
set x11 = $P_body_w+0.2
set x12 = $P_body_w-0.2
set x13 = $CELL-$x11
set x14 = $CELL-$x12
set y01 = $P_t+0.2
set y02 = $P_t-0.2
set y03 = $P_body_t+0.2
set y04 = $P_body_t-0.2



work.area x1=0 y1=-2 x2=$CELL y2=32
set N_drift_t       =8
set N_substrate_t   =1
set drain_t         =1
set drain_y1 = $N_drift_t + $N_substrate_t
set drain_y2 = $N_drift_t + $N_substrate_t + $drain_t
region reg=1 name=drain mat=Aluminum elec.id=1 work.func=0 \
    polygon="0,$drain_y1 $CELL,$drain_y1 $CELL,$drain_y2 0,$drain_y2"
set sub_y1 = $N_drift_t
set sub_y2 = $N_drift_t + $N_substrate_t
region reg=2 name=substrate mat=4H-SiC \
    polygon="0,$sub_y1 $CELL,$sub_y1 $CELL,$sub_y2 0,$sub_y2"
impurity id=1 reg.id=2 imp=Phosphorus \
    peak.value=$N_sub ref.value=$N_sub comb.func=Multiply

# N_drift_t
region reg=3 name=N_drift mat=4H-SiC \
    polygon="0,0 $CELL,0 $CELL,$N_drift_t 0,$N_drift_t"
impurity id=2 reg.id=3 imp=Phosphorus \
    peak.value=$NDRIFT ref.value=$NDRIFT comb.func=Multiply

#P_body
impurity id=3 reg.id=3 imp=Boron \
    peak.value=$P_body ref.value=$P_body comb.func=Multiply \
    y1=$N_t y2=$P_body_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.05 \
    x1=0 x2=$P_body_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01
impurity id=4 reg.id=3 imp=Boron \
    peak.value=$P_body ref.value=$P_body comb.func=Multiply \
    y1=$N_t y2=$P_body_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.05 \
    x1=$CELL-$P_body_w x2=$CELL rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01

#channel_doping
impurity id=5 reg.id=3 imp=Boron \
    peak.value=$channel_doping ref.value=$channel_doping comb.func=Multiply \
    y1=0 y2=$channel_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.01 \
    x1=$N_w+$P_w x2=$P_body_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01
impurity id=6 reg.id=3 imp=Boron \
    peak.value=$channel_doping ref.value=$channel_doping comb.func=Multiply \
    y1=0 y2=$channel_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.01 \
    x1=$CELL-$P_body_w x2=$CELL-($N_w+$P_w) rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01

impurity id=7 reg.id=3 imp=Boron \
    peak.value=$P_body ref.value=$P_body comb.func=Multiply \
    y1=$channel_t y2=$N_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.01 \
    x1=$N_w+$P_w x2=$P_body_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01
impurity id=8 reg.id=3 imp=Boron \
    peak.value=$P_body ref.value=$P_body comb.func=Multiply \
    y1=$channel_t y2=$N_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.01 \
    x1=$CELL-$P_body_w x2=$CELL-($N_w+$P_w) rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01


# plus reg
impurity id=9 reg.id=3 imp=Boron \
    peak.value=$P_well ref.value=$NDRIFT comb.func=Multiply \
    y1=0 y2=$P_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.1 \
    x1=0 x2=$P_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01
impurity id=10 reg.id=3 imp=Boron \
    peak.value=$P_well ref.value=$NDRIFT comb.func=Multiply \
    y1=0 y2=$P_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.1 \
    x1=$CELL-$P_w x2=$CELL rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01

impurity id=11 reg.id=3 imp=Phosphorus \
    peak.value=$N_well ref.value=$NDRIFT comb.func=Multiply \
    y1=0 y2=$N_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.1 \
    x1=$P_w x2=$P_w+$N_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01
impurity id=12 reg.id=3 imp=Phosphorus \
    peak.value=$N_well ref.value=$NDRIFT comb.func=Multiply \
    y1=0 y2=$N_t rolloff.y=both conc.func.y="Error Function" conc.param.y=0.1 \
    x1=$CELL-($P_w+$N_w) x2=$CELL-$P_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01





region reg=4 name=source mat=Aluminum elec.id=2 work.func=0 \
    polygon = "0,0 1.5,0 1.5,-1.5 $x01,-1.5 $x01,0 $CELL,0 $CELL,-2 0,-2"
#region reg=5 name=ox1 mat=SiO2 \
    polygon = "1.5,0 1.75,0 1.75,-1 $x02,-1 $x02,0 $x01,0 $x01,-1.5 1.5,-1.5"
region reg=5 name=ox1 mat=SiO2 \
    polygon = "1.5,0 $x01,0 $x01,-1.5 1.5,-1.5"

region reg=6 name=gate mat=Aluminum \
    polygon = "1.75,-$ox_t 1.75,-1 $x02,-1 $x02,-$ox_t"

#region reg=7 name=ox2 mat=HfO2 \
    polygon = "1.5,0 1.75,0 1.75,-1 $x02,-1 $x02,0 $x01,0 $x01,-1.5 1.5,-1.5"

#set Meshing Parameters
#
base.mesh height=1 width=1
#
bound.cond !apply max.slope=$sub_y1 max.ratio=10 rnd.unit=0.000001 line.straightening=1 align.points when=automatic
#
#imp.refine min.spacing=0.02
#

imp.refine imp=netdoping scale=log min.spacing=0.04 sensitivity=0.2 transition=1E10

constr.mesh id=1 x1=0 y1=-2 x2=$CELL y2=3 default \
    max.height=0.2 max.width=0.2

constr.mesh id=2 x1=0 y1=-0.008 x2=$CELL y2=0.008 default \
    max.height=0.004 max.width=0.2

constr.mesh id=3 x1=0 y1=29 x2=$CELL y2=32 default \
    max.height=0.2 max.width=1











# build
mesh mode=meshbuild
struct outf = A_tmp_11.str
tonyplot A_tmp_11.str -set SET_str_dopant2.set
quit




