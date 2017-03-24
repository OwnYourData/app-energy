# application specific logic
# last update: 2017-02-13

source('srvDateselect.R', local=TRUE)
source('srvEmail.R', local=TRUE)
source('srvScheduler.R', local=TRUE)

source('appLogicEnergy.R', local=TRUE)

# any record manipulations before storing a record
appData <- function(record){
        record
}

getRepoStruct <- function(repo){
        if((repo == 'Typen') |
           (repo == 'Verlauf'))
        {
                appStruct[[repo]]
        } else {
                list(
                        fields = c('timestamp', 'value'),
                        fieldKey = 'timestamp',
                        fieldTypes = c('timestamp', 'number'),
                        fieldInits = c('empty', 'empty'),
                        fieldTitles = c('Zeit', 'Wert'),
                        fieldWidths = c(150, 100)
                )
        }
}

repoData <- function(repo){
        data <- data.frame()
        app <- currApp()
        if(length(app) > 0){
                url <- itemsUrl(app[['url']],
                                repo)
                data <- readItems(app, url)
        }
        data
}

# anything that should run only once during startup
appStart <- function(){
        if(is.null(input$energyList)){
                energyList()
                allItems <- readEnergyItems()
                updateSelectInput(session, 'energyList',
                                  choices = rownames(allItems))
                updateSelectInput(session, 'energyInputSelect',
                                  choices = rownames(allItems))
        }
}

dateRangeSelect <- function(data){
        if(nrow(data) > 0){
                mymin <- as.Date(input$dateRange[1])
                mymax <- as.Date(input$dateRange[2])
                daterange <- seq(mymin, mymax, 'days')
                data[as.Date(as.POSIXct(data$timestamp, 
                                        origin='1970-01-01')) %in% daterange, ]
        } else {
                data.frame()
        }
}

output$energyChart <- renderPlotly({
        pdf(NULL)
        outputPlot <- plotly_empty()
        repoName <- input$energySelect
        repo <- appRepos[[repoName]]
        data <- repoData(repo)
        if(nrow(data) > 0){
                data <- dateRangeSelect(data)
                if(nrow(data) > 0){
                        outputPlot <- plot_ly() %>%
                                add_lines(x = as.POSIXct(data$timestamp, 
                                                         origin='1970-01-01'),
                                          y = data$value,
                                          line = list(
                                                  color = 'blue',
                                                  width = 2,
                                                  shape = 'spline'),
                                          name = repoName) %>%
                                add_markers(x = as.POSIXct(data$timestamp,
                                                           origin='1970-01-01'),
                                            y = data$value,
                                            marker = list(
                                                    color='blue',
                                                    size = 7),
                                            name = '', 
                                            showlegend = FALSE)
                        
                }
        }
        dev.off()
        outputPlot
})

observeEvent(input$saveEnergyInput, {
        inputMsg = ''
        inputTimestampTry = try(as.POSIXct(input$energyInputTimestamp))
        if(is.POSIXct(inputTimestampTry)){
                app <- currApp()
                repoName <- input$energyInputSelect
                repo <- appRepos[[repoName]]
                url <- itemsUrl(app[['url']], repo)
                data <- list(timestamp = as.numeric(inputTimestampTry),
                             value = input$energyValue,
                             '_oydRepoName' = repoName)
                writeItem(app, url, data)
                inputMsg = 'ein neuer Eintrag wurde gespeichert'
        } else {
                inputMsg = 'Fehler: ungültiges Datum/Zeit Format, die Eingabe wurde nicht gespeichert'
        }
        output$energyInputStatus <- renderUI(inputMsg)
        
})