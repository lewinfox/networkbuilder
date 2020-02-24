nodes <- data.frame(
  name = character(),
  group = character(),
  stringsAsFactors = FALSE
)

edges <- data.frame(
  id = character(),
  source = numeric(),
  target = numeric(),
  value = numeric(),
  stringsAsFactors = FALSE
)

add_node <- function(name, type, parents = character(), children = character()) {
  if (name %in% nodes$names) stop("A node called ", name, " already exists")
  new_idx <- nrow(nodes)
  # Update node list
  new_node <- data.frame(name = name, group = type, stringsAsFactors = FALSE)
  nodes <<- rbind(nodes, new_node)
  # Update edges
  for (parent in parents) {
    stopifnot(parent %in% nodes$name)
    add_edge(parent, name)
  }
  for (child in children) {
    stopifnot(child %in% nodes$name)
    add_edge(name, child)
  }
}

add_edge <- function(from_name, to_name) {
  from_idx <- which(nodes$name == from_name) - 1
  to_idx <- which(nodes$name == to_name) - 1
  if (length(from_idx) > 1 | length(to_idx) > 1) stop("Duplicate keys found")
  new_edge_id <- paste0(from_idx, "->", to_idx)
  if (!new_edge_id %in% edges$id) {
    new_edge <- data.frame(id = new_edge_id, source = from_idx, target = to_idx, value = 1, stringsAsFactors = FALSE)
    edges <<- rbind(edges, new_edge)
  }
}

add_node("one", "input")
add_node("two", "input")
add_node("three", "equation", parents = c("one", "two"))

render_graph <- function() {
  forceNetwork(
    Links = edges,
    Nodes = nodes,
    Source = "source",
    Target = "target",
    Value = "value",
    NodeID = "name",
    Group = "group",
    fontSize = 10,
    opacity = 0.8
  )
}

get_node_list <- function() {
  split(unique(nodes$name), unique(nodes$name))
}
