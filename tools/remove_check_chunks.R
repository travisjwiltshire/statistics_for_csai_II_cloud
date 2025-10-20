# Utility script to remove all exercise checker chunks (labels ending with "-check")
# across the ImprovedLectures folder. Run from the project root in R.

remove_check_chunks <- function(root = "ImprovedLectures") {
  # Find all Rmd files under root
  rmds <- list.files(root, pattern = "\\.Rmd$", recursive = TRUE, full.names = TRUE)
  message(sprintf("Found %d Rmd files", length(rmds)))

  # Regex to match an entire knitr chunk whose label ends with -check
  # Pattern explanation:
  #   ```{r <anything>-check[optional options]}
  #   ... any content ...
  #   ```
  # (?s) makes . match newlines
  chunk_re <- "```\\{r[^}]*?-check[^}]*?\\}.*?```"

  n_changed <- 0
  for (f in rmds) {
    txt <- readLines(f, warn = FALSE)
    before <- paste(txt, collapse = "\n")
    after <- gsub(chunk_re, "", before, perl = TRUE)
    if (!identical(before, after)) {
      writeLines(after, f)
      n_changed <- n_changed + 1
      message(sprintf("Removed -check chunks in: %s", f))
    }
  }
  message(sprintf("Done. Modified %d files.", n_changed))
}

# If executed directly, run the cleanup
if (sys.nframe() == 0) {
  remove_check_chunks()
}
