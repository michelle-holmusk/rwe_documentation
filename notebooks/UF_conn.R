#' Wrapper for getting result of a query run on DSense.
#'
#' This function lets you establish connection to the database via
#' path directory, runs your query, and then returns the result
#' as a data frame.
#' To use this function with another database, you would have to provide the
#' path to the database.
#' Assumptions: The specified database directory has to be on DSense, DBI and
#' RSQLite are loaded libraries.
#' @param query A character string containing SQL statement.
#' @param dir Directory path to the database.
#' @keywords SQL; connection
#' @returns The result of a query as a data frame.
#' @export
#' @examples
#' query <- "SELECT COUNT(*) FROM person;"
#' get_query(query)
#' #   COUNT(*)
#' #1   554003

# Initiate the connection to the SQlite database
get_query <- function(query, dir="/root/data/cdm.sqlite3") {
  output <- tryCatch(
    {
      con = DBI::dbConnect(RSQLite::SQLite(), dir)
      DBI::dbGetQuery(con, query)
    },
    warning=function(cond) {
      message("Warning:")
      message(cond)
    },
    error=function(cond) {
      message("Error:")
      message(cond)
    },
    finally={
      DBI::dbDisconnect(con)
    }
  )
  return(output)
}
