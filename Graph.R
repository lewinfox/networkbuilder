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
    },
    add_child = function(child_name) {
      if (!child_name %in% self$children) {
        self$children <- c(self$children, child_name)
      }
    },
    remove_child = function(child_name) {
      if (child_name %in% self$children) {
        self$children <- self$children[self$children != child_name]
      }
    },
    add_parent = function(parent_name) {
      if (!parent_name %in% self$parents) {
        self$parents <- c(self$parents, parent_name)
      }
    },
    remove_parent = function(parent_name) {
      if (parent_name %in% self$parents) {
        self$parents <- self$parents[self$parents != parent_name]
      }
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
      if (length(self$nodes) == 0) return(data.frame(name = character(), group = character(), stringsAsFactors = F))
      l <- lapply(self$nodes, function(n) data.frame(name = n$name, group = n$group, stringsAsFactors = F))
      do.call(rbind, l)
    },
    get_node_names = function() {
      if (length(self$nodes) == 0) return(NULL)
      lapply(self$nodes, function(n) n$name)
    },
    get_edges = function() {
      if (length(self$edges) == 0) return(data.frame(source = 0, target = 0, value = 0))
      e <- lapply(self$edges, function(e) data.frame(source = e$from_node_index, target = e$to_node_index, value = 1, stringsAsFactors = F))
      do.call(rbind, e)
    },
    add_node = function(name, group, parents = character(), children = character()) {
      n <- Node$new(name = name, group = group, parents = parents, children = children)
      self$nodes[[name]] <- n
      self$update_edges()
      invisible(self)
    },
    remove_node = function(name) {
      if (length(self$nodes) != 0) {
        self$nodes <- self$nodes[sapply(self$nodes, function(n) n$name != name)]
        self$update_edges()
      }
    },
    update_edges = function() {
      if (length(self$nodes) > 0) {
        edges <- list()
        node_names <- self$get_node_names()
        for (i in seq_along(self$nodes)) {

          node_idx <- i - 1  # Required for Javascript
          for (parent_name in self$nodes[[i]]$parents) {
            if (parent_name %in% node_names) {
              parent_idx <- which(node_names == parent_name) - 1
              e <- Edge$new(parent_idx, node_idx)
              edges <- c(edges, e)
            }
          }
          # Destroy parent and child lists in nodes - they will be rebuilt below
          self$nodes[[i]]$parents <- list()
          self$nodes[[i]]$children <- list()
        }
        self$edges <- edges
        if (length(self$nodes) > 0) {
          for (edge in self$edges) {
            parent_idx <- edge$from_node_index + 1
            child_idx <- edge$to_node_index + 1
            parent_name <- self$nodes[[parent_idx]]$name
            child_name <- self$nodes[[child_idx]]$name
            self$nodes[[parent_idx]]$add_child(child_name)
            self$nodes[[child_idx]]$add_parent(parent_name)
          }
        }
      }
      invisible(self)
    },
    render = function() {
      networkD3::forceNetwork(
        Links = self$get_edges(),
        Nodes = self$get_nodes(),
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
  )
)
