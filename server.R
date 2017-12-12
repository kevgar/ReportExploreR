# Define a server for the Shiny app
function(input, output, session) {
    
    ##########################################################
    # Normalized sentiment over time
    ##########################################################
    
    sentiment_new <- reactive({
        # browser()
        
        ind <- which(df$Date >= input$slider[1] & 
                         df$Date <= input$slider[2] &
                         df$report_type %in% input$reportTypes)
        
        l <- lapply(1:length(ind), function(i) wordFrq[[ind[i]]])
        
        vapply(1:length(l), function(i) {
            dt <- data.table(l[[i]])
            # dt <- dt[!WORD %in% input$excludedWords,]
            # dt <- dt[,list(FREQUENCY=sum(FREQUENCY)), by='WORD']
            
            pos <- pos.words[!pos.words %in% input$excludedWords]
            neg <- neg.words[!neg.words %in% input$excludedWords]
            
            posFrq <- dt[WORD %in% pos,'FREQUENCY']
            negFrq <- dt[WORD %in% neg,'FREQUENCY']
            
            sum_pos <- sum(posFrq)
            sum_neg <- sum(negFrq)
                
            (sum_pos-sum_neg)/(sum_pos+sum_neg)
            
        }, FUN.VALUE=numeric(1))
        
        })
    
    # Line plot
    output$linePlot <- renderPlotly({
        
        df <- df[df$report_type %in% input$reportTypes &
                     df$Date >= input$slider[1] &
                     df$Date <= input$slider[2],]
        
        df$sentiment <- sentiment_new()
        
        plot_ly(x=~Date, y=~sentiment, 
                type="scatter", mode="lines+markers",
                data=df)
        })
    
    # Line plot
    output$linePlot2 <- renderPlotly({
        
        df <- df[df$Date >= input$slider[1] &
                     df$Date <= input$slider[2],]
        
        plot_ly(x=~Date, y=~eval(parse(text = input$column)), 
                type="scatter", mode="lines",
                data=df) %>% 
            # format the y-axis
            layout(yaxis = list(title = input$column))
    })
    
    # Create sentiment barplot
    output$barplot <-  renderPlot({
        
        # browser()
        
        # Prepare data for the barplot
        ind <- which(df$Date >= input$slider[1] & df$Date <= input$slider[2])
        wordFrq_list <- lapply(1:length(ind), function(i) wordFrq[[ind[i]]])
        wordFrq_combined <- data.table(do.call(rbind, wordFrq_list))
        wordFrq_combined <- wordFrq_combined[!wordFrq_combined$WORD %in% input$excludedWords,]
        wordFrq_agg <- wordFrq_combined[,list(FREQUENCY=sum(FREQUENCY)), by='WORD']
        wordFrq_agg <- wordFrq_agg[order(-FREQUENCY),]
        pos <- wordFrq_agg[WORD %in% pos.words,]
        neg <- wordFrq_agg[WORD %in% neg.words,]
        neg$FREQUENCY <- -1*neg$FREQUENCY
        negpos <- rbind(head(neg, input$numberWords/2), head(pos,input$numberWords/2))
        
        # Generate the barplot
        ggplot(mapping=aes(x=reorder(WORD, FREQUENCY),y=FREQUENCY, fill = FREQUENCY>0), negpos) +
            geom_col(show.legend = FALSE) +
            xlab('WORD') +
            coord_flip()
        
    })
    
    # Render the text
    output$auc <- renderText("Coming soon..")
    output$aucPlot <- renderText("Coming soon..")
    
    # Display the document metadata
    output$metadata <-  DT::renderDataTable({
        df <- getCleanFilingInfo()
        df[df$ticker=='JPM',]
    }, rownames= FALSE)
    
    
    
} # end server function