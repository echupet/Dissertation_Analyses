

setwd("~/Desktop/Task_Scripts/DATAOUT")

as = read.csv("Antisaccade_scored_2024-04-06.csv",stringsAsFactors = FALSE, header = TRUE)
cs = read.csv("Colorshape_scored_2024-04-06.csv",stringsAsFactors = FALSE, header = TRUE)
s2b = read.csv("Twoback_scored_2024-04-06.csv",stringsAsFactors = FALSE, header = TRUE)

all1 = merge(as, cs, by="participant", all=TRUE)
all2 = merge(all1, s2b, by="participant", all=TRUE)

all3 = subset(all2, select=c("participant", "ASAntiAllAccuracy", "CSswitchCostWK", "S2B_OverallAccuracy"))
names(all3) = c("subid", "AS_QA", "CSSC_QA", "S2B_QA")

d1 = read.csv("EF_Data_SEM_4Studies_2024-03-22.csv",stringsAsFactors = FALSE, header = TRUE)
#d2 = read.csv("../../Data/NPM_CPM_tasks_surveys_SEM2.csv",stringsAsFactors = FALSE, header = TRUE)

names(d1)

dx = merge(d1, all3, all=TRUE)

dx$CSswitch_scale = dx$CSSC_QA/-1000
dx$AS_QA[dx$AS_QA<.2] = NA
dx$S2B_QA[dx$S2B_QA<.6] = NA

rray_subs = grep("RRAY", dx$subid, value=TRUE)
s1_subs = grep("S1", rray_subs, value=TRUE)
s2_subs = grep("S2", rray_subs, value=TRUE)
length(s2_subs) # 134

# remove session 1 participants
dx_rray2 = dx[!dx$subid %in% s1_subs,]

# one with -999 for NAs
dx_rray2b = dx_rray2
dx_rray2b[is.na(dx_rray2b)] = -999

write.csv(dx_rray2, paste0("EF_Data_SEM_4Studies_", Sys.Date(), ".csv"), row.names = FALSE)


write.csv(dx_rray2b, paste0("EF_Data_SEM_4Studies_999_", Sys.Date(), ".csv"), row.names = FALSE)
