#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Build a network"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h3("Add node"),
      textInput("node-name", "Node title"),
      radioButtons(
        "node-type", "Node type",
        choices = list("variable", "constant", "equation")
      ),
      selectInput("parents", "Parents", choices = list(), multiple = TRUE),
      selectInput("children", "Children", choices = list(), multiple = TRUE),
      actionButton("go-button", "Go"),
      hr(),
      h3("Remove nodes"),
      selectInput("nodes-to-remove", "Remove nodes", choices = list(), multiple = TRUE),
      actionButton("remove-button", "Remove"),
      hr(),
      h3("Clear graph"),
      actionButton("clear-button", "Start again")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      networkD3::forceNetworkOutput("graph")
    )
  )
))
