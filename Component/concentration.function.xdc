# IMPURITY



# CONC.FUNC.X
# CONC.FUNC.Y
	# options：
		# “Gaussian” gauss
		# “Gaussian (Dist)” gauss.dist
		# “Error Function” erfc
		# “Error Function (Dist)” erfc.dist
		# “Linear (Dist)” dist
		# “Logarithmic” log
		# “Logarithmic (Dist)” log.dist
		# “Exponential exp
		# “Exponential (Dist)” exp.dist
		# “Step Function”
		# "Error Function"
	# setting
		set CONC_FUNC_0=gauss
		set CONC_FUNC_0=erfc
		set CONC_FUNC_0=log
		set CONC_FUNC_0=Step Function
		set CONC_FUNC_0=gauss
		set CONC_FUNC_1=Error Function

# CONC.PARAM.X
# CONC.PARAM.Y
	# 梯度单位数值，梯度单位越小，边界越精确
	# 如果遇到问题：边界出现跃边，则：
		# 1.调整CONF.FUNC
		# 2.调节CONC.PARAM变得更小
conc.param.y=0.01









# example setting region and impurity
region reg=11 name=P_CH_2 mat=4H-SiC \
    polygon="$P_CH_2_x1,0 $P_CH_2_x2,0 $P_CH_2_x2,$P_ch_t $P_CH_2_x1,$P_ch_t"
impurity id=22 reg.id=11 imp=Boron \
    peak.value=$P_ch ref.value=$P_ch comb.func=Multiply \
    y1=0            y2=$P_ch_t    rolloff.y=both conc.func.y="Error Function" conc.param.y=0.01 \
    x1=$P_CH_2_x1   x2=$P_CH_2_x2 rolloff.x=both conc.func.x="Error Function" conc.param.x=0.01











# example setting CONC_FUNC_0 beforehand
	set P_plus_2_x1=$CELL-$P_w
	impurity id=4 reg.id=3 imp=Boron \
		peak.value=$P_plus ref.value=$P_plus comb.func=Multiply \
		x1=0 \
		x2=$P_w \
		rolloff.x=both conc.func.x=$CONC_FUNC_0 \
		conc.param.x=0.01 \
		y1=0 \
		y2=$P_t \
		rolloff.y=both conc.func.y=$CONC_FUNC_0 \
		conc.param.y=0.01
	impurity id=5 reg.id=3 imp=Boron \
		peak.value=$P_plus ref.value=$P_plus comb.func=Multiply \
		x1=$P_plus_2_x1 \
		x2=$CELL \
		rolloff.x=both conc.func.x=$CONC_FUNC_0 \
		conc.param.x=0.01 \
		y1=0 \
		y2=$P_t \
		rolloff.y=both conc.func.y=$CONC_FUNC_0 \
		conc.param.y=0.01
		# rolloff.x=both conc.func.x=$CONC_FUNC_0 \
		# rolloff.y=both conc.func.y=$CONC_FUNC_0 \


