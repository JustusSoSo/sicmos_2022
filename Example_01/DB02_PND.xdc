# 注意：centos难以支持中文字符



#启动仿真工具
go atlas

#定义网格
mesh
x.mesh location=0.00  spac=1.0
x.mesh location=1.00  spac=1.0
y.mesh location=0.00  spac=0.1
y.mesh location=10.00 spac=0.1

#定义材料
#硅材料
region num=1 silicon



#定义电极
#阳极在上方，阴极在底部
electrode name=anode top
electrode name=cathode bottom










#定义掺杂浓度
#所有区域n型均匀掺杂，浓度5.e16
#y方向5-10（p型杂质的底部是5um），是p型均匀掺杂，掺杂浓度5.e17
doping n.type conc=5.e16 uniform
doping p.type conc=5.e17 y.bottom=5.0 uniform

#让软件保存导带（ con.band）、价带（val.band）、电子和空穴准费米能级（QFN QFP）
output con.band val.band QFN QFP

#定义模型
#迁移率模型（conmob fldmob）、载流子复合模型（srh auger）、禁带宽度相关模型（ bgn）
#电阻只需要漂移电流
#但是PN结中，有漂移电流、扩散电流（扩散就有复合，所以需要复合模型）
model conmob fldmob srh auger bgn

#计算初始值
#这里没有加偏压，所以算的是PN结的平衡状态
solve init
method newton

# log保存solve的结果：
log   outfile = TEMP.log




# electrode name=anode top
# electrode name=cathode bottom
# 扫描V特性：
# anode voltage = 0.05v，步长0.05，终值1
# name = 扫描的电极名称
# solve      vanode=0.05  vstep=0.05  vfinal=10  name=anode
solve      vanode=-4 vstep=0.05  vfinal=4  name=anode

# 打开图表：log
# tonyplot diodeex01.log
tonyplot TEMP.log






#保存器件输出结构
save outf=diode.str
#画出器件结构
tonyplot diode.str
quit