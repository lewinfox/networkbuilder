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
source("utils.R")  # Sets up a graph g

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # When the go button is clicked, capture the data and add to graph specification
    observeEvent(eventExpr = input$`go-button`, {
        title <- input$`node-name`
        type <- input$`node-type`
        parents <- input$parents
        children <- input$children
        if (title %in% g$get_node_names()) {
            warning("No duplicate names allowed")
        } else {
            g$add_node(title, type, parents, children)
            # Render graph
            output$graph <- networkD3::renderForceNetwork(render_graph(g))
            # Update input lists with new node
            node_list <- g$get_node_names()
            updateSelectInput(session, "parents", choices = node_list)
            updateSelectInput(session, "children", choices = node_list)
        }
        updateTextInput(session, "node-name", value = "")
        updateSelectInput(session, "parents", choices = g$get_node_names())
        updateSelectInput(session, "children", choices = g$get_node_names())
      }
    )
    
})
