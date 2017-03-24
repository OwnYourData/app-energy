# configure types of energy
# last update: 2017-03-23

appSourceData <- function(){
        tabPanel('Datenerfassung', br(),
                 fluidRow(
                         column(2,
                                img(src='write.png',
                                    width='70px',
                                    style='margin-left:40px;')),
                         column(10,
                                helpText('Erfasse hier einen neuen Eintrag über den Energieverbrauch.'),
                                textInput('energyInputTimestamp',
                                          'Zeit:',
                                          value = as.character(Sys.time())),
                                selectInput('energyInputSelect', 
                                            label = 'Typ',
                                            choices = list('leer'),
                                            selected = 'leer'),
                                numericInput('energyValue',
                                             label = 'Wert',
                                             value = 0),
                                br(),
                                actionButton('saveEnergyInput', 'Speichern',
                                             icon('save')),
                                br(), br(), uiOutput('energyInputStatus')
                         )
                 )
        )
}