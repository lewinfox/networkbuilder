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
source("utils.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # When the go button is clicked, capture the data and add to graph specification
    observeEvent(eventExpr = input$`go-button`, {
        title <- input$`node-name`
        type <- input$`node-type`
        parents <- input$parents
        children <- input$children
        add_node(title, type, parents, children)
        # Render graph
        output$graph <- networkD3::renderForceNetwork({
            render_graph()
        })
        # Update input lists with new node
        updateSelectInput(session, "parents", choices = get_node_list())
        updateSelectInput(session, "children", choices = get_node_list())
      }
    )

    # Render graph
    output$graph <- networkD3::renderForceNetwork({
        render_graph()
    })

})
