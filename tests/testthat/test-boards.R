test_that("use_local_boards_directory() works", {
  new_dir <- tempdir()
  recover_dir <- FALSE
  if (file.exists(boards:::settings_file)) {
    old <- get_local_boards_directory()
    recover_dir <- TRUE
  }
  use_local_boards_directory(new_dir)
  expect_equal(get_local_boards_directory(), new_dir)
  if (recover_dir) {
    use_local_boards_directory(old)
  }
})
