library(tidyverse)

carer_aducust <- haven::read_sas(data_file = "T:/03_Analysts/Data/Administrative/Cohort 2/SAS/cohort2_doj_aducust_final_02.sas7bdat")
linkage <- haven::read_sas(data_file = "T:/03_Analysts/Data/Core/Linkage master/linkage_6.sas7bdat")
dobs <- haven::read_sas(data_file = "T:/03_Analysts/Data/Core/DOBmap files/cohort_1_dobmap.sas7bdat")

# First we must map carer 1, carer 2, BM to each child
dob_data <- dobs %>%
  select(NEWUID, dob)

mini_link <- linkage %>%
  filter(NEWUID %in% dob_data$NEWUID) %>%
  select(NEWUID, carer1id, carer2id, NEWBMID) %>%
  mutate(across(c(carer1id, carer2id, NEWBMID), ~case_when(. == "" ~ NA,
                                                           TRUE ~ .))) #%>%
  pivot_longer(cols = c(carer1id, carer2id, NEWBMID),
               names_to = "type",
               values_to = "carer_newuid") %>%
  left_join(dob_data, by = "NEWUID") %>%
  relocate(dob, .after = NEWUID) %>%
  left_join(linkage %>% select(rootnum, NEWUID), by = c("carer_newuid" = "NEWUID")) %>%
  rename(carer_rootnum = rootnum)


# Now rip out aducust data
carer_auducst_clean <- carer_aducust %>%
  select(root, ReceptionDate, DischargeDate) %>%
  rename(rootnum = root) %>%
  group_by(rootnum) %>%
  arrange(rootnum, ReceptionDate) %>%
  mutate(aducust_num = row_number()) %>%
  ungroup

overall <- mini_link %>%
  left_join(carer_auducst_clean, by = c("carer_rootnum" = "rootnum"))

overall_temp1 <- overall %>%
  mutate(end_date = dob + years(11),
         .after = dob) %>%
  mutate(carer_aducust = case_when(if_any(.cols = c(ReceptionDate, DischargeDate),
                                              .fns = ~ . >= dob & . < end_date) ~ "Yes",
                                       if_any(.cols = c(ReceptionDate, DischargeDate),
                                              .fns = ~ . < dob | . >= end_date) ~ "No"))

overall_temp2 <- overall_temp1 %>%
  group_by(NEWUID, dob, end_date, type, carer_newuid, carer_rootnum) %>%
  summarise(any_carer_aducust = case_when(any(carer_aducust == "Yes") ~ "Yes",
                                          all(carer_aducust != "No")  ~ "No",
                                          all(is.na(carer_aducust)) ~ "No custodial records"))


overall_temp2
