####*********************************************####
#   Abhishek Dixit (PG ID: 11915034)
#   Seshadri Deb Roy (PG ID:11915032)
#   Hanumesh Vittal setty Nagur (PG ID :11915088)
#-------------------
#Citation/Refrence: The Code is referred/used from Prof. Sidhir Voleti's TA Class's, on Shiny & UDpipe Explorationexample (session 4 &5)
#-----------------
####*********************************************####

library(shiny)
library(shinycssloaders)
library(dplyr)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)
library(shinythemes)

# Define UI for application for UDPipe NLP workflow
shinyUI(fluidPage(

    # Application title
    titlePanel("Q3:Building a Shiny App around the UDPipe NLP workflow"),
    #shinythemes::themeSelector(),
    theme = shinythemes::shinytheme("sandstone"),
    
    # Sidebar 
    sidebarLayout(
        sidebarPanel(
            fileInput("rawtxtfile", "Please Upload the Text File for further Analysis (in '.txt' format only)",accept = ".txt",multiple = FALSE),
            fileInput("udpipemodel", "Please Upload the Resepective language UDPipe Model:",accept = ".udpipe"),
            
            checkboxGroupInput("upos_checkgroup", label = h3("Select the Speech Tags(upos)"), 
                               choices = list("Adjective" = "ADJ", "Noun" = "NOUN", "Proper Noun" = "PROPN", "Adverb" = "ADV", "Verb" = "VERB"),
                               selected = c("ADJ","NOUN","PROPN")),
            
            # selectInput("langmodel", label = h3("Select Language"), 
            #             choices = list("English" = "English", "Spanish" = "Spanish","Hindi" = "Hindi"), 
            #             selected = "English"),
            
            sliderInput("maxwrds","Max. Words in WordCloud:",min = 1,max = 150,value = 100),
            hr(),
            submitButton(text = "Submit", icon("refresh"))
        ),#end of SidebarPanel

        # Tabbed Main panel
        mainPanel(
            tabsetPanel(type = "tabs",
                        
                        tabPanel("Overview",h4(p("Synopisis")),
                                 tags$li("The Purpose of this Demo Shiny App is to apply the acquired learnings from the TABA class of CBA and demonstrte the UDPipe NLP workflow", align = "justify"),              
                                 tags$li("The App uses UDPipe language Models, which can be downloaed from @:" , a(href="https://www.rdocumentation.org/packages/udpipe/versions/0.7/topics/udpipe_download_model","udpipe Models") , align = "justify"),
                            
                                 h4(p("How to use this App")),
                                 
                                 tags$li("To use this app there are two Prerequisites:\n 
                                         a) A document corpus in '.txt' file format.
                                         b) The UDPipe Model for the respective language(Use English Model for current Demo)", align = "justify"),
                                 tags$li("Please use the sample English text file, a Sample can be referred here:" , a(href="http://","Sample English Text file"), align = "justify"),
                                 br(),
                                 tags$li("For perfroming the Required Analysis on your document,Please follow the steps as below:",
                                 p("a) Click on Browse, on the control panel on the left and upload the Sample text file.Or you can use your own
                                    text file document(e.g: scraped pages form wiki,news sites,journals etc. in '.txt' format"),
                                 p("b) Click on Browse, on the control panel on the left and upload the UDPipe Model."), align = "justify"),
                                 
                                 tags$li("Inorder to modify the inputs, u can change the parameters in left side-bar panel and Click Submit.", align = "Justify"),
                                 br(),
                                 tags$li("NOTE: For now We have used only English Model for the Demo, but on downaloding the UDPipe Model rest of the 52 languauges
                                         can also be demonstrated here, subject to usng there respective Sample text files", align = "justify"),
                                 tags$li("NOTE: Please also try the Borwser interface instead of R Interface, for better experience. ", align = "justify")

       
                        ),

                        tabPanel("Annotated Data Table",
                                 h4(tags$li("Download Full file as '.CSV'")),
                                 downloadButton("dltable", "Download CSV File)"),br(),br(),
                                 wellPanel(withSpinner(dataTableOutput('annot_data_tabel')))),
                        
                        tabPanel("Word Clouds(Nouns & Verbs)",
                                 h4("Word Cloud for All Nouns"),wellPanel(withSpinner( plotOutput("nouncloud"))),
                                 h4("Word Cloud for all Verbs"),wellPanel(withSpinner( plotOutput("verbcloud")))),
                        
                        tabPanel("Co-occurrence plot of seleted upos's",wellPanel(withSpinner( plotOutput("plotcoocr"))))
                        
            )
        )
    )
))
