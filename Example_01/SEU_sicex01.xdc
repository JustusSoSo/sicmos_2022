go atlas

mesh

x.mesh location=0 spacing=0.2
x.mesh location=1 spacing=0.2

y.mesh location=0   spacing=0.2
y.mesh location=2   spacing=0.01
y.mesh location=75  spacing=10
y.mesh location=152 spacing=0.2

region number=1 material=4H-SiC

electrode name=anode top
electrode name=cathode bottom

doping conc=2e19 p.type uniform y.max=2
doping conc=8e14 n.type uniform y.min=2 y.max=150
doping conc=2e19 n.type uniform y.min=152

save outf=sicex01_0.str

extract name="t1" clock.time


