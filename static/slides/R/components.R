`%||%` <- purrr::`%||%`
`%>%` <- purrr::`%>%`

title_slide <- function(
  title = rmarkdown::metadata$title,
  subtitle = rmarkdown::metadata$subtitle,
  author = "Fabio Cruz & Mauricio Camargo",
  scene = rmarkdown::metadata$scene
) {
  htmltools::tagList(
    if (!is.null(scene)) {
      htmltools::div(class = "scene f2 absolute top-0 left-0 w-10 bg-red bg-blue", scene)
    },
    htmltools::h1(title),
    if (!is.null(subtitle)) htmltools::h2(subtitle),
    htmltools::div(class = "conf-logo"),
    htmltools::div(
      class = "talk-meta",
      htmltools::p(class = "talk-author", author),
      htmltools::p(
        class = "talk-date",
        htmltools::tags$a(
          "Professional, Polished, Presentable",
          href = "https://presentable-user2021.netlify.app",
          class = "underline f-lato",
          style = "color: var(--text-light); text-underline-offset: 7px;"
        )
      ),
      metathis::meta() %>%
        metathis::meta_description(glue::glue(
          'Slides for "{title}" from the "Professional, Polished, Presentable" ',
          "tutorial at useR!2021"
        )) %>%
        metathis::meta_social(
          title = glue::glue("{title} | Professional, Polished, Presentable"),
          url = "https://presentable-user2021.netlify.app",
          image = "https://presentable-user2021.netlify.app/img/presentable-social.png",
          image_alt = paste(
            "The eye of xaringan with the title of the tutorial: Professional,",
            "Polished, Presentable, Presentable: Making great xaringan slides.",
            "A tutorial at useR!2021 by Garrick Aden-Buie and Silvia Canelón."
          ),
          og_type = "website",
          og_author = c("Garrick Aden-Buie", "Silvia Canelón"),
          twitter_card_type = "summary_large_image",
          twitter_creator = "@grrrck"
        ) %>%
        metathis::include_meta()
    )
  )
}

use_placeholders <- function(images = TRUE, iframes = TRUE) {
  images <- getOption("placeholder_enable", NULL) %||% images
  iframes <- getOption("placeholder_enable", NULL) %||% iframes
  options(
    slide_image_placeholder = images,
    iframe_placeholder = iframes
  )
}

CLASS <- list(
  breaks = list(
    default = "break",
    purple = "break bg-purple white center middle",
    shiny = "break break-shiny",
    js = "break break-javascript",
    bupi = "break break-blue-pink",
    bupiye = "break break-blue-pink-yellow"
  )
)

htmlent <- list(
  "right_arrow_heavy" = "&#10142;",
  "right_arrow_big" = "&#10145;",
  "right_Arrow" = "&rArr;",
  "right_arrow" = "&rarr;",
  "done" = "&#10004;",
  "x" = "&#10006;",
  triangle_up = "&#9650;",
  triangle_up_small = "&#9652;",
  triangle_right = "&#9654;",
  triangle_right_small = "&#9656;",
  triangle_down = "&#9660;",
  triangle_down_small = "&#9662;",
  triangle_left = "&#9664;",
  triangle_left_small = "&#9666;"
)

placeholder <- function(
  ...,
  w = 4,
  h = 4,
  classes = "pa3 ma2"
) {
  htmltools::div(
    class = glue::glue("bg-black-05 black-70 ba bw1 b--black-30 w{w} h{h} {classes}"),
    ...
  )
}

fullscreen_bg_image <- function(
  path,
  size = "cover",
  class = NULL,
  position = "top left"
) {
  class <- paste(class, collapse = " ")
  glue::glue(
    "class: fullscreen {class}
    background-image: url('{path}')
    background-size: {size}
    background-position: {position}
    "
  )
}

iframe_slide_fullscreen <- function(path, scale = 1) {
  glue::glue(
    "
    class: fullscreen

    {iframe_fullscreen(path, scale)}
    "
  )
}

iframe_fullscreen <- function(path, scale = 1) {
  scale <- as.numeric(scale)
  scale <- switch(
    sprintf("%1.2f", scale),
    "1.25" = "-scale-125",
    "1.50" = "-scale-150",
    "2.00" = "-scale-200",
    ""
  )
  iframe <- if (isTRUE(getOption("iframe_placeholder", FALSE))) {
    glue::glue('content from <a href="{path}">{path}</a> here')
  } else {
    glue::glue(
      '<div data-iframe data-src="{path}" class="fullscreen-iframe{scale}">
       <a href="{path}">iframe content</a>
    </div>'
    )
  }
  glue::glue(
    '<div class="fullscreen-iframe-container">{iframe}</div>'
  )
}

repl_iframe_url <- function(code, local = getOption("js4shiny_repl_local", TRUE)) {
  code <- httpuv::encodeURIComponent(jsonlite::toJSON(code))
  base_url <- if (local) "http://127.0.0.1:9876" else "https://apps.garrickadenbuie.com/u/garrick/repljs"
  glue::glue("{base_url}/?_inputs_&code_js={code}")
}

# repl_iframe <- function(code, scale = 1.5, class = NULL) {
#   scale <- scale %||% 1.5
#   class <- if (!is.null(class)) paste0(" ", paste(class, collapse = "\n")) else ""
#   path <- repl_iframe_url(code)
#   preview <- if (isTRUE(getOption("iframe_placeholder", FALSE))) {
#     paste(".mt5[", "```js", "{code}", "```", "]", sep = "\n")
#   } else {
#     ""
#   }
#   glue::glue(
#     "class: fullscreen{class}",
#     "",
#     "{iframe_fullscreen(path, scale)}",
#     preview,
#     .sep = "\n"
#   )
# }

repl_iframe <- function(code, class = NULL, ...) {
  class <- if (!is.null(class)) paste0(" ", paste(class, collapse = "\n")) else ""
  glue::glue(
    "class: class",
    "",
    "```js",
    "{code}",
    "```",
    .sep = "\n"
  )
}

slides_unzip <- function(
  zip,
  out_path = NULL,
  stash_path = "assets/img/original-slides"
) {
  if (!fs::file_exists(zip)) {
    stop("No zip file found at ", zip)
  }
  zip_name <- fs::path_ext_remove(fs::path_file(zip))
  if (!fs::is_absolute_path(out_path)) {
    out_path <- fs::path(fs::path_dir(zip), out_path, zip_name)
  }
  zip::unzip(zip, exdir = out_path, overwrite = TRUE)
  files <- fs::path_rel(fs::dir_ls(out_path))
  if (any(grepl("-\\d{2}", files))) {
    for (file in grep("-\\d[.]", files, value = TRUE)) {
      file_new <- sub("-(\\d)[.]", "-0\\1.", file)
      message(glue::glue("{file} -> {file_new}"))
      fs::file_move(file, file_new)
    }
  }
  fs::file_move(zip, stash_path)
  out_path
}

slides_from_images <- function(
  path,
  regexp = NULL,
  class = "hide-count",
  background_size = "contain",
  background_position = "top left"
) {
  if (isTRUE(getOption("slide_image_placeholder", FALSE))) {
    return(glue::glue("Slides to be generated from [{path}]({path})"))
  }
  if (fs::is_dir(path)) {
    imgs <- fs::dir_ls(path, regexp = regexp, type = "file", recurse = FALSE)
  } else if (all(fs::is_file(path) && fs::file_exists(path))) {
    imgs <- path
  } else {
    stop("path must be a directory or a vector of images")
  }
  imgs <- fs::path_rel(imgs, ".")
  breaks <- rep("\n---\n", length(imgs))
  breaks[length(breaks)] <- ""

  txt <- glue::glue("

  class: {class}
  background-image: url('{imgs}')
  background-size: {background_size}
  background-position: {background_position}

  {breaks}

  ")

  paste(txt, sep = "", collapse = "")
}

unsplash <- function(id, size = "1920x1080") {
  size <- if (!is.null(size)) glue::glue("/{size}") else ""
  glue::glue("https://source.unsplash.com/{id}{size}")
}

unsplash_bg <- function(id, size = "1920x1080") {
  glue::glue(
    "background-image: url('{unsplash(id, size)}')
    background-size: cover"
  )
}

unsplash_get <- function(id, size = "1920x1080", path = here::here("static/slides/assets/img/bg")) {
  url <- unsplash(id, size)
  file <- glue::glue("unsplash_{id}.jpg")
  download.file(url, fs::path(path, file))
  code_img <- glue::glue("background-image: url('assets/img/bg/{file}')")
  code <- paste(code_img, "background-size: cover", sep = "\n")
  if (clipr::clipr_available()) clipr::write_clip(code)
  message(code)
  invisible(code_img)
}

chunk_file_name <- function(...) {
  name <- paste0(..., collapse = "")
  glue::glue('<div class="pre-name">{name}</div>')
}


list_all_assets <- function(only_files = FALSE, ext = "jpg|png|gif|mov|mp4|svg") {
  rmds <- fs::dir_ls(here::here(), regexp = "Rmd$", recurse = TRUE)
  pattern <- glue::glue(
    "assets/{file}[.]({ext})",
    file = if (only_files) "[^ ]+" else ".+"
  )
  rmds %>%
    purrr::set_names() %>%
    purrr::map(js4shiny:::read_lines) %>%
    purrr::map(stringr::str_extract, pattern = pattern) %>%
    purrr::map(~ .[!is.na(.)])
}

jump_to <- function(anchor = NULL) {
  if (is.null(anchor)) {
    return(invisible())
  }
  htmltools::tags$div(
    class = "f4 ma0 pa0 hover-show o-40 pointer absolute right-1 bottom-1",
    htmltools::tags$a(href = paste0("#", anchor), "&#x23ED;")
  )
}

live_coding <- function(
  emoji = "&#x1F468;&#x1F3FC;&#x200D;&#x1F4BB;",
  class = "break center middle",
  message = "[live coding]"
) {
  x <- glue::glue(
    " class: {class}

  .f1[{emoji}]<br>
  .code.f6[{message}]
  "
  )
  knitr::asis_output(x)
}
