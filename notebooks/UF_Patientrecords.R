patient_records <- function(id, con) {
  # input should be a vector of one or more patient IDs, integer form
  # returns patient records in the form of a list of 
  patientoccurence <- paste0("select o.condition_start_datetime, o.person_id, o.condition_concept_id, o.condition_occurrence_id
  from rwe_schema_cdm.condition_occurrence o 
  where 
  (o.person_id in (", paste(id, collapse=", "),"));")
  
  patientmeasurement <- paste0("select m.measurement_datetime, m.person_id, m.measurement_concept_id
  from rwe_schema_cdm.measurement m 
  where 
  (m.person_id in (", paste(id, collapse=", "),"));")
  
  patientdrug <- paste0("select d.drug_exposure_start_date, d.person_id, d.drug_concept_id, d.quantity, d.days_supply
  from rwe_schema_cdm.drug_exposure d
  where 
  (d.person_id in (", paste(id, collapse=", "),"));")
  
  out_occurence <- tryCatch({
    occurence <- dbGetQuery(con, patientoccurence)
  },
  error = function(cond) {
    message("occurence query did not work")
    message("error:")
    message(cond)
  },
  warning = function(cond) {
    message("occurence query showed a warning")
    message("warning:")
    message(cond)
  }
  )
  
  out_measurement <- tryCatch({
    measurement <- dbGetQuery(con, patientmeasurement)
  },
  error = function(cond) {
    message("measurement query did not work")
    message("error:")
    message(cond)
  },
  warning = function(cond) {
    message("measurement query showed a warning")
    message("warning:")
    message(cond)
  }
  )
  
  out_drug <- tryCatch({
    drug <- dbGetQuery(con, patientdrug)
  },
  error = function(cond) {
    message("drug query did not work")
    message("drug error:")
    message(cond)
  },
  warning = function(cond) {
    message("query showed a warning")
    message("warning:")
    message(cond)
  }
  )
  return(list(out_occurence, out_measurement, out_drug))
}