#' Use local boards directory
#'
#' @examples
#' \dontrun{
#'   use_local_boards_directory(tempdir())
#'   get_local_boards_directory()
#' }
#' @name local_directory
NULL



#' @rdname local_directory
#' @param dir Path to the selected location
#' @export
use_local_boards_directory <- function(dir) {
  settings <- list(
    boards_location = dir
  )
  if(!dir.exists(settings_dir)) {
    dir.create(settings_dir)
  }
  yaml::write_yaml(settings, settings_file)
}



#' @rdname local_directory
#' @export
get_local_boards_directory <- function() {
  if (!file.exists(settings_file)) {
    message("Local boards directory is not set")
  } else {
    settings <- yaml::read_yaml(settings_file)
    settings[["boards_location"]]
  }
}

