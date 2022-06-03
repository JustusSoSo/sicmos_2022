
# 6. transient
# Transient Response
    # SPICE like Interpreter: Mixed Mode
        # do not support EXTRACT and SET statements
    go atlas simflags="-P 16"
    # BEGIN of the circuit
    .begin

    # V gate voltage source
    # node 1 and 0
    # Keyword is PWL waveform
        # 0             0V
        # 1us           0V
        # 1us+0.01us    20V
        # 22.51us       20V
        # 22.52us       0V
        # 24us          0V
        # 24us+0.01us   20V
        # 26us          20V
        # 26us+0.01us   0V
        # 27us          0V
    Vg 1 0 pwl 0 0  10e-6 0  10.01e-6 20  22.51e-6 20  22.52e-6 0  24e-6 0  24.01e-6 20  26e-6 20  26.01e-6 0  27e-6 0
    # node 0 - source
    # node 2 - gate
    # node 3 - drain
    Amos1 0=source 2=gate 3=drain \
        infile=A_tmp_1.str width=0.3E6
    # Resistance g1 20 ohm
    # node 1 and node 2
    Rg1 1 2 20
    # node 3 - source
    # node 6 - gate
    # node 4 - drain
    Amos2 3=source 6=gate 4=drain \
        infile=A_tmp_1.str width=0.3E6
    # R g2
    # node 5 and 6
    Rg2 5 6 20
    # node 5 3
    Vgs2 5 3 -5
    # Capacitor
    # node 4 and 0
    C  4 0 42.3u
    # Vds source
    # node 4 and 0
    # 800Volts
    VDD 4 0 800
    # L
    # node 4 and 3
    L1 4 3 1mH
    #
    .numeric lte=0.3 toltr=1.e-4 vchange=2 IMAXDC=1000
    .options print relpot write=300
    # save time
    .save tsave=22.5us
    .save tsave=22.515us
    .save tsave=23us
    .save tsave=24.005us
    .save tsave=25us
    # log
    .log outfile=B_SICMOS01
    # save simulation result
    .save master=C_SICMOS01_FWD
    # which transient analysis to be performed
    # step = 50 ns
    # final = 28 us
    .tran 50ns 28us
    .end
    # END of the circuit
    models device=amos1 temp=300 CVT analytic conmob fldmob srh auger fermi optr bgn print
    models device=amos2 temp=300 CVT analytic conmob fldmob srh auger fermi optr bgn print
    impact device=amos1 selb gradqfl
    impact device=amos2 selb gradqfl
    go atlas
    tonyplot B_SICMOS01_tr.log-set SET_log_trans_01.set
    quit
# Transient Response


