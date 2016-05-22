tabEnergyStoreUI <- function(){
        fluidRow(
                column(1),
                column(10,
                       bsAlert('topAlert'),
                       bsAlert('recordAlert'),
                       h3('Datenblatt'),
                       helpText('Änderungen an den Daten werden sofort übernommen'),
                       rHandsontableOutput("dataSheet"),
                       br(),
                       downloadButton('exportCSV', 'CSV Export'),
                       checkboxInput('showPiaSetup', 'PIA-Zugriff konfigurieren', FALSE),
                       conditionalPanel(
                                condition = 'input.showPiaSetup',
                                wellPanel(
                                        h3('Authentifizierung'),
                                        textInput('energy_url', 'Adresse:', getPiaConnection('energy')[['url']]),
                                        textInput('energy_app_key', 'ID (Allergien):', getPiaConnection('energy')[['app_key']]),
                                        textInput('energy_app_secret', 'Secret (Allergien):', getPiaConnection('energy')[['app_secret']]),
                                        checkboxInput('localEnergySave', label = 'Zugriffsinformationen lokal speichern', value = FALSE),
                                        hr(),
                                        htmlOutput('energy_token'),
                                        htmlOutput('energy_records')
                                )
                       )
                )
        )
}
