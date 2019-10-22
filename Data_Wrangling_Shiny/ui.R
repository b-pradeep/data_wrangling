#install.packages("shinydashboard")
#install.packages("shinyjqui")
library(shinydashboard)
library(shinyjqui)

ui <- dashboardPage(skin="purple",
                    dashboardHeader(title="Menu"),
                    dashboardSidebar(sidebarMenu(
                        menuItem("DataFrame", tabName = "dataFrame", icon = icon("table")
                        ),
                        menuItem("School Distribution", tabName = "schoolDist", icon = icon("chart-bar")
                        ),
                        menuItem("School Location", tabName = "schoolLoc", icon = icon("hospital")
                        )
                    )),
                    dashboardBody(tags$head(tags$style(HTML(
                        '.myClass { 
        font-size: 20px;
        line-height: 50px;
        text-align: left;
        font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
        padding: 0 15px;
        overflow: hidden;
        color: white;
      }
    '))),
                        tags$script(HTML('$(document).ready(function() {
                      $("header").find("nav").append(\'<div class="myClass"> Pradeep(52817492), Vijayalakshmi(71389086), Praveen(72435364), Venkat(82530062)</div>\');
                      })')),
                        tabItems(
                            
                            tabItem(tabName="dataFrame",
                                    sidebarLayout(
                                        sidebarPanel(width=2,
                                                     selectInput("df_select", "Select Dataset", choices=c("schools","hospital","distance"), selected = "schools"),
                                                     checkboxInput("order", "Column ordering", value=T),
                                                     selectInput("filter", "Filter type", choices=c("none","top","bottom"), selected = "none"),
                                                     selectInput("selection", "Selection type", choices=c("none","single","multiple"), selected = "none")
                                                     
                                        ),
                                        mainPanel(width=10,
                                                  navbarPage("DataFrame",
                                                             
                                                             tabPanel("Data Table",
                                                                      DT::dataTableOutput("selectedDataTable")
                                                             ),
                                                             tabPanel("Summary",verticalLayout(
                                                                 verbatimTextOutput("dataGlimpse"),
                                                                 verbatimTextOutput("dataSummary")))
                                                  )
                                        ))
                            )
                            
                            
                        ,
                          tabItem(tabName="schoolDist",
                                  sidebarLayout(
                                    sidebarPanel(width=2,
                                                 selectInput("type_select", "Select Dataset", choices=c("schools","hospital"), selected = "schools")
                                                 
                                    ),
                                    mainPanel(width=10,
                                              navbarPage("Schools and Hospital Distribution",
                                              tabPanel("By Region",plotlyOutput("schoolDist",height="700px")),
                                              tabPanel("By Rating",plotlyOutput("ratingsPlot",height="700px"))
                                              )
                                    ))
                          ),
                        tabItem(tabName="schoolLoc",
                                navbarPage("Map Plot",
                                           tabPanel("School Plot",
                                                    leafletOutput("schoolPlot",height="800px")
                                           ),
                                tabPanel("Hospitals Nearby for Each School",sidebarLayout(
                                  sidebarPanel(width=2,
                                               selectInput("city_name", "Select city", choices=cities),
                                               uiOutput("schoolName")
                                               
                                  ),
                                  mainPanel(width=10,
                                            leafletOutput("schoolHospital",height="800px")
                                            
                                  )))
                                
                                )
                        )
                        )
                        
                    )
)
