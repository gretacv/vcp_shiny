#get data
d_safe = read.csv("data/model_fit_safe-Table 1.csv") 
d_imp = read.csv("data/model_fit_important-Table 1.csv") 
d_eff = read.csv("data/model_fit_effective-Table 1.csv") 
all_regions = unique(d_safe$who_region)
