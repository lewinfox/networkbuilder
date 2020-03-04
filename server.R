#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(networkD3)
source("Graph.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  g <- Graph$new()

  # Set initial values for select inputs
  available_nodes <- g$get_node_names()
  updateTextInput(session, "node-name", value = "")
  updateSelectInput(session, "parents", choices = available_nodes)
  updateSelectInput(session, "children", choices = available_nodes)
  updateSelectInput(session, "nodes-to-remove", choices = available_nodes)

  # When the go button is clicked, capture the data and add to graph specification
  observeEvent(input$`go-button`, {
    title <- input$`node-name`
    type <- input$`node-type`
    parents <- input$parents
    children <- input$children
    if (title %in% g$get_node_names()) {
      warning("No duplicate names allowed")
    } else {
      g$add_node(title, type, parents, children)
      # Render graph
      output$graph <- networkD3::renderForceNetwork(g$render())
      # Update input lists with new node
      node_list <- g$get_node_names()
      updateSelectInput(session, "parents", choices = node_list)
      updateSelectInput(session, "children", choices = node_list)
    }
    available_nodes <- g$get_node_names()
    updateTextInput(session, "node-name", value = "")
    updateSelectInput(session, "parents", choices = available_nodes)
    updateSelectInput(session, "children", choices = available_nodes)
    updateSelectInput(session, "nodes-to-remove", choices = available_nodes)
  })

  # Node removed
  observeEvent(input$`remove-button`, {
    remove <- input$`nodes-to-remove`
    message("Removing ", remove)
    for (node_name in remove) {
      g$remove_node(node_name)
    }
    output$graph <- networkD3::renderForceNetwork(g$render())
    available_nodes <- g$get_node_names()
    message("Remaining nodes ", available_nodes)
    updateTextInput(session, "node-name", value = "")
    updateTextInput(session, "nodes-to-remove", value = "")
    updateSelectInput(session, "parents", choices = available_nodes)
    updateSelectInput(session, "children", choices = available_nodes)
    updateSelectInput(session, "nodes-to-remove", choices = available_nodes)
  })

  #Graph reset
  observeEvent(input$`clear-button`, {
    available_nodes <- g$get_node_names()
    message("removing ", available_nodes)
    for (node_name in available_nodes) {
      g$remove_node(node_name)
    }
    output$graph <- networkD3::renderForceNetwork(g$render())
    available_nodes <- g$get_node_names()
    updateTextInput(session, "node-name", value = "")
    updateTextInput(session, "nodes-to-remove", value = "")
    updateSelectInput(session, "parents", choices = available_nodes)
    updateSelectInput(session, "children", choices = available_nodes)
    updateSelectInput(session, "nodes-to-remove", choices = available_nodes)
  })

})
