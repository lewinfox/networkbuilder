source("Graph.R")

g <- Graph$new()

render_graph <- function(graph) {
  forceNetwork(
    Links = graph$get_edges(),
    Nodes = graph$get_nodes(),
    Source = "source",
    Target = "target",
    Value = "value",
    NodeID = "name",
    Group = "group",
    fontSize = 12,
    opacity = 0.8,
    zoom = TRUE
  )
}
