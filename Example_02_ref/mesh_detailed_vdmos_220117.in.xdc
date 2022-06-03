go DevEdit
set N_sub=1e19
set P_well=1e19
set P_body=1e18
set N_well=1e19
set NDRIFT=9E15
set N_t=0.5
set N_w=1
set P_t=0.5
set P_w=1
set Channel=0.5
set ox_t=0.056
set gate_t=0.5
set JFET=2
set P_body_w=$N_w+$P_w+$Channel
set P_body_t=1
set CELL=$JFET+$P_body_w+$P_body_w
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

region reg=1 name=drain mat=Aluminum elec.id=1 work.func=0 \
    polygon="0,31 $CELL,31 $CELL,32 0,32"

region reg=2 name=substrate mat=4H-SiC \
    polygon="0,30 $CELL,30 $CELL,31 0,31"
impurity id=1 reg.id=2 imp=Phosphorus \
    peak.value=$N_sub ref.value=$N_sub comb.func=Multiply


region reg=3 name=N_drift mat=4H-SiC \
    polygon="0,0 $CELL,0 $CELL,30 0,30"
impurity id=2 reg.id=3 imp=Phosphorus \
    peak.value=$NDRIFT ref.value=$NDRIFT comb.func=Multiply

impurity id=3 reg.id=3 imp=Boron \
    peak.value=$P_body ref.value=$P_body comb.func=Multiply \
    y1=0 y2=$P_body_t rolloff.y=both conc.func.y="Gaussian" conc.param.y=0.05 \
    x1=0 x2=$P_body_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01
impurity id=4 reg.id=3 imp=Boron \
    peak.value=$P_body ref.value=$P_body comb.func=Multiply \
    y1=0 y2=$P_body_t rolloff.y=both conc.func.y="Gaussian" conc.param.y=0.05 \
    x1=$CELL-$P_body_w x2=$CELL rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01

impurity id=5 reg.id=3 imp=Boron \
    peak.value=$P_well ref.value=$NDRIFT comb.func=Multiply \
    y1=0 y2=$P_t rolloff.y=both conc.func.y="Gaussian" conc.param.y=0.1 \
    x1=0 x2=$P_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01
impurity id=6 reg.id=3 imp=Boron \
    peak.value=$P_well ref.value=$NDRIFT comb.func=Multiply \
    y1=0 y2=$P_t rolloff.y=both conc.func.y="Gaussian" conc.param.y=0.1 \
    x1=$CELL-$P_w x2=$CELL rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01

impurity id=7 reg.id=3 imp=Phosphorus \
    peak.value=$N_well ref.value=$NDRIFT comb.func=Multiply \
    y1=0 y2=$N_t rolloff.y=both conc.func.y="Gaussian" conc.param.y=0.1 \
    x1=$P_w x2=$P_w+$N_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01
impurity id=8 reg.id=3 imp=Phosphorus \
    peak.value=$N_well ref.value=$NDRIFT comb.func=Multiply \
    y1=0 y2=$N_t rolloff.y=both conc.func.y="Gaussian" conc.param.y=0.1 \
    x1=$CELL-($P_w+$N_w) x2=$CELL-$P_w rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01

region reg=4 name=source mat=Aluminum elec.id=2 work.func=0 \
    polygon = "0,0 1.5,0 1.5,-1.5 $x01,-1.5 $x01,0 $CELL,0 $CELL,-2 0,-2"
#region reg=5 name=ox1 mat=HfO2 \
    polygon = "1.5,0 1.75,0 1.75,-1 $x02,-1 $x02,0 $x01,0 $x01,-1.5 1.5,-1.5"
region reg=5 name=ox1 mat=HfO2 \
    polygon = "1.5,0 $x01,0 $x01,-1.5 1.5,-1.5"

region reg=6 name=gate mat=Aluminum \
    polygon = "1.75,-$ox_t 1.75,-1 $x02,-1 $x02,-$ox_t"

#region reg=7 name=ox2 mat=HfO2 \
    polygon = "1.5,0 1.75,0 1.75,-1 $x02,-1 $x02,0 $x01,0 $x01,-1.5 1.5,-1.5"

#set Meshing Parameters
#
base.mesh height=1 width=1
#
bound.cond !apply max.slope=30 max.ratio=10 rnd.unit=0.000001 line.straightening=1 align.points when=automatic
#
imp.refine min.spacing=0.02
#

#all_back
constr.mesh id=1 x1=0 y1=-2 x2=$CELL y2=12 default \
    max.height=0.5 max.width=1

#source&&gate
constr.mesh id=2 x1=0 y1=0 x2=$CELL y2=-2 default \
    max.height=0.5 max.width=0.5

#oxide_layer
constr.mesh id=3 x1=1.5 y1=-0.1 x2=$x01 y2=0.1 default \
    max.height=0.02 max.width=0.05

#N_well&P_well
constr.mesh id=4 x1=0 y1=0.1 x2=$P_w+$N_w y2=$P_t default \
    max.height=0.5 max.width=0.1
constr.mesh id=5 x1=$CELL-($P_w+$N_w) y1=0.1 x2=$CELL y2=$P_t default \
    max.height=0.5 max.width=0.1

#P_body_1
constr.mesh id=6 x1=0 y1=$P_t x2=$P_w+$N_w y2=$P_body_t default \
    max.height=0.1 max.width=0.1
constr.mesh id=7 x1=$CELL y1=$P_t x2=$CELL-($P_w+$N_w) y2=$P_body_t default \
    max.height=0.1 max.width=0.1

#Channel
constr.mesh id=8 x1=$P_w+$N_w y1=0 x2=$P_body_w y2=$P_t default \
    max.height=0.05 max.width=0.05
constr.mesh id=9 x1=$CELL-($P_w+$N_w) y1=0 x2=$CELL-$P_body_w y2=$P_t default \
    max.height=0.05 max.width=0.05

#P_body_2
constr.mesh id=10 x1=$P_w+$N_w y1=$P_t x2=$P_body_w y2=$P_body_t default \
    max.height=0.1 max.width=0.1
constr.mesh id=11 x1=$CELL-($P_w+$N_w) y1=$P_t x2=$CELL-$P_body_w y2=$P_body_t default \
    max.height=0.1 max.width=0.1

#JFET_region
constr.mesh id=12 x1=$P_body_w y1=0.1 x2=$CELL-$P_body_w y2=$P_t default \
    max.height=0.05 max.width=0.05
constr.mesh id=13 x1=$P_body_w y1=$P_t x2=$CELL-$P_body_w y2=$P_body_t default \
    max.height=0.2 max.width=0.2

#contact_field
#P_well&&N_well
constr.mesh id=15 x1=$x03 y1=0 x2=$x04 y2=0.7 default \
    max.height=0.01 max.width=0.05
constr.mesh id=16 x1=$x05 y1=0 x2=$x06 y2=0.7 default \
    max.height=0.01 max.width=0.05

#N_well&&P_body
constr.mesh id=17 x1=$x03 y1=$y02 x2=$x07 y2=$y01 default \
    max.height=0.05 max.width=0.01
constr.mesh id=18 x1=$x09 y1=$y02 x2=$x05 y2=$y01 default \
    max.height=0.05 max.width=0.01

#P_well&&P_body
constr.mesh id=19 x1=0 y1=$y02 x2=$P_w y2=$y01 default \
    max.height=0.05 max.width=0.01
constr.mesh id=20 x1=$x06 y1=$y02  x2=$CELL y2=$y01 default \
    max.height=0.05 max.width=0.01

#P_body&&N_drift
constr.mesh id=21 x1=0 y1=$y04 x2=$P_body_w y2=$y03 default \
    max.height=0.05 max.width=0.01
constr.mesh id=22 x1=$x06 y1=$y04 x2=$CELL y2=$y03 default \
    max.height=0.05 max.width=0.01
constr.mesh id=23 x1=$x12 y1=0 x2=$x11 y2=$y04 default \
    max.height=0.05 max.width=0.01
constr.mesh id=24 x1=$x13 y1=0 x2=$x14 y2=$y04 default \
    max.height=0.05 max.width=0.01


Mesh Mode=MeshBuild

struct outf=vdmos.str

quit

