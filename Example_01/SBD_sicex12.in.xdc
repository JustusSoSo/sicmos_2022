set temp1=240
set temp1=300
go atlas

mesh space.mult=2
x.mesh location=0 spacing=0.2
x.mesh location=1 spacing=0.2

y.mesh location=0   spacing=0.01
y.mesh location=5   spacing=0.1
y.mesh location=10   spacing=0.5
y.mesh location=11   spacing=0.1
y.mesh location=12   spacing=0.1

region number=1 material=4H-SiC

electrode name=anode top
electrode name=cathode bottom

doping conc=5e14 n.type uniform
doping conc=1e20 n.type uniform y.min=11

set affin=3.6
material material=4H-SiC taun0=5e-10 taup0=1e-10  m.dsn=0.4 m.dsp=2.5 eg300=3.25 affinity=$affin egalpha=9.06e-4 egbeta=2.03e3
models print temp=$temp1


################################################
# Trap
# trap region=1 acceptor e.level=0.66 density=1.0e13 sign=5.6e-15 sigp=5.6e-15 degen=1

################################################
# barrier height 1.2eV --> WF=$affin +  1.2 eV
contact name=anode workfunc=$affin+1.2
contact name=anode workfunc=$affin+10.2



model    conmob  fldmob  srh  auger  bgn
# method newton
solve init
output con.band val.band
# output band.temp
# output con.band
struct outf = B_tmp_1.str
tonyplot B_tmp_1.str -set SET_str.set



# method climit=1e-4 ir.tol=1e-22 tol.time=1e9 dt.max=2e5
solve init previous
log outfile=B_tmp_1.log
	solve vanode=0.1 previous
	solve vstep=0.1 vfinal=2.0 \
		name=anode previous
log close
tonyplot B_tmp_1.log -set SET_log_Vgs=0_Ids-Vds.set
quit














































































































# (c) Silvaco Inc., 2015
# Simulation of DLTS (Deep Level Transient Spectroscopy)
# for SBD (Schottky Barrier Diode) with Z1/Z2 center of Carbon Vacancy
# Trap Energy Level= Ec - 0.66 [eV]
#
#

set temp1=240
set temp2=400
set nstep=32
set dtemp=($temp2 -$temp1)/$nstep

loop steps=$nstep
set temp1 = $temp1 + $dtemp

go atlas

mesh space.mult=2
x.mesh location=0 spacing=0.2
x.mesh location=1 spacing=0.2

y.mesh location=0   spacing=0.01
y.mesh location=5   spacing=0.1
y.mesh location=10   spacing=0.5
y.mesh location=11   spacing=0.1
y.mesh location=12   spacing=0.1

region number=1 material=4H-SiC

electrode name=anode top
electrode name=cathode bottom

doping conc=5e14 n.type uniform
doping conc=1e20 n.type uniform y.min=11

set affin=3.6
material material=4H-SiC taun0=5e-10 taup0=1e-10  m.dsn=0.4 m.dsp=2.5 eg300=3.25 affinity=$affin egalpha=9.06e-4 egbeta=2.03e3
models print temp=$temp1

# Trap
trap region=1 acceptor e.level=0.66 density=1.0e13 sign=5.6e-15 sigp=5.6e-15 degen=1

# barrier height 1.2eV --> WF=$affin +  1.2 eV
contact name=anode workfunc=1.2+$affin

output band.temp

method climit=1e-4 ir.tol=1e-22 tol.time=1e9 dt.max=2e5

solve init
solve previous
save outfile=sicex12_0V_$"temp1".str

solve vstep=-1 vfinal=-8 name=anode ac freq=1e5
save outfile=sicex12_trans_0_$"temp1".str

log outfile=sicex12_DLTS_$"temp1".log
load infile=sicex12_trans_0_$"temp1".str
solve vanode=0.0 ramptime=1e-9 dt=1e-10 tfinal=1e-2 ac freq=1e5
solve vanode=-8 ramptime=1e-9 dt=1e-10 tfinal=1.0 ac freq=1e5
log off

l.end


system echo "Capacitance Change vs Temperature" >> sicex12.dat
system echo "$"nstep""  2  2 >> sicex12.dat
system echo "Temperature [K]" >> sicex12.dat
system echo "Capacitance Change [F]" >> sicex12.dat

set temp1=240

loop steps=$nstep
set temp1= $temp1 + $dtemp

extract init infile="sicex12_DLTS_$'temp1'.log"
extract name="C1" y.val from curve(time, c."cathode""anode") where x.val=2.0e-2
extract name="C2" y.val from curve(time, c."cathode""anode") where x.val=2.2e-1
extract name="DLTS_a"  $C2 - $C1 outfile="sicex12_b.dat"

system echo "$"temp1" $"DLTS_a"  ">> sicex12.dat

l.end


tonyplot -overlay sicex12_DLTS_280.log sicex12_DLTS_300.log sicex12_DLTS_310.log sicex12_DLTS_320.log -set sicex12_0.set
tonyplot sicex12.dat -set sicex12_1.set


