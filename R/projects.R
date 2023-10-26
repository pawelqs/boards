#' @export
show_local_projects <- function() {
  projects <- get_local_projects()
  cli::cat_bullet(projects, col = "steelblue3")
  invisible(projects)
}



#' @export
get_local_projects <- function() {
  dir <- get_local_boards_directory()
  list.dirs(dir, recursive = FALSE, full.names = FALSE)
}



#' @export
create_local_project <- function(name) {
  project_path <- get_project_path(name, stop_if_not_exist = FALSE)
  if (file.exists(project_path)) {
    stop(str_c("Project ", name, " exists"))
  }
  dir.create(project_path)
}



get_project_path <- function(project, stop_if_not_exist = TRUE) {
  dir <- get_local_boards_directory()
  if (project %not in% get_local_projects() && stop_if_not_exist) {
    stop("Project not found!")
  }
  file.path(dir, project) |>
    str_replace("//", "/")
}



get_project_board <- function(project) {
  path <- get_project_path(project)
  pins::board_folder(path)
}


