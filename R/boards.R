settings_dir <- tools::R_user_dir("boards", which = "config")
settings_file <- file.path(settings_dir, "settings.yml")


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
    cli::cat_bullet(list_projects(), col = "steelblue3")
  } else if (is.null(pin)) {
    msg("No pin name provided. Found pins:")
    cli::cat_bullet(list_pins(project), col = "steelblue3")
  } else {
    board_dir <- get_project_board(project)
    board <- pins::board_folder(board_dir)
    pins::pin_read(board, pin)
  }
}


#' @export
list_projects <- function() {
  dir <- get_boards_directory()
  list.dirs(dir, recursive = FALSE, full.names = FALSE)
}



#' @export
list_pins <- function(project) {
  project_board <- get_project_board(project)
  list.dirs(project_board, recursive = FALSE, full.names = FALSE)
}



get_project_board <- function(project) {
  dir <- get_boards_directory()
  if (project %not in% list_projects()) {
    stop("Project not found!")
  }
  file.path(dir, project)
}


list_pins2 <- function(project) {
  project_board <- get_project_board(project)
  board <- pins::board_folder(project_board)
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
