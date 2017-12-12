shinyUI(
    
    navbarPage(
        
        theme = shinytheme("flatly"),
        
        title="ReportExploreR",
        
        tabPanel("Explore Sentiment",
                 # Generate a row with a sidebar
                 sidebarLayout(
                     # Define the sidebar with one input
                     sidebarPanel(
                         sliderInput("slider", "Time Window:", min = min(df$Date),max = max(df$Date),value=as.Date(c(min(df$Date),max(df$Date))),timeFormat="%b %d, %Y"),
                         selectInput("column","Financial Indicator:", choices=colnames(df)[-c(1:3)], selected ="Adj_Close"),
                         selectInput("reportTypes","Select Report Type:",choices=sort(unique(files_df$report_type)),
                                     selected=c("10-Q", '10-K'), multiple=TRUE),
                         numericInput('numberWords', 'Number of words',value=20, min =2, max=60),
                         textAreaInput("excludedWords","Exclude Words:", value="solid"),
                         hr(), helpText("Data from SEC EDGAR Database")
                     ), # end sidebarPanel
                     # Create a spot for the line plot
                     mainPanel(
                         h2("Trend in Daily Stock Price"), withSpinner(plotlyOutput("linePlot2")),
                         h2("Trend in Disclosure Sentiment"), withSpinner(plotlyOutput("linePlot")),
                         h2("Top Sentiment Contributions"), withSpinner(plotOutput("barplot"))
                     ) # end mainPanel
                 ) # end sidebarLayout
        ),
        tabPanel("Attempt Model",
                 # # Generate a row with a sidebar
                 # sidebarLayout(
                 #     # Define the sidebar with one input
                 #     sidebarPanel(
                 #         sliderInput("holdouts", "Number of holdout samples:", min = min(df$Date),max = max(df$Date),value=as.Date(c(max(df$Date)-365*5,max(df$Date))),timeFormat="%b %d, %Y"),
                 #         selectInput("response","Response Variable:", choices=colnames(df)[-c(1:3)], selected ="Adj_Close"),
                 #         numericInput("responseBuffer","Positive response buffer:", value=.005, min=0, max=0.1),
                 #         selectInput("predictors","Predictor Variables:",choices=colnames(df)[c(2:3)], 
                 #                     selected = colnames(df)[c(2:3)], multiple=TRUE),
                 #         hr(), helpText("Data from SEC EDGAR Database")
                 #     ), # end sidebarPanel
                 #     # Create a spot for the line plot
                 #     mainPanel(
                         h2("Area Under Curve"), #withSpinner(plotlyOutput("linePlot2")),
                         verbatimTextOutput("auc"),
                         h2("AUC Plot"), #withSpinner(plotlyOutput("linePlot")),
                         verbatimTextOutput("aucPlot")
                 #         h2("Top Sentiment Contributions"), withSpinner(plotOutput("barplot"))
                     # ) # end mainPanel
                 # ) # end sidebarLayout
        ),
        tabPanel("View Metadata",
                 # Generate a row with a sidebar
                 fluidPage(
                     h2("Cleaned EDGAR Filings Metadata"),
                     withSpinner(DT::dataTableOutput("metadata"))
                     ) # end fluidPage
        )
    ) # end navbarPage
) # end shinyUI