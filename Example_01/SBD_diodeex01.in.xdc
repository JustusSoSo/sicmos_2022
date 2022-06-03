# (c) Silvaco Inc., 2015


go atlas

mesh  space.mult=1.0
#
x.mesh loc=0.00 spac=0.5
x.mesh loc=3.00 spac=0.2
x.mesh loc=5.00 spac=0.25
x.mesh loc=7.00 spac=0.25
x.mesh loc=9.00 spac=0.2
x.mesh loc=12.00 spac=0.5
#
y.mesh loc=0.00 spac=0.1
y.mesh loc=1.00 spac=0.1
y.mesh loc=2.00 spac=0.2
y.mesh loc=5.00 spac=0.4

region  num=1  silicon

electr  name=anode  x.min=5  length=2
electr  name=cathode  bot
#....   N-epi doping
doping  n.type conc=5.e16 uniform

#....   Guardring doping
doping   p.type conc=1e19 x.min=0 x.max=3  junc=1 rat=0.6 gauss
doping   p.type conc=1e19 x.min=9 x.max=12 junc=1 rat=0.6 gauss

#....   N+ doping
doping  n.type conc=1e20 x.min=0 x.max=12 y.top=2 y.bottom=5 uniform


# since the substrate is n-type silicon with an affinity of 4.17, the specified workfunction of 4.97 provides a Schottky-barrier height of 0.8V.

# contact name=anode workf=8.97
# contact    name=anode workf=4.97
contact name=anode workf=4.17 + 3.0
contact name=anode workf=4.17 + 2.0


model    conmob  fldmob  srh  auger  bgn
solve      init
method newton

output con.band val.band band.param
struct outf = B_tmp_1.str
tonyplot B_tmp_1.str -set SET_str.set





solve init previous

log outfile=B_tmp_1.log
	solve vanode=0.02 previous
	solve vstep=0.02 vfinal=2.0 \
		name=anode previous
log close
tonyplot B_tmp_1.log -set SET_log_Vgs=0_Ids-Vds.set
quit


















