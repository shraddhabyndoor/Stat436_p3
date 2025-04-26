library(shiny)
library(ggplot2)
library(DT)
library(dplyr)
library(tidyr) # for pivot_longer if needed
library(rsconnect)

# Load datasets
high_popularity_data <- read.csv("https://raw.githubusercontent.com/shraddhabyndoor/project2_stat436/refs/heads/main/high_popularity_spotify_data.csv")
low_popularity_data <- read.csv("https://raw.githubusercontent.com/shraddhabyndoor/project2_stat436/refs/heads/main/low_popularity_spotify_data.csv")

# Add Popularity Level column
high_popularity_data$Popularity_Level <- "High"
low_popularity_data$Popularity_Level <- "Low"

# Combine both datasets
data <- bind_rows(high_popularity_data, low_popularity_data)

# UI
ui <- fluidPage(
  titlePanel("Spotify Audio Feature vs Popularity"),
  sidebarLayout(
    sidebarPanel(
      selectInput("feature", "Select Audio Feature:",
                  choices = c("energy", "tempo", "danceability", "loudness", "liveness", 
                              "valence", "speechiness", "acousticness", "instrumentalness"),
                  selected = "danceability")
    ),
    mainPanel(
      plotOutput("scatterPlot", brush = brushOpts(id = "plot_brush")),
      DTOutput("brushedData")
    )
  )
)

# Server
server <- function(input, output) {
  
  output$scatterPlot <- renderPlot({
    ggplot(data, aes_string(x = input$feature, y = "track_popularity", color = "Popularity_Level")) +
      geom_point(alpha = 0.5, position = position_jitter(width = 0.2)) +
      geom_smooth(method = "lm", se = FALSE, color = "black") +
      labs(x = input$feature, y = "Track Popularity", 
           title = paste("Audio Feature vs Popularity:", input$feature),
           color = "Popularity Level") +
      theme_minimal()
  })
  
  output$brushedData <- renderDT({
    brushed_points <- brushedPoints(data, input$plot_brush)
    datatable(brushed_points)
  })
  
}

# Run the app
shinyApp(ui = ui, server = server)

