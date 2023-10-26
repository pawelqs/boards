
#' Manage pins
#' @param project Project name
#' @name manage-pins
NULL


#' @describeIn manage-pins Show all the pins or all pins in given project
#' @export
show_pins <- function(project = NULL) {
  pins <- get_pins(project)
  print(pins)
  return(NULL)
}



#' @describeIn manage-pins Get all the pins or all pins in given project
#' @export
get_pins <- function(project = NULL) {
  if (is.null(project)) {
    projects <- get_local_projects()
    names(projects) <- projects
    pins <- purrr::map(projects, get_pins) |>
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
      meta = purrr::map2(.data$name, .data$version, ~pins::pin_meta(board, .x, version = .y) |> unclass())
    ) |>
    tidyr::hoist("meta", "title", "description", "file_size") |>
    dplyr::select(-"meta")
}
