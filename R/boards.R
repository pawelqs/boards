settings_dir <- tools::R_user_dir("boards", which = "config")
settings_file <- file.path(settings_dir, "settings.yml")


## ---------------------------- Init boards ------------------------------------

#' @export
init_boards <- function(dir) {
  settings <- list(
    boards_location = dir
  )
  if(!dir.exists(settings_dir)) {
    dir.create(settings_dir)
  }
  yaml::write_yaml(settings, settings_file)
}


get_boards_directory <- function() {
  settings <- yaml::read_yaml(settings_file)
  settings[["boards_location"]]
}


#' @export
read_pin <- function(project = NULL, pin = NULL) {
  if (is.null(project)) {
    msg("No project name provided. Found projects:")
    print_projects()
  } else if (is.null(pin)) {
    msg("No pin name provided. Found pins:")
    print_pins(project)
  } else {
    msg("Reading ", pin, " from ", project, " project" )
    board <- get_project_board(project)
    meta <- pins::pin_meta(board, pin)
    print_pin_meta(meta)
    pins::pin_read(board, pin)
  }
}

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



## ----------------------------- Projects --------------------------------------

#' @export
list_projects <- function() {
  dir <- get_boards_directory()
  list.dirs(dir, recursive = FALSE, full.names = FALSE)
}


#' @export
print_projects <- function() {
  cli::cat_bullet(list_projects(), col = "steelblue3")
}



get_project_path <- function(project) {
  dir <- get_boards_directory()
  if (project %not in% list_projects()) {
    stop("Project not found!")
  }
  file.path(dir, project)
}


get_project_board <- function(project) {
  path <- get_project_path(project)
  pins::board_folder(path)
}



## ----------------------------- Pins --------------------------------------


#' @export
list_pins <- function(project = NULL) {
  if (is.null(project)) {
    projects <- list_projects()
    names(projects) <- projects
    pins <- purrr::map(projects, list_pins) |>
      dplyr::bind_rows(.id = "project")
    return(pins)
  }

  board <- get_project_board(project)
  pins <- pins::pin_list(board)

  versions <- pins |>
    rlang::set_names(pins) |>
    purrr::map(~pins::pin_versions(board, name = .x)) |>
    dplyr::bind_rows(.id = "name")

  versions |>
    dplyr::mutate(
      meta = purrr::map2(name, version, ~pins::pin_meta(board, .x, version = .y) |> unclass())
    ) |>
    tidyr::hoist(meta, "title", "description", "file_size") |>
    dplyr::select(-"meta")
}


print_pins <- list_pins


print_pin_meta <- function(meta) {
  msg("Title:       ", meta$title)
  msg("Description: ", as.character(meta$description))
  msg("Created:     ", as.character(meta$created))
}
