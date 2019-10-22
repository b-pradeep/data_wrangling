#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# 

library(shiny)
library(dplyr)
library(skimr)
library(tidyverse)
library(DT)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    loaded_df <- reactive({
        df= get(paste(input$df_select,"data",sep="_"))
        df
    })
    
    cleaned_df<- reactive({
        cleaned_df= get(paste(input$type_select,"data",sep="_"))
        cleaned_df
    })

    output$selectedDataTable <- renderDataTable({
        DT::datatable(data= loaded_df(), 
                      selection = input$selection,
                      filter = list(position = input$filter),
                      options = list(searching = TRUE,ordering=input$order,scrollX = TRUE,pageLength=30,lengthMenu = c(5, 10, 30)),
                      style = 'bootstrap', class = 'table-striped')
    })

    output$dataGlimpse <- renderPrint({
        str(loaded_df())
    })
    
    #Summary of the dataset
    output$dataSummary <- renderPrint({
        skim(loaded_df())
    })
    
    output$schoolDist <- renderPlotly({
        table <- table(cleaned_df()$city)
        df <- data.frame(table)
        title <- paste(paste("Number of",input$type_select,sep=" "), "across each Region",sep=" ")
        bar_plot <- ggplot(df, aes(x = reorder(Var1, -Freq), y = Freq))+xlab("Cities")+ylab(paste("Number of",input$type_select,sep=" "))
        bar_plot <- bar_plot + geom_bar(stat="identity", color='skyblue',fill='steelblue')
        bar_plot <- bar_plot + theme(axis.text.x=element_text(angle=45, hjust=1)) + geom_text(aes(label=Freq), vjust=-1)+ggtitle(title)
        ggplotly(bar_plot)
    })
    
    cleaned_id_df <- reactive({
    temp_df = cleaned_df()
    rounded_ratings = trunc(temp_df$rating)
    temp_df$Ratings = as.factor(rounded_ratings)
    temp_df$ID = 1:nrow(temp_df)
    temp_df
    })
    
    
    output$ratingsPlot <- renderPlotly({
        ratingPlot <- cleaned_id_df() %>%
            group_by(city,Ratings) %>%
            summarize(total_schools=n_distinct(ID)) %>%
            ggplot(aes(x=city, y=total_schools,fill=Ratings)) +
            geom_bar(stat="identity", position="dodge")+
            ggtitle("Grouping schools according to ratings across each region") +
            xlab("City") + ylab("Number of Schools")+
            theme(plot.title = element_text(hjust = 0.5), panel.background = element_blank(),axis.text.x = element_text(angle = 45, hjust = 1))
        ggplotly(ratingPlot)
        
    })
    
    output$schoolName <- renderUI({
        req(input$city_name)
        schoolname=schools_data %>% filter(city == input$city_name)
        schoolname=schoolname$school_name
        selectInput("school_name",label="Select the School",choices=schoolname,selected=schoolname[1])
    })
    
    
    output$schoolPlot <- renderLeaflet({
        schools_data%>% 
            leaflet() %>% 
            addTiles() %>% 
            addMarkers(clusterOption=markerClusterOptions(),popup=schools_data$school_name,lat=schools_data$school_latitude,lng = schools_data$school_longitude)
    })
    
    output$schoolHospital <- renderLeaflet({
        req(input$city_name)
        req(input$school_name)
        Hospital_select<-distance_data%>%filter(city_school==input$city_name & school== input$school_name )
        
        Hospital_select%>% 
            leaflet() %>% 
            addTiles() %>% 
            addMarkers(lat = Hospital_select$school_latitude,lng = Hospital_select$school_longitude,popup = Hospital_select$school)%>%
            addTiles()%>%
            addCircleMarkers(lng=Hospital_select$hospital_longitude, lat=Hospital_select$hospital_latitude, popup=Hospital_select$hospital,fillColor="red")
        
    })
})
