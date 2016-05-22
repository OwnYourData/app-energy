tabEnergyStatusUI <- function(){
        fluidRow(
                column(1),
                column(10,
                       h3('Anzeige'),
                       fluidRow(
                               column(6,
                                      dateRangeInput('dateRange',
                                                     language = 'de',
                                                     separator = ' bis ',
                                                     format = 'dd.mm.yyyy',
                                                     label = 'Zeitfenster',
                                                     start = Sys.Date() - 30, end = Sys.Date())
                               ),
                               column(6,
                                      selectInput('dateSelect',
                                                  label = 'Auswahl',
                                                  choices = c('letzte Woche'='1',
                                                              'letztes Monat'='2',
                                                              'letzten 2 Monate'='3',
                                                              'letzten 6 Monate'='4',
                                                              'aktuelles Jahr'='5',
                                                              'letztes Jahr'='6',
                                                              'individuell'='7')))
                       ),
                       bsAlert("noData"),
                       hr(),
                       tabsetPanel(type="tabs",
                                   tabPanel("Wasser", 
                                            plotOutput(outputId = "plotWater", height = "300px")),
                                   tabPanel("Strom", 
                                            plotOutput(outputId = "plotCurrent", height = "300px")),
                                   tabPanel("Gas", 
                                            plotOutput(outputId = "plotGas", height = "300px"))
                       ),
                       bsAlert("noPIA"))
        )
}