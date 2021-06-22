# load ----
# detach("package:groundfishr", unload=TRUE)
library(groundfishr)

# database connect ----
afsc_user = "your_afsc_username"
afsc_pwd = "your_afsc_pwd"
akfin_user = "your_afsc_username"
akfin_pwd = "your_afsc_pwd"

# globals ----
year <- 2021
species <- "REBS"
rec_age <- 3
plus_age <- 42
TAC <- c(1328, 1327, 1444) # last three years of tac year-2, year-2, year-1
admb_home <- "C:/Program Files (x86)/ADMB-12.1" # your location and version may be different
model_name <- "updated_rebs" # best to shorten this if 
dat_name <- "goa_rebs_2021" 

# setup ----
setup(year)

# data ----
# raw data query ~ 10 minutes wait or so...
# these files all end up in the "data/raw" folder and end with _data.csv

goa_rebs(year, akfin_user, akfin_pwd, afsc_user, afsc_pwd)

# clean and process datatdata ----
# these data all end up in the "data/output" folder

# catch 
clean_catch(year = year, species = species, TAC = TAC)

# survey biomass 
ts_biomass(year) # this is the design-based model, must provide separate file for VAST...
lls_rpw(year, survey = "goa") # this is what was originally provided in the code, sounds like you may have an update?!
lls_rpn(year, survey = "goa")

# biological data 
# age error model needs to be run first the file should be placed in "data/user_input" folder
# it currently forces you to navigate to the file and click on it - I'll change that...
age_error(reader_tester = "reader_tester_old.csv", species = species, year = year, admb_home = admb_home)  
size_at_age(year, admb_home, rec_age, lenbins = "len_bin_labels.csv")
weight_at_age(year, admb_home, rec_age, region = "goa")

fish_age_comp(year, fishery = "fsh1", rec_age, plus_age)
ts_age_comp(year, area = "goa", rec_age, plus_age)

fish_length_comp(year, fishery = "fsh1", rec_age, lenbins = "len_bin_labels.csv")
ts_length_comp(year, area = "goa", lenbins = "len_bin_labels.csv")
lls_length_comp(year, species = "REBS", region = "goa", lenbins = "len_bin_labels.csv")

# create .dat file - this will be placed in a folder that uses the model name

concat_dat(year = year, species = "REBS", region = "goa", 
           model = "db", dat_name = "goa_rebs_2019", 
           rec_age = 3, plus_age = 42, spawn_mo = 6,
           maturity = "maturity.csv")
