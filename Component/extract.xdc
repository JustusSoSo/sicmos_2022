



# find MAX derivative
    # This further example calculates to the 2nd derivative.
    # extract name="dydx2" deriv(v."gate", i."drain", 2)
    # extract name="Second_Derivative" \
    #     max(deriv(i."drain", v."drain", 2)) \
    #     outfile="temp.dat"




# extract the forward ON voltage
    extract init infile="B_tmp_1.log"
    # extract name="d2V/dI2" \
    #     max(deriv(v."drain", i."drain", 2)) \
    #     outfile="temp.dat"
    extract name="d2V/dI2" \
        max(deriv(v."drain", i."drain", 2)) \
        outfile="B_tmp_11.log"
    extract init infile="B_tmp_11.log"
    tonyplot B_tmp_11.log
    # x.val from curve("dydx 2","drain bias")
    # extract name="VTurn-On" max(y.val)

# extract the forward ON voltage
    extract init infile="B_tmp_1.log"
    # extract name="d2V/dI2" \
    #     max(deriv(v."drain", i."drain", 2)) \
    #     outfile="temp.dat"
    extract name="d2V/dI2" \
        max(deriv(v."drain", i."drain", 2)) \
        outfile="B_tmp_1_deriv.log"
    extract init infile="B_tmp_1_deriv.log"
    # the minimum of the derivative is where the Knee voltage reached
    tonyplot B_tmp_1_deriv.log

















find MAX of something and give the x or y there
    # The following command creates a collector current against collector current divided by base current curve and calculates the intercepting collector current where Ic/Ib is at a maximum value.
    # extract name="Ic at Ic/Ib[Max]" x.val from curve(i."collector", i."collector"/i."base") where y.val=max(i."collector"/i."base")
    # extract name="VTurn-On" \
    #     x.val from curve \
    #     (i."drain", i."drain"/v."drain") \
    #     where y.val=max(i."drain"/v."drain")























extract init infile="B_tmp_1.log"
#
# extract name="N_VBreakdown" x.val from curve(abs(v."drain"),abs(i."drain")) where y.val=1e-12
# extract name="N_VBreakdown" x.val from curve(abs(v."drain"),abs(i."drain")) where y.val=1e-11
# extract name="N_VBreakdown" x.val from curve(abs(v."drain"),abs(i."drain")) where y.val=1e-9
# extract name="N_VBreakdown" x.val from curve(abs(v."drain"),abs(i."drain")) where y.val=1e-9


