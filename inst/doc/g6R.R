## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)


## ----setup, message=FALSE-----------------------------------------------------
library(g6R)
library(shiny)


## -----------------------------------------------------------------------------
nodes <- data.frame(id = 1:10)


## -----------------------------------------------------------------------------
# Set a seed for reproducibility
set.seed(123)

# Define the number of edges to create (e.g., 200 random connections)
num_edges <- 5

# Generate random edges
edges <- data.frame(
  source = sample(nodes$id, num_edges, replace = TRUE),
  target = sample(nodes$id, num_edges, replace = TRUE)
)

edges$id <- paste0(edges$source, edges$target)
duplicated_id <- which(duplicated(edges$id) == TRUE)
if (length(duplicated_id)) {
  edges <- edges[-duplicated_id, ]
}


## -----------------------------------------------------------------------------
as.list(methods("as_g6_data"))


## -----------------------------------------------------------------------------
# Create nodes and edges
my_nodes <- data.frame(id = c("A", "B"))
my_edges <- data.frame(source = "A", target = "B")

# Assemble graph data using g6_data()
graph <- g6_data(
  nodes = my_nodes,
  edges = my_edges
)
graph

# Or use as_g6_data() directly with a list
lst <- list(
  nodes = list(
    list(id = "A"),
    list(id = "B")
  ),
  edges = list(
    list(source = "A", target = "B")
  )
)
graph2 <- as_g6_data(lst)

all.equal(graph, graph2)


## ----g6R-json, eval=FALSE, echo = TRUE----------------------------------------
# shinyAppDir(system.file("examples", "json", package = "g6R"))


## ----shinylive_url_2, echo = FALSE, results = 'asis'--------------------------
# extract the code from knitr code chunks by ID
code <- paste0(
  c(
    "webr::install(\"g6R\", repos = \"https://cynkra.github.io/blockr.webR/\")",
    knitr::knit_code$get("g6R-json")
  ),
  collapse = "\n"
)

url <- roxy.shinylive::create_shinylive_url(code, header = FALSE)


## ----shinylive_iframe_2, echo = FALSE, eval = TRUE----------------------------
tags$iframe(
  class = "border border-5 rounded shadow-lg",
  src = url,
  style = "zoom: 0.75;",
  width = "100%",
  height = "1100px"
)


## -----------------------------------------------------------------------------
g6(nodes, edges, width = 200, height = 200)


## -----------------------------------------------------------------------------
g <- g6(nodes, edges) |>
  g6_layout(d3_force_layout())
g


## -----------------------------------------------------------------------------
g <- g |>
  g6_options(
    node = list(
      style = list(
        labelBackground = TRUE,
        labelBackgroundFill = '#FFB6C1',
        labelBackgroundRadius = 4,
        labelFontFamily = 'Arial',
        labelPadding = c(0, 4),
        labelText = JS(
          "(d) => {
              return d.id
            }"
        )
      )
    )
  )
g


## -----------------------------------------------------------------------------
g <- g |>
  g6_plugins(
    minimap(size = c(100, 100))
  )
g


## -----------------------------------------------------------------------------
g <- g |>
  g6_behaviors(
    "zoom-canvas",
    drag_element_force(fixed = TRUE),
    click_select(
      multiple = TRUE,
      onClick = JS(
        "(e) => {
            console.log(e);
          }"
      )
    ),
    brush_select()
  )
g

