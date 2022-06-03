####
# 注意：centos难以支持中文字符
################################
# in XDC format
################################
# 加 \换行






# 结构生成
################################
# 0. GO 仿真器APP名称是ATLAS
go atlas


################################
# 2. 区域：定义一个可以调用的区域
region  num=1  silicon
# 序号是1，名称是silicon
# region num=2 y.min=0.5 y.max=1.0 x.min=0 x.max=1.0 oxide



################################
# 4. 掺杂
#....   N-epi doping
doping  n.type conc=5.e16 uniform
# concentration = 5.0 e16
# 均匀掺杂

#....   Guard Ring doping
doping   p.type conc=1e19 x.min=0  x.max=3  junc=1 rat=0.6 gauss
# 0 -3		Junction = 1
doping   p.type conc=1e19 x.min=9 x.max=12 junc=1 rat=0.6 gauss
# 9 - 12

#....   N+ doping
doping  n.type conc=1e20 x.min=0 x.max=12 y.top=2 y.bottom=5 uniform





################################
# 3. 电极
# elec name=gate x.min=0.25 lenght=0.5
# 例如 名称是gate，从x=0.25开始，到右边的长度0.5

# 阳极阴极
electr  name=anode  x.min=5  length=2
electr  name=cathode  bot

# bottom，是剖面的位置，底部剖面
# 还有：
# top left right substrate















# 1. 网格，且网格个数 <= 20,000 个
# space.mult = 1，网格的比例因子是1
mesh  space.mult=1.0

# 单位：微米
# location是x方向起始位置，spacing是单位步长
# X 从左到右；Y从上到下
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


################################
# 5. gen structure
save outf = diodeex01_0.str

# Plot this diode structure
# using set
# tonyplot diodeex01_0.str -set diodeex01_0.set
tonyplot diodeex01_0.str















# 电极和半导体接触，名为andoe的电极，金属侧的功函数是4.97ev
contact    name=anode workf=4.97






# 仿真：
# 仿真所用的：contact 材料特性 物理model
################################
# model物理模型，特定的技术，有对应的简单模型
# Physics
model    conmob  fldmob srh  auger  bgn




# 非线性计算方法是牛顿法
method newton

# solve 获取器件的特性（IV），针对一些外部电极，设置偏置

# 直流：
# init： 所有电极 = 0V
solve      init






# vfinal=1
# solve previous





# log保存solve的结果：
log   outfile = diodeex01.log
# save str



# 扫描V特性：
# anode voltage = 0.05v，步长0.05，终值1
# name = 扫描的电极名称
solve      vanode=0.05  vstep=0.05  vfinal=1  name=anode





# 打开图表：log
tonyplot diodeex01.log
# -set diodeex01_log.set




quit
# exit仿真器APP：ATLAS，与GO对应




































# (c) Silvaco Inc., 2015
go atlas

# mesh  space.mult=1.0
# #
# x.mesh loc=0.00 spac=0.5
# x.mesh loc=3.00 spac=0.2
# x.mesh loc=5.00 spac=0.25
# x.mesh loc=7.00 spac=0.25
# x.mesh loc=9.00 spac=0.2
# x.mesh loc=12.00 spac=0.5
# #
# y.mesh loc=0.00 spac=0.1
# y.mesh loc=1.00 spac=0.1
# y.mesh loc=2.00 spac=0.2
# y.mesh loc=5.00 spac=0.4


region  num=1  silicon

electr  name=anode  x.min=5  length=2
electr  name=cathode  bot

#....   N-epi doping
doping  n.type conc=5.e16 uniform

#....   Guardring doping
doping   p.type conc=1e19 x.min=0  x.max=3  junc=1 rat=0.6 gauss
doping   p.type conc=1e19 x.min=9 x.max=12 junc=1 rat=0.6 gauss

#....   N+ doping
doping  n.type conc=1e20 x.min=0 x.max=12 y.top=2 y.bottom=5 uniform

save outf=diodeex01_0.str
tonyplot diodeex01_0.str -set diodeex01_0.set


model    conmob  fldmob  srh  auger  bgn
contact    name=anode workf=4.97

solve      init

method newton

log   outfile=diodeex01.log
solve      vanode=0.05  vstep=0.05  vfinal=1  name=anode
tonyplot diodeex01.log -set diodeex01_log.set
quit








