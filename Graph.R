library(R6)

Node <- R6::R6Class(
  classname = "Node",
  public = list(
    name = NULL,
    group = NULL,
    parents = NULL,
    children = NULL,
    initialize = function(name, group, parents, children) {
      self$name <- name
      self$group <- group
      self$parents <- parents
      self$children <- children
    }
  )
)

Edge <- R6::R6Class(
  classname = "Edge",
  public = list(
    from_node_index = NULL,
    to_node_index = NULL,
    id = NULL,
    initialize = function(from_node_index, to_node_index) {
      self$from_node_index <- from_node_index
      self$to_node_index <- to_node_index
      self$id <- paste0(from_node_index, "->", to_node_index)
    }
  )
)

Graph <- R6::R6Class(
  classname = "Graph",
  public = list(
    nodes = list(),
    edges = list(),
    get_nodes = function() {
      l <- lapply(self$nodes, function(n) data.frame(name = n$name, group = n$group, stringsAsFactors = F))
      do.call(rbind, l)
    },
    get_node_names = function() {
      lapply(self$nodes, function(n) n$name)
    },
    get_edges = function() {
      self$update_edges()
      e <- lapply(self$edges, function(e) data.frame(source = e$from_node_index, target = e$to_node_index, value = 1, stringsAsFactors = F))
      df <- do.call(rbind, e)
      if (is.data.frame(df)) {
        return(df)
      } else {
        return(data.frame(source = 0, target = 0, value = 0))
      }
    },
    add_node = function(name, group, parents = character(), children = character()) {
      n <- Node$new(name = name, group = group, parents = parents, children = children)
      self$nodes <- c(self$nodes, n)
      invisible(self)
    },
    update_edges = function() {
      if (length(self$nodes) > 0) {
        edges <- list()
        node_names <- sapply(self$nodes, function(n) n$name)
        for (node in self$nodes) {
          node_idx <- which(node_names == node$name) - 1
          for (parent_name in node$parents) {
            parent_idx <- which(node_names == parent_name) - 1
            e <- Edge$new(parent_idx, node_idx)
            edges <- c(edges, e)
          }
        }
        self$edges <- edges
      }
      invisible(self)
    }
  )
)
