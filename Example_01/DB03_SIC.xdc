# (c) Silvaco Inc., 2015
# on DEVedit Application
go devedit
# DevEdit version=2.4.2.R

# the viewing Area in this Canvas
work.area x1=0 y1=-0.5 x2=7 y2=17
# 0-7
# 0.5-17

# REG is region
# MAT is material
# Pattern On black and white displays, pattern fills are used instead of colors. There are 18 patterns numbered 0 to 17. Pattern 0 (solid) and pattern 17 (empty) are normally not used. Each material has a default pattern, which will be used by the region if no pattern is set.
# Polygon is a shape (for example, four points)
# POINTS=<point_2d_list> is used for location of points making polygons that describe the region.
#
region reg=1 name=n+sub mat=4H-SiC color=0x7f00ff pattern=0x8 \
	polygon="6,11 6,16 0,16 0,11"

# id			the only ID for impurity  (can be deleted or replaced or added) for distinct regions
# reg.id		If no region.id parameter is given (the normal case), it applies to all regions.
# impurity		material
# peak			value
# ref			is the value of impurity at the given distance
# comb.func		describes how the x, y and z comb.funcrolloffs intersect. The possible values are: multiply, interpolate, or miter.
impurity id=1 region.id=1 imp=Arsenic \
	peak.value=1e+19 ref.value=1000000000000 comb.func=Multiply

# Define MESH dense
	# Sets limits (constraints) on triangles
	# created during mesh and refine operations
	# all material type constraints default to the global constraints
constr.mesh region=1 default
# global constr is default


# N drift
region reg=2 name=n-drift mat=4H-SiC color=0x7f00ff pattern=0x8 \
	polygon="5,3 6,3 6,11 0,11 0,2.5 5,2.5"

# impurity for REG 2:	V atom to be Ntype
impurity id=1 region.id=2 imp=Arsenic \
	peak.value=1e+16 ref.value=1000000000000 comb.func=Multiply

# mesh
constr.mesh region=2 default


# P BASE		type Boron
region reg=3 name=pbase mat=4H-SiC color=0x7f00ff pattern=0x8 \
		polygon=" \
				5,2.5 0,2.5 \
				0,0 1.5,0 \
				1.5,1 5,1"
impurity id=1 region.id=3 imp=Boron \
	peak.value=1e+17 ref.value=1000000000000 comb.func=Multiply
# max height of a triangle = 0.25um
constr.mesh region=3 default max.height=0.25







# N+ source ARSEN
region reg=4 name=n+source mat=4H-SiC color=0x7f00ff pattern=0x8 \
	polygon="5,1 1.5,1 1.5,0 4,0 5,0"
#
impurity id=1 region.id=4 imp=Arsenic \
	peak.value=1e+18 ref.value=1000000000000 comb.func=Multiply
# H W
constr.mesh region=4 default max.height=0.2 max.width=0.25





# Gate Oxide		silicon
region reg=5 name=gateox mat="Silicon Oxide" color=0xff pattern=0x2 \
	polygon="5.08,2.92 6,2.92 6,3 5,3 5,2.5 5,1 5,0 5.08,0"
#
constr.mesh region=5 default




# Gate poly
region reg=6 name=gate mat=PolySilicon elec.id=1 work.func=0 color=0xffff00 pattern=0x5 \
	polygon="6,2.92 5.08,2.92 5.08,0 6,0"
#
constr.mesh region=6 default




# metal source
region reg=7 name=source mat=Aluminum elec.id=2 work.func=0 color=0xffc8c8 pattern=0x7 \
	polygon="0,0 0,-0.5 4,-0.5 4,0 1.5,0"
#
constr.mesh region=7 default



# sub drain
# elec = 3(id)
# Used only if electrode.id is used to set work function for materials. This is not currently used by any simulators, however, may be used in future releases.
substrate name="drain" electrode=3 workfunction=0





















# Set Meshing Parameters
# to create a new mesh
# this is a tensor
base.mesh height=2 width=0.5
# automatic
bound.cond !apply max.slope=30 max.ratio=100 rnd.unit=0.001 line.straightening=1 align.points when=automatic
# meshing routine to see if triangles are small enough
imp.refine imp="Net Doping" scale=log transition=1e+10
imp.refine min.spacing=0.02

#
constr.mesh max.angle=90 max.ratio=300 \
			max.height=1000 \
			max.width=1000 \
			min.height=0.0001 \
			min.width=0.0001
#
constr.mesh type=Semiconductor default
#
constr.mesh type=Insulator default
#
constr.mesh type=Metal default
#
constr.mesh type=Other default

# reg
constr.mesh region=1 default
#
constr.mesh region=2 default
#
constr.mesh region=3 default max.height=0.25
#
constr.mesh region=4 default max.height=0.2 max.width=0.25
#
constr.mesh region=5 default
#
constr.mesh region=6 default
#
constr.mesh region=7 default
constr.mesh id=1 under.mat=PolySilicon depth=0.1 default max.height=0.02 max.width=0.2
constr.mesh id=2 x1=4.9 y1=0 x2=5 y2=3.5 default max.width=0.02
constr.mesh id=3 x1=0 y1=2 x2=5 y2=3.5 default max.height=0.1
constr.mesh id=4 x1=0 y1=10 x2=6 y2=12 default max.height=0.4
constr.mesh id=5 x1=5 y1=0 x2=5.15 y2=3.5 default max.width=0.02
Mesh Mode=MeshBuild


base.mesh height=2 width=0.5
bound.cond !apply max.slope=30 max.ratio=100 rnd.unit=0.001 line.straightening=1 align.Points when=automatic


struct outf = sicex0002.str
tonyplot sicex0002.str
# tonyplot sicex02_0.str
# -set sicex02_0.set
struct outfile = sicex02_0.str
# quit











































go atlas
# first statment title
# to be printed at the top of all Atlas printouts and screen displays.
TITLE : TRENCH MOSFET POWER DEVICE SIMULATION

# infile =
# Specifies the name of a previously generated mesh that has been saved to disk.
mesh infile=sicex02_0.str


#
material material=4H-SiC permitti=9.66 eg300=2.99 \
			edb=0.1 gcb=2 eab=0.2 gvb=4 \
			nsrhn=3e17 nsrhp=3e17 taun0=5e-10 taup0=1e-10 \
			tc.a=100




# Standard isotropic mobility in plane <1100>
#
mobility material=4H-SiC	vsatn=2e7 vsatp=2e7 betan=2 betap=2 \
			mu1n.caug=10  mu2n.caug=410 ncritn.caug=13e17  \
			deltan.caug=0.6 gamman.caug=0.0 \
			alphan.caug=-3 betan.caug=-3 \
			mu1p.caug=20   mu2p.caug=95  ncritp.caug=1e19 \
			deltap.caug=0.5  gammap.caug=0.0 \
			alphap.caug=-3 betap.caug=-3


# name is which electrode which is ohmic on N poly
contact name=gate n.poly
# region 6 name = gate







# print other models
models  analytic conmob fldmob srh auger fermi optr bgn print



# init 0V
solve    init
# prev using previous solution result
solve    prev

# method 1
method  newton

# gate electrode 's Voltage  1++
solve prev vfinal=20 name=gate vstep=1
save outf=sicex02_1.str





# method 2
method   newton trap maxtrap=10
log outf=sicex02_1.log










# another
solve prev vfinal=15 vstep=2.5 name=drain
output flowlines e.mobility h.mobility
save outf=sicex02_2.str


# another
solve prev vfinal=60 vstep=5 name=drain






quit


























