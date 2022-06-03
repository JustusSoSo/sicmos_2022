# To run on 4 processors, use:
    # go atlas simflags="-V 5.14.0.R -P 4"
    go atlas simflags = "-p 4"
    # IV normal forward diode application
    go atlas simflags = "-80 -p 8"









# model for MOSFET
    models srh
    # srh: recombination of Schottky Read Hall
    models cvt fermidirac
    # cvt: mobility
    # fermidirac: fermi and dirac statistics
    models conmob
    # cnomb: mobility with respect to concentration
    models fldmob
    # fldmob: mobility with respect to elec field
    models auger
    # Specifies Auger recombination
    models analytic
    # Specifies an analytic concentration dependent mobility model for silicon which includes temperature dependence
    models optr
    # Selects the optical recombination model. When this parameter is specified, the COPT parameter of the MATERIAL statement should be specified
    models bgn
    # Specifies bandgap narrowing model (see Equation 3-46) with Slotboom default values.
    #
    models print



    models QTUNN
        # This is the same as specifying QTUNN.EL, QTUNN.HO, and QTUNN.BBT. These models calculate the quantum tunneling current through an oxide.
    models srh
        # Specifies Shockley-Read-Hall recombination using fixed lifetimes
    models cvt fermidirac
        # cvt: mobility
        # fermidirac: fermi and dirac statistics
    models conmob
        # cnomb: mobility with respect to concentration
    models fldmob
        # fldmob: mobility with respect to elec field
    models auger
        # Specifies Auger recombination
    models analytic
        # Specifies an analytic concentration dependent mobility model for silicon which includes temperature dependence
    models optr
        # Selects the optical recombination model.
        # When this parameter is specified, the COPT parameter of the MATERIAL statement should be specified
    models bgn
        # Specifies bandgap narrowing model (see Equation 3-46) with Slotboom default values.

    INTERFACE THERMIONIC
        # Specifies that carrier transport across an interface is modeled by thermionic emission. This model will only be applied at semiconductor/semiconductor boundaries. See Section 6.2.2 “The Thermionic Emission and Field Emission Transport Model” for more information on thermionic emission.
    models consrh
        # Specifies Shockley-Read-Hall recombination using concentration dependent lifetimes

# model for MOSFET
















MODELS for Threshold
    models srh
    # srh: recombination of Schottky Read Hall
    models cvt fermidirac
    # cvt: mobility
    # fermidirac: fermi and dirac statistics
    models conmob
    # cnomb: mobility with respect to concentration
    models fldmob
    # fldmob: mobility with respect to elec field
    models auger
    # Specifies Auger recombination
    models analytic
    # Specifies an analytic concentration dependent mobility model for silicon which includes temperature dependence
    models optr
    # Selects the optical recombination model. When this parameter is specified, the COPT parameter of the MATERIAL statement should be specified
    models bgn
    # Specifies bandgap narrowing model (see Equation 3-46) with Slotboom default values.
    models print
MODELS for Threshold



MODELS for I-V at -10~10V
    # models
    models srh
    # Specifies Shockley-Read-Hall recombination using fixed lifetimes
    models cvt fermidirac
    # cvt: mobility
    # fermidirac: fermi and dirac statistics
    models conmob
    # cnomb: mobility with respect to concentration
    models fldmob
    # fldmob: mobility with respect to elec field
    models auger
    # Specifies Auger recombination
    models optr
    # Selects the optical recombination model.
    models analytic
    # Specifies an analytic concentration dependent mobility model for silicon which includes temperature dependence
    models bgn
    # Specifies bandgap narrowing model (see Equation 3-46) with Slotboom default values.
    models print
MODELS for I-V at -10~10V



MODELS for BV at 0~1600V
    models srh
    # srh: recombination of Schottky Read Hall
    models cvt fermidirac
    # cvt: mobility
    # fermidirac: fermi and dirac statistics
    models conmob
    # cnomb: mobility with respect to concentration
    models fldmob
    # fldmob: mobility with respect to elec field
    models auger
    # Specifies Auger recombination
    models analytic
    # Specifies an analytic concentration dependent mobility model for silicon which includes temperature dependence
    models optr
    # Selects the optical recombination model. When this parameter is specified, the COPT parameter of the MATERIAL statement should be specified
    models bgn
    # Specifies bandgap narrowing model (see Equation 3-46) with Slotboom default values.
    models temperature=300
    # models temp=300 CVT
    models CVT
    # Specifies that the CVT transverse field dependent mobility model is used for the simulation. The alias for this parameter is LSMMOB.
    models print
    #
    impact selb aniso sic4h0001 e.side
MODELS for BV at 0~1600V






















# method
# method newton trap maxtrap=5 itlimi=25
method newton trap maxtrap=5 itlimi=20
    # maxtrap参数定义计算的最大折半次数
    # itlimit表示最大计算次数（如果超了这个次数还没计算出来就折半，折半超过最大折半次数，计算失败。所以可以通过增大这个数值来延长计算量，但是感觉治标不治本）
# method newton trap climit=1e-4
# method newton trap ir.tol=1.e-25 ix.tol=1.e-25 climit=1e-4
# method zip.bicgst climit=1e-4 maxtraps=30 itlimit=30 ir.tol=1.e-30 ix.tol=1.e-30
# method block newton
# method newton trap climit=1e-4
















# solving
    # solve vstep=10 vfinal=400 name=drain cname=drain compliance=$tmp_compliance previous
    # solve vstep=20 vfinal=1220 name=drain cname=drain compliance=$tmp_compliance previous
    # solve vstep=10 vfinal=400 name=drain cname=drain compliance=1e-12 previous
    # solve vstep=20 vfinal=1220 name=drain cname=drain compliance=1e-12 previous
    # solve vstep=20 vfinal=1250 name=drain cname=drain compliance=1e-24 previous
    # compliance=1e-12

        # Warning: Convergence problem.  Taking smaller bias step(s).  Bias step reduced 1 times.
        # Sets a limit on the current from the electrode which has been specified by the CNAME or E.COMPLIANCE parameter. When the COMPLIANCE value is reached, any bias ramp is stopped and the program continues with the next line of the input file. The COMPLIANCE parameter is normally specified in A. If the GRAD parameter is specified, COMPLIANCE is specified in A/V.














