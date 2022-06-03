# (c) Silvaco Inc., 2015
go atlas

mesh

x.mesh loc=0.0   spac=10
x.mesh loc=10.0  spac=10

y.mesh loc=0.0   spac=2.5
y.mesh loc=185   spac=3.5
y.mesh loc=370.0 spac=2.0

region     num=1 silicon
#
elec       num=1 top name=cathode
elec       num=2 bottom name=anode
#
#   Impurity profile
#
doping  uniform conc=1.e14    n.type
doping  gauss conc=2.e19 n.type char=7
doping  gauss conc=2.e19 p.type peak=370 junc=350
save outf=powerex01.str master.out




















go atlas
.begin
#
#  Steady-state simulation of circuit with power diode
#
v1 1 0  1000.
r1 1 2  1m
l1 2 3  3nH
adiode  3=cathode 4=anode width=5.e7 infile=powerex01.str
r2 4 0  1mg
i1 0 4  300.
#
.nodeset v(1)=1000. v(2)=1000. v(3)=1000. v(4)=1000.5
.numeric vchange=0.1
#
.save outfile=powerex01_save
.options m2ln print
.end
#
models device=adiode reg=1 conmob fldmob consrh auger bgn
material device=adiode reg=1 taun0=5e-6 taup0=2e-6
#
impact device=adiode reg=1 selb


go atlas
.begin
#
#   Reverse recovery of power diode
#
v1 1 0  1000.
r1 1 2  1m
l1 2 3  3nH
adiode  3=cathode 4=anode width=5.e7 infile=powerex01.str
r2 4 0  1mg EXP 1mg 1e-3 0. 20ns 10 200
i1 0 4  300
#
.numeric lte=0.3 toltr=1.e-5 vchange=10.
.options print relpot write=10
#
.log outfile=powerex01
.load infile=powerex01_save
.save master=powerex01
#
.tran 0.1ns 2us
#
.end

models device=adiode reg=1 conmob fldmob consrh auger bgn
material device=adiode reg=1 taun0=5e-6 taup0=2e-6
impact device=adiode reg=1 selb


go atlas
tonyplot powerex01_tr.log -set powerex01.set

quit
