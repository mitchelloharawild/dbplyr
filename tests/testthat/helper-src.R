if (test_srcs$length() == 0) {

  test_register_src("df", dplyr::src_df(env = new.env(parent = emptyenv())))
  test_register_con("sqlite", RSQLite::SQLite(), ":memory:")

  if (identical(Sys.getenv("GITHUB_ACTIONS"), "true")) {
    test_register_con("postgres", RPostgreSQL::PostgreSQL(),
      dbname = "test",
      user = "postgres",
      password = ""
    )
  } else {
    test_register_con("mysql", RMySQL::MySQL(),
      dbname = "test",
      host = "localhost",
      user = Sys.getenv("USER")
    )
    test_register_con("MariaDB", RMariaDB::MariaDB(),
      dbname = "test",
      host = "localhost",
      user = Sys.getenv("USER")
    )
    test_register_con("postgres", RPostgreSQL::PostgreSQL(),
      dbname = "test",
      host = "localhost",
      user = ""
    )
  }
}

skip_if_no_db <- function(db) {
  if (!test_srcs$has(db))
    skip(paste0("No ", db))
}

sqlite_con_with_aux <- function() {
  tmp <- tempfile()

  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  DBI::dbExecute(con, paste0("ATTACH '", tmp, "' AS aux"))

  con
}
