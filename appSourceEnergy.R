# configure types of energy
# last update: 2017-03-23

appSourceEnergy <- function(){
        tabPanel('Energietypen', br(),
                 helpText('Konfiguriere hier die Energietypen.'), 
                 fluidRow(
                         column(4,
                                selectInput('energyList',
                                            'Typen:',
                                            energyUiList,
                                            multiple=TRUE, 
                                            selectize=FALSE,
                                            size=12,
                                            selected = ''),
                                actionButton('delEnergyList', 'Entfernen', 
                                             icon('trash'))),
                         column(8,
                                textInput('energyItemName',
                                          'Name:',
                                          value = ''),
                                textInput('energyItemEmail', 
                                            'Erassung per Email'),
                                textInput('energyItemInterval', 
                                          'Intervall'),
                                textInput('energyItemRepo',
                                          'Repo:',
                                          value = ''),
                                br(),
                                actionButton('addEnergyItem', 
                                             'Hinzufügen', icon('plus')),
                                actionButton('updateEnergyItem', 
                                             'Aktualisieren', icon('edit'))
                         )
                 )
        )
}