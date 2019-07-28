####*********************************************####
#   Abhishek Dixit (PG ID: 11915034)
#   Seshadri Deb Roy (PG ID:11915032)
#   Hanumesh Vittal setty Nagur (PG ID :11915088)
#-------------------
#Citation/Refrence: The Code is referred/used from Prof. Sidhir Voleti's TA Class's, on Shiny & UDpipe Explorationexample (session 4 &5)
#-----------------
####*********************************************####

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    dataset <- reactive({
        if (is.null(input$rawtxtfile)) {return(NULL)}
        else {
            dataset = readLines(input$rawtxtfile$datapath,encoding = "UTF-8")
            cln_dataset  =  str_replace_all(dataset, "<.*?>", "")
            return(cln_dataset)}
    })
    
    annonated_doc <- reactive({
        if (is.null(input$rawtxtfile) | is.null(input$udpipemodel)) {
            # User has not uploaded a file yet
            return(NULL)
        }
        #udpipe_langmodel<- udpipe_download_model(input$langmodel)  
        #udpipe_model <- udpipe_load_model(udpipe_langmodel)
        #return(udpipe_model)
        udp_mod <- udpipe_load_model(file = input$udpipemodel$datapath)
        ant_doc <- udpipe_annotate(udp_mod, x = dataset())
        ant_doc <- as.data.frame(ant_doc)
        return(ant_doc)
    })
    
    output$annot_data_tabel <- renderDataTable({
        x<-select(annonated_doc(),-'sentence')
        top100_annot_doc <- head(x, 100)
        return(top100_annot_doc)
    })

    maxwrdcnt <- reactive({
        if (is.null(input$maxwrds)) {return(NULL)}
        else {
            #print(input$maxwrds)
            return(input$maxwrds)}
    })
    
    #Word Cloud for Nouns   
    output$nouncloud = renderPlot({
        if(is.null(input$rawtxtfile)){return(NULL)}
        else{
            all_nouns = annonated_doc()%>% subset(., upos %in% "NOUN") 
            top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
            
            wordcloud(top_nouns$key,top_nouns$freq, min.freq = 2,max.words =maxwrdcnt(),random.order = FALSE,colors = brewer.pal(6, "Dark2") )
        }
    })
    
    #Word Cloud for Verbs 
    output$verbcloud = renderPlot({
        if(is.null(input$rawtxtfile)){return(NULL)}
        else{
            all_verbs = annonated_doc()%>% subset(., upos %in% "VERB") 
            top_verbs = txt_freq(all_verbs$lemma)
            
            wordcloud(top_verbs$key,top_verbs$freq, min.freq = 2,max.words = maxwrdcnt(),random.order = FALSE,colors = brewer.pal(6, "Dark2") )
        }
    })
    
    #Getting Co-occurence based on Upos slected
    data_coocr =  reactive({
        data_cooc <- cooccurrence(
                        x = subset(annonated_doc(), upos %in% input$upos_checkgroup),
                        term = "lemma",
                        group = c("doc_id", "paragraph_id", "sentence_id"))
        return(data_cooc)
    })
    
    output$plotcoocr = renderPlot({
        if(is.null(input$rawtxtfile)){return(NULL)}
        else{
            # data_coocr <- cooccurrence(
            #     x = subset(annonated_doc(), upos %in% input$upos_checkgroup),
            #     term = "lemma",
            #     group = c("doc_id", "paragraph_id", "sentence_id"))
            
            wordnetwork <- head(data_coocr(), 30)
            wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
            
            ggraph(wordnetwork, layout = "fr") +

                geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +
                geom_node_text(aes(label = name), col = "darkgreen", size = 5) +

                theme_graph(base_family = "Arial Narrow") +
                theme(legend.position = "none") +

                labs(title = "Top 30 Cooccurrences Plot", subtitle = "Accordingly selecte the upos from the checkbox")
        }
    })
    
    
    output$dltable <- downloadHandler(
        
        filename = function() { "Annotated_table.csv" },
        
        content = function(file) {write.csv(select(annonated_doc(),-'sentence'),file)
        }
    )
})
