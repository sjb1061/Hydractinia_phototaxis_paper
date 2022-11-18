#Welch two sample T-tests for hydractinia behavior data 
     #A t-test for two independent samples without an assumption of equal variances

#The before numbers are the number of larvae within 1cm of the light before the experiement 
#The after numbers are the number of larvae within 1cm of the light after the 8hr experiment

#Green 
#tot # of larvae = 776
g_before <- c(3,0,12,5,7)
g_after <- c(56,15,170,176,147)
t.test(g_before, g_after)
#data:  g_before and g_after
#t = -3.2904, df = 4.0306, p-value = 0.02987

#proportions of before and after with total number of larvae in experiement: before/tot #larva and after/tot # larva
g_prop_before <- c(0.036145, 0, 0.062827, 0.026042, 0.040698)
g_prop_after <- c(0.674699,0.108696,0.890052,0.916667,0.854651)
t.test(g_prop_before, g_prop_after)
#data:  g_prop_before and g_prop_after
#t = -4.3302, df = 4.0367, p-value = 0.0121



#Blue
#tot # of larvae = 859
b_before <- c(5,2,0,6,2,3)
b_after <- c(69,61,32,103,47,75)
t.test(b_before, b_after)
#data:  b_before and b_after
#t = -6.1382, df = 5.0803, p-value = 0.001575

#proportions of before and after with total number of larvae in experiement: before/tot #larva and after/tot # larva 
b_prop_before <- c(0.060241, 0.024096, 0, 0.031414, 0.010417,0.017442)
b_prop_after <- c(0.831325,0.73494,0.231884,0.539267,0.244792,0.436047)
t.test(b_prop_before, b_prop_after)
#data:  b_prop_before and b_prop_after
#t = -4.7152, df = 5.0706, p-value = 0.005079



#Red
#tot # of larvae = 555
r_before <- c(14,9,9)
r_after <- c(15,9,11)
t.test(r_before, r_after)
#data:  r_before and r_after
#t = -0.41208, df = 3.9872, p-value = 0.7015

#proportions of beforre and after with total number of larvae in experiement: before/tot #larva and after/tot # larva 
r_prop_before <- c(0.073298,0.046875,0.052326)
r_prop_after <- c(0.078534,0.046875,0.063953)
t.test(r_prop_before, r_prop_after)
#data:  r_prop_before and r_prop_after
#t = -0.46116, df = 3.9368, p-value = 0.669
