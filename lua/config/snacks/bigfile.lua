return {
  bigfile = {
    enable = true,
    notify = true,          -- show notification when big file detected
    size = 5 * 1024 * 1024, -- 1.5MB
    line_length = 1000,     -- average line length (useful for minified files)
  }
}
