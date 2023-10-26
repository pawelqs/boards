#' @export
read_pin <- function(project = NULL, pin = NULL) {
  if (is.null(project)) {
    msg("No project name provided. Found projects:")
    show_local_projects()
  } else if (is.null(pin)) {
    msg("No pin name provided. Found pins:")
    show_pins(project)
  } else {
    msg("Reading ", pin, " from ", project, " project" )
    board <- get_project_board(project)
    meta <- pins::pin_meta(board, pin)
    print_pin_meta(meta)
    pins::pin_read(board, pin)
  }
}



#' Completeme version of the function
# read_pin <- function(name, version = NULL, board = "main", ...) {
#   board_dir <- boards[[board]]
#   board <- board_folder(board_dir)
#   if (is.null(version)) {
#     msg("Reading the latest version of ", name)
#     meta <- pin_meta(board, name)
#     print_pin_meta(meta)
#     x <- pin_read(board, name)
#   } else {
#     msg("Reading version ", version, " of ", name)
#     meta <- pin_meta(board, name, version = version)
#     print_pin_meta(meta)
#     x <- pin_read(board, name, version = version)
#   }
#   x
# }



print_pin_meta <- function(meta) {
  msg("Title:       ", meta$title)
  msg("Description: ", as.character(meta$description))
  msg("Created:     ", as.character(meta$created))
}

