#' Get concept ID codes using ICD codes
#'
#' This function queries the CDM database using ICD codes as input and outputs
#' the queried ICD codes, their associated concept code IDs, and ICD code
#' descriptions within the CDM.
#' Assumptions: All letters in the ICD codes must be capitalized and the database
#' is on the DSense platform.
#' @param a A string or vector of strings of ICD codes
#' @param con Connection to the database, default = conn() that has to be run before running this function.
#' @details  All letters in the ICD codes must be capitalized and the database is on the DSense platform.
#' @keywords ICD; concept ID; ICD descriptions
#' @returns A dataframe containing the concept ID, concept name and ICD codes queried.
#' @export
#' @examples
#' ICD_concept('F33.3')
#' ICD_concept('F33.3', conn('a/folder/database.db'))

ICD_concept <- function(a, con = conn()) {
  # input should be in form of a vector of strings
  # returns icd code concept ID, concept name, ICD code
  icdquery <- paste0("select v.concept_id, v.concept_name, v.concept_code
  from concept v
  where
  ((v.vocabulary_id like 'ICD%CM')
    and (v.concept_code in ('", paste(a, collapse="', '"),"')));")

  out <- tryCatch({
    icd <- dbGetQuery(con, icdquery)
  },
  error = function(cond) {
    message("query did not work")
    message("error:")
    message(cond)
  },
  warning = function(cond) {
    message("query showed a warning")
    message("warning:")
    message(cond)
  }
  )
  return(out)
}

