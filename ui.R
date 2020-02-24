#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("utils.R")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Graph"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Add node"),
            textInput("node-name", "Node title"),
            radioButtons(
                "node-type", "Node type",
                choices = list("equation", "input")
                ),
            selectInput("parents", "Parents", choices = get_node_list(), multiple = TRUE),
            selectInput("children", "Children", choices = get_node_list(), multiple = TRUE),
            actionButton("go-button", "Go")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            networkD3::forceNetworkOutput("graph")
        )
    )
))
