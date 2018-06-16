library(shiny)
library(shinythemes)

shinyUI(fluidPage(
    
    theme = "custom.css", 
    
    titlePanel(h1(strong("Word Prediction App"), align="center"),
               windowTitle = "Data Science Capstone Project - Natural Language Processing"),
    h5(em("Data Science Project - Natural Language Processing"), align="center"),
    
    hr(),
    
    fluidRow(
        
        column(6, offset = 3,
               
               tabsetPanel(type = "tabs",
                        
                          tabPanel(strong("Application"),
                                   br(),
                                    h5(strong("Enter words here:")),
                                    textInput("inputText", label = "", value = ""),
                                   tags$span(style = "color:grey", em(("Note: Only English words are supported"))),
                                    
                                    fluidRow(
                                        column(6,
                                               br(),
                                               h5(strong("Prediction word:"))
                                        ),
                                        column(9,
                                               verbatimTextOutput("prediction")
                                               
                                        )
                                    ),
                                   br(),
                                   h4(strong("How to use:")),
                                   ("Type words of any length in the first box above. The prediction box automatically returns a suggestion for the next word everytime a user input a word. Check out the About tab page for more information about the project.")
                                    ),
                          tabPanel(strong("About"),
                                   br(),
                                   br(),
                                   p("This project is the final Capstone Project of the Johns Hopkins University Data Science Specialization Program, hosted by Coursera in partnership with SwiftKey."),
                                   p("The application is a mini simulation of SwiftKey's text input apps that are mostly seen on smartphones text messaging or web search sites where next words are predicted when a user type in a word."),
                                   p("This project involves the use of a Machine Learning Algorithm, focusing on the area of Natural Language Processing to analyze and process the human language. See this wikipedia page",
                                   a("here", href = "https://en.wikipedia.org/wiki/Natural_language_processing", target = "_blank"),"to learn more about NLP."),
                                   p("This application is the final result of the project. The details for the previous stages of the project is provided in the Milestone Report as part of the project."),
                                   p("You can directly access the Milestone Report by clicking",  
                                   a("here", href = "http://rpubs.com/adrianromano/396892", target = "_blank"),"."),
                                   p("All the R codes for the project are also available in my",  
                                   a("GitHub", href = "https://github.com/adrianromano/NLP-Word-Prediction-Project", target = "_blank"), "account."),
                                   p("Click",
                                   a("here", href = "https://www.coursera.org/specializations/jhu-data-science", target = "_blank"),
                                   "to learn more about the Data Science Specialization Program.")
                                  ),
                          tabPanel(strong("References"),
                                   br(),
                                   br(),
                                   h5(strong("References:")),
                                   tags$li(tags$a(href = "https://www.pexels.com/photo/black-and-white-laptop-computer-872958/","Background Image Design", target = "_blank")),
                                   tags$li(tags$a(href = "http://bambooanalytics.co/blogs/howTo/shinystyle.html", "Bamboo - Adding Style to Shiny Apps", target = "_blank")),
                                   tags$li(tags$a(href = "https://cran.r-project.org/web/views/NaturalLanguageProcessing.html", "CRAN Task View: Natural Language Processing", target = "_blank")),
                                   tags$li(tags$a(href = "https://fonts.google.com","Google Fonts", target = "_blank")),
                                   tags$li(tags$a(href = "https://en.wikipedia.org/wiki/Natural_language_processing", "Natural language processing Wikipedia page", target = "_blank")),
                                   tags$li(tags$a(href = "http://zevross.com/blog/2016/04/19/r-powered-web-applications-with-shiny-a-tutorial-and-cheat-sheet-with-40-example-apps/", "R powered web applications with Shiny", target = "_blank")),
                                   tags$li(tags$a(href = "https://shiny.rstudio.com/articles/css.html", "Shiny - Style your apps with CSS", target = "_blank")),
                                   tags$li(tags$a(href = "http://docs.rstudio.com/shinyapps.io/getting-started.html", "Shiny Apps - Getting Started", target = "_blank")),
                                   tags$li(tags$a(href = "http://docs.rstudio.com/shinyapps.io/Troubleshooting.html", "Shiny Apps - Troubleshooting", target = "_blank")),
                                   tags$li(tags$a(href = "https://shiny.rstudio.com/images/shiny-cheatsheet.pdf", "Shiny Cheat Sheet", target = "_blank")),
                                   tags$li(tags$a(href = "https://shiny.rstudio.com/articles/tag-glossary.html", "Shiny HTML Tags Glossary", target = "_blank")),
                                   tags$li(tags$a(href = "https://www.jstatsoft.org/article/view/v025i05","Text mining infrastucture in R", target = "_blank")),
                                   tags$li(tags$a(href = "https://www.tidytextmining.com", "Text Mining with R", target = "_blank")))
                    )
              )
        ),
    br(),
    br(),
    br(),
    br(), 
    br(),
    br(),
    br(),
    br(),
    br(),
    br(), 
    br(),
    br(),
    tags$footer(br(),
                br(),
                em("Created with"),
                tags$a(href = "http://www.r-project.org/",
                       target = "_blank",
                       em("R")),
                em("&"),
                tags$a(href = "http://shiny.rstudio.com",
                       target = "_blank",
                       em("Shiny")),
                br(),
                em("By"), 
                tags$a(href = "https://www.linkedin.com/in/adrian-angkawijaya-717b53161/",
                       target = "_blank",
                       em("Adrian R. Angkawijaya")),
                br(),
                em("June 2018"),
                align = "right"
             )
      )
)