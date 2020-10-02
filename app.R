library(shiny)
library(ggplot2)

# read full ISO dataset
isofull <- read.csv("ISO2017full.csv", header=TRUE)

ui <- fluidPage(
  
  fluidRow(
    style = "font-size: 1.2em; padding: 1em 1em; margin:0em", 
    tags$b(p("Instructions")),
    p("Fill in the client's measured thresholds by typing a number in each box, or by clicking the up/down buttons in each box. Each box will accept values between -10 and 100 (inclusive). Leave the box blank if there is no measurement for that frequency."),    
    p("If you wish to compare the client's thresholds with percentile values from a normative sample, check the box for \"Plot ISO percentiles\" and select the appropriate sex and age. These percentile values are from Table D1 in ISO 7029:2017. Note that percentile values for 80-year-olds from 3000 Hz to 8000 Hz (inclusive) are for \"information only\", according to a footnote in Table D1."),
    ), 
  
  sidebarLayout(
  
    sidebarPanel(style = "background-color: white", 
                 
      fluidRow(column(width = 4, align = "center", style = "font-size: 1.25em; color: blue", "Left ear"), 
               column(width = 4, align = "center", style = "font-size: 1.25em; color: black", "Frequency"), 
               column(width = 4, align = "center", style = "font-size: 1.25em; color: red", "Right ear")
               ),  
      
      br(),
      
      fluidRow(column(width = 4, numericInput(inputId = "L250", label = NULL, value = NULL, step = 5, min = -10, max = 100)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "250"), 
               column(width = 4, numericInput(inputId = "R250", label = NULL, value = NULL, step = 5, min = -10, max = 100)) 
               ), 
  
      fluidRow(column(width = 4, numericInput(inputId = "L500", label = NULL, value = NULL, step = 5, min = -10, max = 100)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "500"),
               column(width = 4, numericInput(inputId = "R500", label = NULL, value = NULL, step = 5, min = -10, max = 100))
               ), 
      
      fluidRow(column(width = 4, numericInput(inputId = "L1000", label = NULL, value = NULL, step = 5, min = -10, max = 100)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "1000"),
               column(width = 4, numericInput(inputId = "R1000", label = NULL, value = NULL, step = 5, min = -10, max = 100))
               ), 
  
      fluidRow(column(width = 4, numericInput(inputId = "L2000", label = NULL, value = NULL, step = 5, min = -10, max = 100)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "2000"),
               column(width = 4, numericInput(inputId = "R2000", label = NULL, value = NULL, step = 5, min = -10, max = 100))
               ), 
  
      fluidRow(column(width = 4, numericInput(inputId = "L3000", label = NULL, value = NULL, step = 5, min = -10, max = 100)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "3000"),
               column(width = 4, numericInput(inputId = "R3000", label = NULL, value = NULL, step = 5, min = -10, max = 100))
               ), 
  
      fluidRow(column(width = 4, numericInput(inputId = "L4000", label = NULL, value = NULL, step = 5, min = -10, max = 100)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "4000"),
               column(width = 4, numericInput(inputId = "R4000", label = NULL, value = NULL, step = 5, min = -10, max = 100))
               ), 
      
      fluidRow(column(width = 4, numericInput(inputId = "L6000", label = NULL, value = NULL, step = 5, min = -10, max = 100)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "6000"),
               column(width = 4, numericInput(inputId = "R6000", label = NULL, value = NULL, step = 5, min = -10, max = 100))
               ), 
  
      fluidRow(column(width = 4, numericInput(inputId = "L8000", label = NULL, value = NULL, step = 5, min = -10, max = 100)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "8000"),
               column(width = 4, numericInput(inputId = "R8000", label = NULL, value = NULL, step = 5, min = -10, max = 100))
               ), 
      
      hr(), 
      
      fluidRow(column(width = 8, style = "font-size: 1.25em", checkboxInput(inputId = "iso", label = tags$b("Plot ISO percentiles"), value = FALSE))
               ),
  
      fluidRow(column(width = 1, align = "center", style = "padding-top: 6px", tags$b("Sex")), 
               column(width = 4, selectInput(inputId = "sex", label = NULL, choices = c("Female", "Male"))),
               column(width = 1, ""), 
               column(width = 1, align = "center", style = "padding-top: 6px", tags$b("Age")), 
               column(width = 4, selectInput(inputId = "age", label = NULL, choices = c("20", "30", "40", "50", "60", "70", "80")))
               )
      
      ),

  mainPanel(
    plotOutput("audiogram", width = 800, height = 600)
      )
  
  ), 

    
  fluidRow(style = "padding: 1em 2em 2em", 
           column(width = 2, downloadButton(outputId = "downloadPDF", label = "Download PDF")),
           column(width = 2, downloadButton(outputId = "downloadPNG", label = "Download PNG")),
           column(width = 8, "")
           ),    
  
)

server <- function(input, output){
  
  # Collect threshold inputs into a dataframe
  thresholds.L.initial <- reactive({data.frame(freq = c(250, 500, 1000, 2000, 3000, 4000, 6000, 8000),
                                          threshold = c(input$L250, input$L500, input$L1000, input$L2000, input$L3000, input$L4000, input$L6000, input$L8000))
                              })
  
  thresholds.R.initial <- reactive({data.frame(freq = c(250, 500, 1000, 2000, 3000, 4000, 6000, 8000),
                                          threshold = c(input$R250, input$R500, input$R1000, input$R2000, input$R3000, input$R4000, input$R6000, input$R8000))
                              })
  
  # Limit the dataframe to frequencies with non-null threshold values
  thresholds.L.final <- reactive({thresholds.L.initial()[thresholds.L.initial()$threshold != "", ]
                              })

  thresholds.R.final <- reactive({thresholds.R.initial()[thresholds.R.initial()$threshold != "", ]
                              })
  
  # Select appropriate ISO data based on sex and age, in case percentiles are required
  iso <- reactive({
    subset(isofull, Sex == input$sex & Age == input$age)
    })
  
  # Plot one of two versions
  plotInput <- reactive({
  
    if (input$iso == FALSE) {
 
    # Plot client audiogram only
    ggplot() +        
    # Plot right ear first
    geom_line(data = thresholds.R.final(), aes(x = freq, y = threshold), size = 1.1, linetype = "solid", colour = "red") + 
    geom_point(data = thresholds.R.final(), aes(x = freq, y = threshold), size = 2, stroke = 1.3, shape = 1, colour = "red") +
    geom_text(data = thresholds.R.final(), aes(label = "R", x = (freq[1] - 25), y = threshold[1]), color = "red", size = 5) + 
    # Plot left ear second
    geom_line(data = thresholds.L.final(), aes(x = freq, y = threshold), size = 1.1, linetype = "longdash", colour = "blue") + 
    geom_point(data = thresholds.L.final(), aes(x = freq, y = threshold), size = 2, stroke = 1.3, shape = 4, colour = "blue") +
    geom_text(data = thresholds.L.final(), aes(label = "L", x = (freq[1] - 25), y = threshold[1]), color = "blue", size = 5) + 
    # Other plot parameters         
    labs(x = "Frequency (Hz)", y = "Threshold (dB HL)") +
    scale_y_reverse(limits = c(100, -10), breaks = seq(-10, 100, by = 10)) + 
    scale_x_log10(limits = c(200, 10000), breaks = c(250, 500, 1000, 2000, 3000, 4000, 6000, 8000), labels = c('250', '500', '1000', '2000', '', '4000', '', '8000')) +
    theme_bw() + 
    theme(axis.title = element_text(size = 25), 
      axis.text = element_text(colour = "black", size = 20), 
      text = element_text(size = 20)) + 
    theme(panel.background = element_rect(color = "black", size = 1)) + 
    theme(legend.position = c(0.1, 0.2)) + 
    theme(legend.background = element_rect(fill = "white", color = "black"))
      
    } else {
    
    # Plot ISO percentiles in light grey lines, then client audiogram
    
      # Make percentile labels bigger as percentile lines are spaced further apart
      if (input$age == "20") {customsize <- 3}
      else if (input$age == "30") {customsize <- 4}
      else {customsize <- 5}
    
    ggplot() + 
    # Plot ISO lines first
    geom_line(data = iso(), aes(x = Frequency, y = Percentile90), color = "darkgray", linetype = "solid") + 
    geom_line(data = iso(), aes(x = Frequency, y = Percentile75), color = "darkgray", linetype = "solid") + 
    geom_line(data = iso(), aes(x = Frequency, y = Percentile50), color = "darkgray", linetype = "solid") + 
    geom_line(data = iso(), aes(x = Frequency, y = Percentile25), color = "darkgray", linetype = "solid") + 
    geom_line(data = iso(), aes(x = Frequency, y = Percentile10), color = "darkgray", linetype = "solid") + 
    geom_text(data = iso(), aes(label = "90", x = 8600, y = Percentile90[8]), color = "darkgray", size = customsize) +
    geom_text(data = iso(), aes(label = "75", x = 8600, y = Percentile75[8]), color = "darkgray", size = customsize) +
    geom_text(data = iso(), aes(label = "50", x = 8600, y = Percentile50[8]), color = "darkgray", size = customsize) +
    geom_text(data = iso(), aes(label = "25", x = 8600, y = Percentile25[8]), color = "darkgray", size = customsize) +
    geom_text(data = iso(), aes(label = "10", x = 8600, y = Percentile10[8]), color = "darkgray", size = customsize) +
    # Add client audiogram
    geom_line(data = thresholds.R.final(), aes(x = freq, y = threshold), size = 1.1, linetype = "solid", colour = "red") + 
    geom_point(data = thresholds.R.final(), aes(x = freq, y = threshold), size = 2, stroke = 1.3, shape = 1, colour = "red") +
    geom_text(data = thresholds.R.final(), aes(label = "R", x = (freq[1] - 25), y = threshold[1]), color = "red", size = 5) +  
    geom_line(data = thresholds.L.final(), aes(x = freq, y = threshold), size = 1.1, linetype = "longdash", colour = "blue") + 
    geom_point(data = thresholds.L.final(), aes(x = freq, y = threshold), size = 2, stroke = 1.3, shape = 4, colour = "blue") +
    geom_text(data = thresholds.L.final(), aes(label = "L", x = (freq[1] - 25), y = threshold[1]), color = "blue", size = 5) +
    labs(x = "Frequency (Hz)", y = "Threshold (dB HL)") +
    scale_y_reverse(limits = c(100, -10), breaks = seq(-10, 100, by = 10)) + 
    scale_x_log10(limits = c(200, 10000), breaks = c(250, 500, 1000, 2000, 3000, 4000, 6000, 8000), labels = c('250', '500', '1000', '2000', '', '4000', '', '8000')) +
    theme_bw() + 
    theme(axis.title = element_text(size = 25), 
      axis.text = element_text(colour = "black", size = 20), 
      text = element_text(size = 20)) + 
    theme(panel.background = element_rect(color = "black", size = 1)) + 
    theme(legend.position = c(0.1, 0.2)) + 
    theme(legend.background = element_rect(fill = "white", color = "black"))
      
    }    
    
  })
  
  # Display plot in user interface  
  output$audiogram <- renderPlot({ 
    plotInput()
    })
  
  # Save plot to desktop as PDF
  output$downloadPDF <- downloadHandler(
      filename = function() { 
        paste0("audiogram-", Sys.Date(), ".pdf") 
        },
      content = function(file) { 
        pdf(file, width = 8, height = 6)
        print(plotInput())
        dev.off()
        }
      )

  # Save plot to desktop as PNG
  output$downloadPNG <- downloadHandler(
      filename = function() { 
        paste0("audiogram-", Sys.Date(), ".png") 
        },
      content = function(file) { 
        png(file, width = 800, height = 600)
        print(plotInput())
        dev.off()
        }
      )
  
}

shinyApp(ui, server)
