# SET
# in the beginning of the .in file, state "SET"s
# example:
















################ STRUCTURE ################
################
set N_sub       =1e19
# set N_drift     =8e15
set N_drift     =3e15
set P_well      =4.0e17
set P_plus      =1e19
set N_plus      =1e19
# y gauss func
# x error func
set CONC_FUNC_0=gauss
set CONC_FUNC_1=Error Function

######## 1. threshold ########
set P_factor    =0.80
set P_ch        =$P_factor * 1e17
set P_ch_t      =0.2

##############################
set SCH_w       =2.00
set N_w         =1.00
set P_w         =1.00
set CH_w        =0.50
set P_well_w    =$N_w+$P_w+$CH_w
set JFET_w      =0.50
set CELL_h      =$SCH_w+$P_well_w+$JFET_w
# set CELL        =$CELL_h * 2
set CELL        =10.00

set source_t            =2
set source_contact_t    =1.80
set oxide_top_t =0.5
set gate_t      =0.5

set N_t         =0.5
set P_t         =0.5
set P_well_t    =1.0
set N_drift_t   =6.0
set N_sub_t     =1.0
set drain_t     =1.0
set drain_t     =0.4
######## 1. threshold ########
# set oxide_t   =0.100
# set oxide_t   =0.06，0.07
set oxide_t     =0.05
##############################

######## 2.BV ########
########
######################
