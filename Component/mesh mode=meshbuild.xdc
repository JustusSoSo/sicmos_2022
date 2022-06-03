# MESH
# base.mesh ... mesh mode=meshbuild






# constr.mesh statements:
	# in the end of each region, add these:
	constr.mesh reg=8 default max.height=0.2 max.width=0.25
	constr.mesh reg=9 default max.height=0.2 max.width=0.25














# an example:
# after region and impurity, now build the mesh:


# set Meshing Parameters
# base.mesh height=1 width=0.5
base.mesh height=1 width=1
    # max H and W
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
constr.mesh id=31 \
    x1=0 \
    x2=$P_well_w+$tmp_x_delta \
    y1=$P_well_t-$tmp_delta \
    y2=$P_well_t+$tmp_delta default \
    max.height=0.05 max.width=0.01
constr.mesh id=32 \
    x1=$P_well_2_x1-$tmp_x_delta \
    x2=$P_well_2_x2 \
    y1=$P_well_t-$tmp_delta \
    y2=$P_well_t+$tmp_delta default \
    max.height=0.05 max.width=0.01
# vertical lines
constr.mesh id=33 \
    x1=$P_well_w-$tmp_delta \
    x2=$P_well_w+$tmp_delta \
    y1=0 y2=$P_well_t-$tmp_delta default \
    max.height=0.05 max.width=0.01
constr.mesh id=34 \
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










































MESH for the SBD MOSFET
#### setting Meshing Parameters ####
    base.mesh width=1 height=1
    # base.mesh width=1 height=0.5
    bound.cond !apply max.slope=30 max.ratio=10 rnd.unit=1E-6 line.straightening=1 align.points when=automatic
    imp.refine imp=netdoping scale=log min.spacing=0.04 sensitivity=0.2 transition=1E10
    # global constraints
    constr.mesh max.angle=90 max.ratio=300
    # material type constraints
        # doesn't matter
        # constr.mesh type=Semiconductor default
        # constr.mesh type=Insulator default
        # constr.mesh type=Metal default
        # constr.mesh type=Other default
    # region specific constraints
        # source&&gate
        constr.mesh id=1 \
            x1=0 y1=0 \
            x2=$CELL y2=-$source_t \
            default \
            max.height=0.5 \
            max.width=0.5
        #oxide_layer
        set tmp_delta=0.1
        set tmp_constr_param_y=0.02
        set tmp_constr_param_x=0.05
        constr.mesh id=2 \
            x1=$oxide_x1 y1=-$tmp_delta \
            x2=$oxide_x2 y2=$tmp_delta \
            default \
            max.height=$tmp_constr_param_y \
            max.width=$tmp_constr_param_x
            # max.height=0.02 max.width=0.05

    # from zero to the bottom of P well
    set tmp_constr_param_x=0.1
    set tmp_constr_param_y=0.1
    set tmp_delta=0.2
    constr.mesh id=3 \
        x1=0 x2=$CELL \
        y1=0 y2=$P_well_t+$tmp_delta \
        default \
        max.width=$tmp_constr_param_x \
        max.height=$tmp_constr_param_y
    # constr.mesh id=5 \
    #     x1=0 y1=$P_t x2=$P_w+$N_w y2=$P_body_t default \
    #     max.height=0.1 max.width=0.1
    # constr.mesh id=6 \
    #     x1=$CELL y1=$P_t x2=$CELL-($P_w+$N_w) y2=$P_body_t default \
    #     max.height=0.1 max.width=0.1

    # form the Channel top to the bottom of P plus in Channel
    set tmp_constr_param_x=0.05
    set tmp_constr_param_y=0.05
    set tmp_constr_param_x=0.005
    set tmp_constr_param_y=0.005
    # set tmp_constr_param_x=0.05
    # set tmp_constr_param_y=0.01
    constr.mesh id=11 \
        x1=$P_CH_1_x1 \
        x2=$P_CH_1_x2 \
        y1=0 y2=$P_t \
        default \
        max.width=$tmp_constr_param_x \
        max.height=$tmp_constr_param_y
    # max.height=0.05 max.width=0.05
    constr.mesh id=12 \
        x1=$P_CH_2_x1 \
        x2=$P_CH_2_x2 \
        y1=0 y2=$P_t \
        max.width=$tmp_constr_param_x \
        max.height=$tmp_constr_param_y
    # max.height=0.05 max.width=0.05

    # # N plus P plus
    # set tmp_constr_param_y=0.5
    # set tmp_constr_param_x=0.1
    # constr.mesh id=3 \
    #     x1=$P_plus_1_x1 x2=$N_plus_1_x2 \
    #     y1=0 y2=$P_t \
    #     default \
    #     max.height=$tmp_constr_param_y \
    #     max.width=$tmp_constr_param_x
    # constr.mesh id=4 \
    #     x1=$N_plus_2_x1 x2=$P_plus_2_x2 \
    #     y1=0 y2=$P_t \
    #     default \
    #     max.height=$tmp_constr_param_y \
    #     max.width=$tmp_constr_param_x

    #JFET_region
    set tmp_constr_param_y=0.05
    set tmp_constr_param_x=0.05
    constr.mesh id=21 \
        y1=0.1 \
        y2=$P_t \
        x1=$P_well_1_x2 \
        x2=$P_well_2_x1 \
        default \
        max.height=$tmp_constr_param_y \
        max.width=$tmp_constr_param_x
        # max.height=0.05 max.width=0.05
    set tmp_constr_param_y=0.2
    set tmp_constr_param_x=0.2
    constr.mesh id=22 \
        x1=$P_well_1_x2 \
        x2=$P_well_2_x1 \
        y1=$P_t \
        y2=$P_well_t \
        default \
        max.height=$tmp_constr_param_y \
        max.width=$tmp_constr_param_x
        # max.height=0.2 max.width=0.2
    mesh mode=meshbuild
#### setting Meshing Parameters ####