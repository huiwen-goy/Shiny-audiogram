
library(shiny)
library(ggplot2)

# Read datasets for plotting speech information & ISO percentiles
df_sp_spectrum <- read.csv("Olsen_1987_Fig_12.csv", header=TRUE)
df_sp_banana <- read.csv("Kent_and_Read_2002_Fig_5_45.csv", header=TRUE)
df_iso <- read.csv("ISO2017full.csv", header=TRUE)

#Prepare lines & shapes, ready to be drawn if called
  #WHO categories for degree of hearing loss
  categories_WHO <- list(
    geom_hline(yintercept = 20, col = "cadetblue", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Normal", x = 130, y = 5), col = "cadetblue", size=5, hjust = 0), 
    geom_hline(yintercept = 35, col = "cadetblue", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Mild", x = 130, y = 27.5), col = "cadetblue", size=5, hjust = 0), 
    geom_hline(yintercept = 50, col = "cadetblue", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Moderate", x = 130, y = 42.5), col = "cadetblue", size=5, hjust = 0), 
    geom_hline(yintercept = 65, col = "cadetblue", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Moderately severe", x = 130, y = 57.5), col = "cadetblue", size=5, hjust = 0), 
    geom_hline(yintercept = 80, col = "cadetblue", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Severe", x = 130, y = 72.5), col = "cadetblue", size=5, hjust = 0), 
    geom_hline(yintercept = 95, col = "cadetblue", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Profound", x = 130, y = 87.5), col = "cadetblue", size=5, hjust = 0), 
    geom_text(aes(label = "Anacusis", x = 130, y = 105), col = "cadetblue", size=5, hjust = 0) 
    )
  
  #Clark 1981 categories for degree of hearing loss
  categories_Clark <- list( 
    geom_hline(yintercept = 15, col = "darkorange3", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Normal", x = 130, y = 0), col = "darkorange3", size=5, hjust = 0), 
    geom_hline(yintercept = 25, col = "darkorange3", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Slight", x = 130, y = 20), col = "darkorange3", size=5, hjust = 0),
    geom_hline(yintercept = 40, col = "darkorange3", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Mild", x = 130, y = 32.5), col = "darkorange3", size=5, hjust = 0),
    geom_hline(yintercept = 55, col = "darkorange3", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Moderate", x = 130, y = 47.5), col = "darkorange3", size=5, hjust = 0),
    geom_hline(yintercept = 70, col = "darkorange3", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Moderately severe", x = 130, y = 62.5), col = "darkorange3", size=5, hjust = 0),
    geom_hline(yintercept = 90, col = "darkorange3", linewidth = 1.1, linetype="dotted"),
    geom_text(aes(label = "Severe", x = 130, y = 80), col = "darkorange3", size=5, hjust = 0),
    geom_text(aes(label = "Profound", x = 130, y = 103), col = "darkorange3", size=5, hjust = 0) 
    )

  #speech spectrum
  sp_spectrum <- list(
    #curve B
    geom_path(data = subset(df_sp_spectrum, curve=="B"), aes(x=frequency_Hz, y=hearing_level_dB), col="grey"),
    geom_text(aes(label = "10th percentile of speech levels", x=126, y=-2), col="grey", hjust=0, angle=-28),
    #curve A
    geom_path(data = subset(df_sp_spectrum, curve=="A"), aes(x=frequency_Hz, y=hearing_level_dB), col="grey"),
    geom_text(aes(label = "50th percentile of speech levels", x=127, y=13), col="grey", hjust=0, angle=-37),
    #curve C
    geom_path(data = subset(df_sp_spectrum, curve=="C"), aes(x=frequency_Hz, y=hearing_level_dB), col="grey"),
    geom_text(aes(label = "99th percentile of speech levels", x=128, y=24), col="grey", hjust=0, angle=-38),
    #shaded area
    geom_polygon(data = subset(df_sp_spectrum, curve=="polygon"), aes(x=frequency_Hz, y=hearing_level_dB), fill="yellow", alpha=0.1) 
    )

  #speech banana
  sp_banana <- list(
    #demarcate different areas
    geom_path(data = subset(df_sp_banana, type=="f0"), aes(x=frequency_Hz, y=hearing_level_dB), col="grey"),
    geom_path(data = subset(df_sp_banana, type=="high_consonant"), aes(x=frequency_Hz, y=hearing_level_dB), col="grey"),
    geom_path(data = subset(df_sp_banana, type=="main_consonant"), aes(x=frequency_Hz, y=hearing_level_dB), col="grey"),
    geom_path(data = subset(df_sp_banana, type=="vowel_formants"), aes(x=frequency_Hz, y=hearing_level_dB), col="grey"),
    #add shaded area
    geom_polygon(data = subset(df_sp_banana, type=="polygon"), aes(x=frequency_Hz, y=hearing_level_dB), 
                 fill="yellow", alpha=0.1),
    #labels for speech banana
    geom_text(aes(label = "f0", x = 175, y = 28), col = "grey"),
    geom_text(aes(label = "Consonants", x = 1000, y = 32), col = "grey"),
    geom_text(aes(label = "Consonant-vowel transitions", x = 1000, y = 37), col = "grey"),
    geom_text(aes(label = "High consonants", x = 5500, y = 33), col = "grey"),
    geom_text(aes(label = "f", x = 7733, y = 28), col = "grey"),
    geom_text(aes(label = "th", x = 7000, y = 27), col = "grey"),
    geom_text(aes(label = "s", x = 6839, y = 38), col = "grey"),
    geom_text(aes(label = "sh", x = 3820, y = 38), col = "grey"),
    geom_text(aes(label = "Vowel formants", x = 1000, y = 56), col = "grey") )
  

######################
ui <- fluidPage(
  
  #fluidRow 1: instructions
  fluidRow(
    
    style = "padding: 1em 1em; margin:0em",
    tags$b(p("Plotting an audiogram")),
    p("Fill in the thresholds for the left and right ear (-10 to 110). Better hearing is higher on the y-axis. Leave the box blank if there is no measurement."), 
    p("Plot different categories of hearing loss by selecting \"WHO categories\" or \"Clark (1981)\"."),
    p("Plot percentile values from a normative sample (ISO 7029:2017) by checking \"Plot ISO percentiles\" and selecting the sex and closest age group."),
    p("\"Speech spectrum\" plots the 10th, 50th and 99th percentiles of conversational speech levels (Olsen et al., 1987)."),
    p("\"Speech banana\" plots the regions where vowels and consonants fall (Kent & Read, 2002).")
  
    ), #end fluidRow 1: instructions
  
  hr(), 
  
  #fluidRow 2: plot & threshold inputs
  fluidRow(
    
    #sidebarLayout with plot on left and panel with inputs on right
    sidebarLayout(
      
      position = c("left"),
      fluid = TRUE, 
      
      #mainPanel: plot
      mainPanel(
        
        width = 7,
        plotOutput("audiogram", width = 700, height = 525)
        
        ), #end mainPanel
      
      # panel with all inputs: thresholds, degree selection, ISO selection, speech selection
      sidebarPanel(
        
        width = 4, #less 1 to create space on the right edge
        style = "background-color: grey90",
        
        #header row for thresholds
        fluidRow(column(width = 4, align = "center", style = "font-size: 1.25em; color: blue", "Left ear"), 
          column(width = 4, align = "center", style = "font-size: 1.25em; color: black", "Frequency"), 
          column(width = 4, align = "center", style = "font-size: 1.25em; color: red", "Right ear")
          ),  #end header row
      
        br(),
      
        #row for LE and RE thresholds at 250 Hz
        fluidRow(column(width = 4, numericInput(inputId = "L250", label = NULL, value = NULL, step = 5, min = -10, max = 110)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "250"), 
               column(width = 4, numericInput(inputId = "R250", label = NULL, value = NULL, step = 5, min = -10, max = 110)) 
               ), 
      
        #row for LE and RE thresholds at 500 Hz
        fluidRow(column(width = 4, numericInput(inputId = "L500", label = NULL, value = NULL, step = 5, min = -10, max = 110)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "500"), 
               column(width = 4, numericInput(inputId = "R500", label = NULL, value = NULL, step = 5, min = -10, max = 110)) 
               ),
      
        #row for LE and RE thresholds at 1000 Hz
        fluidRow(column(width = 4, numericInput(inputId = "L1000", label = NULL, value = NULL, step = 5, min = -10, max = 110)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "1000"),
               column(width = 4, numericInput(inputId = "R1000", label = NULL, value = NULL, step = 5, min = -10, max = 110))
               ), 
  
        #row for LE and RE thresholds at 2000 Hz
        fluidRow(column(width = 4, numericInput(inputId = "L2000", label = NULL, value = NULL, step = 5, min = -10, max = 110)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "2000"),
               column(width = 4, numericInput(inputId = "R2000", label = NULL, value = NULL, step = 5, min = -10, max = 110))
               ), 
  
        #row for LE and RE thresholds at 3000 Hz
        fluidRow(column(width = 4, numericInput(inputId = "L3000", label = NULL, value = NULL, step = 5, min = -10, max = 110)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "3000"),
               column(width = 4, numericInput(inputId = "R3000", label = NULL, value = NULL, step = 5, min = -10, max = 110))
               ), 
  
        #row for LE and RE thresholds at 4000 Hz
        fluidRow(column(width = 4, numericInput(inputId = "L4000", label = NULL, value = NULL, step = 5, min = -10, max = 110)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "4000"),
               column(width = 4, numericInput(inputId = "R4000", label = NULL, value = NULL, step = 5, min = -10, max = 110))
               ), 
       
        #row for LE and RE thresholds at 6000 Hz
        fluidRow(column(width = 4, numericInput(inputId = "L6000", label = NULL, value = NULL, step = 5, min = -10, max = 110)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "6000"),
               column(width = 4, numericInput(inputId = "R6000", label = NULL, value = NULL, step = 5, min = -10, max = 110))
               ), 
  
        #row for LE and RE thresholds at 8000 Hz
        fluidRow(column(width = 4, numericInput(inputId = "L8000", label = NULL, value = NULL, step = 5, min = -10, max = 110)),
               column(width = 4, align = "center", style = "font-size: 1.25em; padding-top: 5px", "8000"),
               column(width = 4, numericInput(inputId = "R8000", label = NULL, value = NULL, step = 5, min = -10, max = 110))
               ),
        
        ) #end sidebarPanel
      
       ) #end sidebarLayout
    
      ), #end fluidRow 2: plot & threshold inputs 
  
    hr(),
      
      #fluidRow 3: add-ons to audiogram plus download buttons
      fluidRow(
      
        #column 1 for degrees selection
        column(
          
          width = 3, 
          radioButtons(inputId = "degreeHL", 
                       label = tags$b(p("Degree of hearing loss")), 
                       choiceNames = c("None plotted", "WHO categories", "Clark (1981) categories"), 
                       choiceValues = c("deg_none", "deg_who", "deg_clark"), 
                       inline = FALSE)
          
          ), #end column 1 for degrees selection
        
        #column 2 for ISO checkbox and selections
        column(
          
          width = 3,
          fluidRow(checkboxInput(inputId = "iso", label = tags$b("Plot ISO percentiles"), value = FALSE)),
          
          #putting sex & age side by side
          fluidRow(
            column(width = 6,
                   selectInput(inputId = "sex", label = "Sex", choices = c("Female", "Male"))),
            
            column(width = 6,
                   selectInput(inputId = "age", label = "Age", choices = c("20", "30", "40", "50", "60", "70", "80"))),
            ) #end sex & age fluidRow
          
          ), #end column 2 for ISO
                
        #blank column for more spacing
        column(width = 1),
        
        #column 3 for speech selection
        column(
          
          width = 3,
          radioButtons(inputId = "speech", 
                       label = tags$b(p("Speech information")), 
                       choiceNames = c("None plotted", "Speech spectrum", "Speech banana"), 
                       choiceValues = c("sp_none", "sp_spec", "sp_ban"), 
                       inline = FALSE)
          
          ), #end column 3 for speech selection
        
        #column 4 for download buttons
        column(
          
          width = 2,
          br(), 
          fluidRow(downloadButton(outputId = "downloadPDF", label = "Download PDF")),
          br(),
          fluidRow(downloadButton(outputId = "downloadPNG", label = "Download PNG")),
          br()
          
          ) #end column 4 for download buttons
        
      ) #end fluidRow 3 for add-ons to audiogram plus download buttons
  
    ) #end fluidPage 
  
######################  

server <- function(input, output){
  
  #collect all the input thresholds into dataframes
  thresholds.L.initial <- reactive({
    data.frame(freq = c(250, 500, 1000, 2000, 3000, 4000, 6000, 8000),
               threshold = c(input$L250, input$L500, input$L1000, input$L2000, input$L3000, input$L4000, input$L6000, input$L8000))
    })
  
  thresholds.R.initial <- reactive({
    data.frame(freq = c(250, 500, 1000, 2000, 3000, 4000, 6000, 8000),
               threshold = c(input$R250, input$R500, input$R1000, input$R2000, input$R3000, input$R4000, input$R6000, input$R8000))
    })
  
  #select only rows with non-empty thresholds; otherwise get a broken line
  thresholds.L.final <- reactive({
    thresholds.L.initial()[thresholds.L.initial()$threshold != "", ]
    })

  thresholds.R.final <- reactive({
    thresholds.R.initial()[thresholds.R.initial()$threshold != "", ]
    })
  
  #select subset of ISO data based on sex and age
    isosub <- reactive({
      subset(df_iso, Sex == input$sex & Age == input$age)
    }) 
  
  #prepare relevant subset of ISO lines and labels
    iso_lines <- reactive({ 
      list(
    geom_line(data = isosub(), aes(x = Frequency, y = Percentile90), color = "grey70", linetype = "solid"), 
    geom_line(data = isosub(), aes(x = Frequency, y = Percentile75), color = "grey70", linetype = "solid"), 
    geom_line(data = isosub(), aes(x = Frequency, y = Percentile50), color = "grey70", linetype = "solid"), 
    geom_line(data = isosub(), aes(x = Frequency, y = Percentile25), color = "grey70", linetype = "solid"), 
    geom_line(data = isosub(), aes(x = Frequency, y = Percentile10), color = "grey70", linetype = "solid"), 
    geom_text(data = isosub(), aes(label = "90", x = 8600, y = Percentile90[8]), color = "grey30", size = 3),
    geom_text(data = isosub(), aes(label = "75", x = 8600, y = Percentile75[8]), color = "grey30", size = 3),
    geom_text(data = isosub(), aes(label = "50", x = 8600, y = Percentile50[8]), color = "grey30", size = 3),
    geom_text(data = isosub(), aes(label = "25", x = 8600, y = Percentile25[8]), color = "grey30", size = 3),
    geom_text(data = isosub(), aes(label = "10", x = 8600, y = Percentile10[8]), color = "grey30", size = 3)
    ) 
    })
  
  #store reactive plot here later
    plot_for_printing <- reactiveValues()
    
  #display plot in user interface
  output$audiogram <- renderPlot({ 
    
    #create base plot
    plot_audiogram <- ggplot() +        
      # Plot right ear first
      geom_line(data = thresholds.R.final(), aes(x = freq, y = threshold), linewidth = 1.1, linetype = "solid", colour = "red") + 
      geom_point(data = thresholds.R.final(), aes(x = freq, y = threshold), size = 2, stroke = 1.3, shape = 1, colour = "red") +
      geom_text(data = thresholds.R.final(), aes(label = "R", x = (freq[1] - 25), y = threshold[1]), color = "red", size = 6) + 
      # Plot left ear second
      geom_line(data = thresholds.L.final(), aes(x = freq, y = threshold), linewidth = 1.1, linetype = "longdash", colour = "blue") + 
      geom_point(data = thresholds.L.final(), aes(x = freq, y = threshold), size = 2, stroke = 1.3, shape = 4, colour = "blue") +
      geom_text(data = thresholds.L.final(), aes(label = "L", x = (freq[1] - 25), y = threshold[1]), color = "blue", size = 6) + 
      # Other plot parameters         
      labs(x = "Frequency (Hz)", y = "Threshold (dB HL)") +
      scale_y_reverse(limits = c(110, -10), breaks = seq(-10, 110, by = 10)) + 
      scale_x_log10(limits = c(125, 10000), breaks = c(125, 250, 500, 1000, 2000, 3000, 4000, 6000, 8000), labels = c('125', '250', '500', '1000', '2000', '', '4000', '', '8000')) +
      theme_bw() + 
      theme(plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")) +  
      theme(axis.title = element_text(size = 25), 
      axis.text = element_text(colour = "black", size = 20), 
      text = element_text(size = 20)) + 
      theme(panel.background = element_rect(color = "black", linewidth = 1)) + 
      theme(legend.position = c(0.1, 0.2)) + 
      theme(legend.background = element_rect(fill = "white", color = "black"))
    
    if (input$degreeHL == "deg_who") {plot_audiogram <- plot_audiogram + categories_WHO} 
    if (input$degreeHL == "deg_clark") {plot_audiogram <- plot_audiogram + categories_Clark} 
    if (input$speech == "sp_spec") {plot_audiogram <- plot_audiogram + sp_spectrum} 
    if (input$speech == "sp_ban") {plot_audiogram <- plot_audiogram + sp_banana} 
    if (input$iso == TRUE) {plot_audiogram <- plot_audiogram + iso_lines()}

    plot_for_printing$plot_audiogram <- plot_audiogram
    plot_audiogram
    
    })  #end renderPlot

  
  #save plot as PDF
  output$downloadPDF <- downloadHandler(
      filename = function() { "audiogram.pdf" },
      content = function(file) { 
        pdf(file, width = 8, height = 6)
        print(plot_for_printing$plot_audiogram)
        dev.off()
        }
      )

  #save plot as PNG
  output$downloadPNG <- downloadHandler(
      filename = function() { "audiogram.png" },
      content = function(file) { 
        png(file, width = 800, height = 600)
        print(plot_for_printing$plot_audiogram)
        dev.off()
        }
      )
  
  } #end server
  
#################################################

shinyApp(ui, server)
