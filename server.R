# OYD: Energieverbrauch - last update:2016-05-20
# Manifest for energy app ================================
'
encode with https://www.base64encode.org/
{
        "name":"Energy App",
        "identifier":"eu.ownyourdata.energy",
        "type":"external",
        "description":"track your energy consumption (gas, current, water)",
        "permissions":["eu.ownyourdata.energy.gas:read",
                       "eu.ownyourdata.energy.gas:write",
                       "eu.ownyourdata.energy.gas:update",
                       "eu.ownyourdata.energy.gas:delete",
                       "eu.ownyourdata.energy.current:read",
                       "eu.ownyourdata.energy.current:write",
                       "eu.ownyourdata.energy.current:update",
                       "eu.ownyourdata.energy.current:delete",
                       "eu.ownyourdata.energy.water:read",
                       "eu.ownyourdata.energy.water:write",
                       "eu.ownyourdata.energy.water:update",
                       "eu.ownyourdata.energy.water:delete",
                       "eu.ownyourdata.scheduler:read",
                       "eu.ownyourdata.scheduler:write",
                       "eu.ownyourdata.scheduler:update",
                       "eu.ownyourdata.scheduler:delete",
                       "eu.ownyourdata.scheduler.email_config:read",
                       "eu.ownyourdata.scheduler.email_config:write",
                       "eu.ownyourdata.scheduler.email_config:update",
                       "eu.ownyourdata.scheduler.email_config:delete"]
}
ew0KICAgICAgICAibmFtZSI6IkVuZXJneSBBcHAiLA0KICAgICAgICAiaWRlbnRpZmllciI6ImV1Lm93bnlvdXJkYXRhLmVuZXJneSIsDQogICAgICAgICJ0eXBlIjoiZXh0ZXJuYWwiLA0KICAgICAgICAiZGVzY3JpcHRpb24iOiJ0cmFjayB5b3VyIGVuZXJneSBjb25zdW1wdGlvbiAoZ2FzLCBjdXJyZW50LCB3YXRlcikiLA0KICAgICAgICAicGVybWlzc2lvbnMiOlsiZXUub3dueW91cmRhdGEuZW5lcmd5LmdhczpyZWFkIiwNCiAgICAgICAgICAgICAgICAgICAgICAgImV1Lm93bnlvdXJkYXRhLmVuZXJneS5nYXM6d3JpdGUiLA0KICAgICAgICAgICAgICAgICAgICAgICAiZXUub3dueW91cmRhdGEuZW5lcmd5Lmdhczp1cGRhdGUiLA0KICAgICAgICAgICAgICAgICAgICAgICAiZXUub3dueW91cmRhdGEuZW5lcmd5LmdhczpkZWxldGUiLA0KICAgICAgICAgICAgICAgICAgICAgICAiZXUub3dueW91cmRhdGEuZW5lcmd5LmN1cnJlbnQ6cmVhZCIsDQogICAgICAgICAgICAgICAgICAgICAgICJldS5vd255b3VyZGF0YS5lbmVyZ3kuY3VycmVudDp3cml0ZSIsDQogICAgICAgICAgICAgICAgICAgICAgICJldS5vd255b3VyZGF0YS5lbmVyZ3kuY3VycmVudDp1cGRhdGUiLA0KICAgICAgICAgICAgICAgICAgICAgICAiZXUub3dueW91cmRhdGEuZW5lcmd5LmN1cnJlbnQ6ZGVsZXRlIiwNCiAgICAgICAgICAgICAgICAgICAgICAgImV1Lm93bnlvdXJkYXRhLmVuZXJneS53YXRlcjpyZWFkIiwNCiAgICAgICAgICAgICAgICAgICAgICAgImV1Lm93bnlvdXJkYXRhLmVuZXJneS53YXRlcjp3cml0ZSIsDQogICAgICAgICAgICAgICAgICAgICAgICJldS5vd255b3VyZGF0YS5lbmVyZ3kud2F0ZXI6dXBkYXRlIiwNCiAgICAgICAgICAgICAgICAgICAgICAgImV1Lm93bnlvdXJkYXRhLmVuZXJneS53YXRlcjpkZWxldGUiLA0KICAgICAgICAgICAgICAgICAgICAgICAiZXUub3dueW91cmRhdGEuc2NoZWR1bGVyOnJlYWQiLA0KICAgICAgICAgICAgICAgICAgICAgICAiZXUub3dueW91cmRhdGEuc2NoZWR1bGVyOndyaXRlIiwNCiAgICAgICAgICAgICAgICAgICAgICAgImV1Lm93bnlvdXJkYXRhLnNjaGVkdWxlcjp1cGRhdGUiLA0KICAgICAgICAgICAgICAgICAgICAgICAiZXUub3dueW91cmRhdGEuc2NoZWR1bGVyOmRlbGV0ZSIsDQogICAgICAgICAgICAgICAgICAgICAgICJldS5vd255b3VyZGF0YS5zY2hlZHVsZXIuZW1haWxfY29uZmlnOnJlYWQiLA0KICAgICAgICAgICAgICAgICAgICAgICAiZXUub3dueW91cmRhdGEuc2NoZWR1bGVyLmVtYWlsX2NvbmZpZzp3cml0ZSIsDQogICAgICAgICAgICAgICAgICAgICAgICJldS5vd255b3VyZGF0YS5zY2hlZHVsZXIuZW1haWxfY29uZmlnOnVwZGF0ZSIsDQogICAgICAgICAgICAgICAgICAgICAgICJldS5vd255b3VyZGF0YS5zY2hlZHVsZXIuZW1haWxfY29uZmlnOmRlbGV0ZSJdDQp9
'

# Setup and config ========================================
# install.packages(c('shiny', 'shinyBS', 'RCurl', 'jsonlite', 'dplyr'), repos='https://cran.rstudio.com/')
library(shiny)
library(RCurl)
library(jsonlite)
library(dplyr)
library(lubridate)
library(rhandsontable)
library(sqldf)

source("oyd_helpers.R")

first <- TRUE
repo_energy <- 'eu.ownyourdata.energy'
repo_gas <- paste0(repo_energy, '.gas')
repo_current <- paste0(repo_energy, '.current')
repo_water <- paste0(repo_energy, '.water')

# Shiny Server ============================================
shinyServer(function(input, output, session) {
        output$upgradeLink <- renderText({
                renderUpgrade(session)
        })
        
# Energy specific functions ==============================
        energyRepo <- reactive({
                url <- input$energy_url
                app_key <- input$energy_app_key
                app_secret <- input$energy_app_secret
                if(is.null(url) |
                   is.null(app_key) | 
                   is.null(app_secret)) {
                        vector()
                } else {
                        if((nchar(url) > 0) & 
                           (nchar(app_key) > 0) & 
                           (nchar(app_secret) > 0)) {
                                if(input$localEnergySave) {
                                        save(url, 
                                             app_key, 
                                             app_secret, 
                                             file='~/energyCredentials.RData')
                                } else {
                                        # if (file.exists('~/energyCredentials.RData'))
                                        #         file.remove('~/energyCredentials.RData')
                                }
                                getRepo(url, app_key, app_secret)
                        } else {
                                vector()
                        }
                }
        })

        energyData <- function(category){
                repo <- energyRepo()
                if(length(repo) > 0) {
                        url <- itemsUrl(repo[['url']], 
                                        paste0(repo[['app_key']], 
                                               '.', category))
                        piaData <- readItems(repo, url)
                        if(nrow(piaData)>0){
                                names(piaData)[names(piaData) == 'value'] <- 
                                        category
                        }
                } else {
                        piaData <- data.frame()
                }
                piaData
        }
        
        allEnergyData <- function(){
                # load individual data sets
                g_data <- energyData('gas')
                w_data <- energyData('water')
                c_data <- energyData('current')

                # merge data sets
                data <- combineData(g_data, w_data)
                data <- combineData(c_data, data)

                # create return Value
                if(nrow(data) > 0) {
                        data$dat <- as.POSIXct(data$date, 
                                               format='%Y-%m-%d')
                        if(nrow(g_data) == 0) {
                                data$gas <- NA
                        }
                        if(nrow(w_data) == 0) {
                                data$water <- NA
                        }
                        if(nrow(c_data) == 0) {
                                data$current <- NA
                        }
                        data[with(data, order(dat)),]
                } else {
                        data.frame()
                }
        }
        
        observe({
                switch(input$dateSelect,
                       '1'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date()-7),
                                                  end = as.Date(Sys.Date())) },
                       '2'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date() - months(1)),
                                                  end = as.Date(Sys.Date())) },
                       '3'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date() - months(2)),
                                                  end = as.Date(Sys.Date())) },
                       '4'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date() - months(6)),
                                                  end = as.Date(Sys.Date())) },
                       '5'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(paste(year(Sys.Date()),'1','1',sep='-')),
                                                  end = as.Date(Sys.Date())) },
                       '6'={ updateDateRangeInput(session, 'dateRange',
                                                  start = as.Date(Sys.Date() - months(12)),
                                                  end = as.Date(Sys.Date())) },
                       {})
        })
        
        plotCategory <- function(data, category){
                dataMin <- min(data$dat, na.rm=TRUE)
                dataMax <- max(data$dat, na.rm=TRUE)
                curMin <- as.Date(input$dateRange[1], '%d.%m.%Y')
                curMax <- as.Date(input$dateRange[2], '%d.%m.%Y')
                daterange <- seq(curMin, curMax, 'days')
                save(data, file='tmpData2.RData')
                data <- data[!is.na(data[category]),]
                data <- data[as.Date(data$dat) %in% daterange, ]
                if(nrow(data) > 0) {
                        title <- ''
                        title <- switch(category, 
                                        gas={ 'Gas' },
                                        water={ 'Wasser' },
                                        current={ 'Strom' },
                                        { '' }
                        )
                        closeAlert(session, 'noDataAlert')
                        data <- data[with(data, order(date)),]
                        plot(x=data$dat, y=data[[category]], main=title,
                             type='l', xlab='Datum', ylab='Wert')
                } else {
                        createAlert(session, 'noData', 'noDataAlert', style='warning', 
                                    title='Keine Daten im ausgewählten Zeitfenster',
                                    content=paste0('Passe oben die Zeitauswahl an - es stehen Daten zwischen ',
                                                   format(as.POSIXct(dataMin, '%Y-%m-%d'), '%d.%m.%Y'),
                                                   ' und ',
                                                   format(as.POSIXct(dataMax, '%Y-%m-%d'), '%d.%m.%Y'),
                                                   ' zur Verfügung.'))
                }
        }

        plotData <- function(category){
                if(first) {
                        if(grepl('.herokuapp.com', session$clientData$url_hostname)) {
                                internetAlert(session, 'https://www.ownyourdata.eu/apps/')
                        }
                        first <<- FALSE                  
                }
                closeAlert(session, 'noDataAlert')
                data <- allEnergyData()
                if(nrow(data) > 0) {
                        plotCategory(data, category)
                } else {
                        createAlert(session, 'noData', 'noDataAlert', style='info', title='Keine Daten vorhanden',
                                    content='Erfasse Datensätze oder abonniere ein periodisches Email zur Datensammlung.', append=FALSE)
                }
        }

        saveCategory <- function(repo, category, date, value){
                if(!is.null(date)){
                        piaData <- energyData(category)
                        existData <- piaData[piaData$date == date, ]
                        data <- list(date=date, 
                                     value=value)
                        url <- itemsUrl(repo[['url']], 
                                        paste0(repo[['app_key']], '.', category))
                        if (nrow(existData) > 0) {
                                if(is.na(value) | is.null(value)){
                                        deleteRecord(repo, url, existData$id)
                                } else {
                                        updateRecord(repo, url, data, existData$id)
                                }
                        } else {
                                if(!is.na(value) & !is.null(value)){
                                        writeRecord(repo, url, data)
                                }
                        }
                }                
        }

        savedPia <- eventReactive(input$exportButton, {
                repo <- energyRepo()
                if(length(repo) > 0){
                        if(input$useGas) saveCategory(repo, 'gas', input$manGas)
                        if(input$useWater) saveCategory(repo, 'water', input$manWater)
                        if(input$useCurrent) saveCategory(repo, 'current', input$manCurrent)
                        output$plot <- renderPlot(plotData(allEnergyData()))
                        paste('<strong>zuletzt aktualisiert:</strong>',
                              format(Sys.time(), '%H:%M:%S'))
                } else {
                        '<strong>Fehler:</strong> keine Verbindung zu PIA'
                }
        })

# Energy specific output fields ==========================
        values = reactiveValues()
        setHot = function(x) values[["dataSheet"]] = x
        
        observe({
                if(!is.null(input$dataSheet))
                        values[["dataSheet"]] <- hot_to_r(input$dataSheet)
        })

        output$exportCSV <- downloadHandler(
                filename = 'energy.csv',
                content = function(file) {
                        write.csv(values[["dataSheet"]], file)
                }
        )
        
        observe({
                newRecords <- values[["dataSheet"]]
                if (!is.null(newRecords)) {
                        oldRecords <- allEnergyData()
                        if(nrow(oldRecords)>0) {
                                oldRecords <- oldRecords[,c('date', 'water', 'current', 'gas')]
                        } else {
                                oldRecords <- as.data.frame(matrix(NA, ncol=4, nrow=1))
                        }
                        colnames(oldRecords) <- c('Datum', 'Wasser', 'Strom', 'Gas')
                        oldRecords$Datum <- as.Date(oldRecords$Datum)
                        oldRecords$Wasser <- as.numeric(oldRecords$Wasser)
                        oldRecords$Strom <- as.numeric(oldRecords$Strom)
                        oldRecords$Gas <- as.numeric(oldRecords$Gas)
                        
                        # check new and updated records
                        repo <- energyRepo()
                        updatedRecords <- sqldf('SELECT * FROM newRecords EXCEPT SELECT * FROM oldRecords')
                        if(nrow(updatedRecords)>0){
                                for(i in 1:nrow(updatedRecords)){
                                        rec <- updatedRecords[i,]
                                        if(!is.na(rec[1])){
                                                if(!(is.na(rec$Datum) | (as.character(rec$Datum) == ''))) {
                                                        if(is.na(rec$Wasser)) {
                                                                saveCategory(repo, 'water', 
                                                                             rec$Datum,
                                                                             NA)
                                                        } else {
                                                                saveCategory(repo, 'water', 
                                                                             rec$Datum,
                                                                             rec$Wasser)
                                                        }
                                                        if(is.na(rec$Strom)) {
                                                                saveCategory(repo, 'current', 
                                                                             rec$Datum,
                                                                             NA)
                                                        } else {
                                                                saveCategory(repo, 'current', 
                                                                             rec$Datum,
                                                                             rec$Strom)
                                                        }
                                                        if(is.na(rec$Gas)) {
                                                                saveCategory(repo, 'gas', 
                                                                             rec$Datum,
                                                                             NA)
                                                        } else {
                                                                saveCategory(repo, 'gas', 
                                                                             rec$Datum,
                                                                             rec$Gas)
                                                        }
                                                }
                                        }
                                }
                        }
                        
                        # check for deleted records
                        deletedRecords <- sqldf('SELECT * FROM oldRecords EXCEPT SELECT * FROM newRecords')
                        if(nrow(deletedRecords) > 0) {
                                for(i in 1:nrow(deletedRecords)){
                                        rec <- deletedRecords[i,]
                                        saveCategory(repo, 'water', rec$Datum, NA)
                                        saveCategory(repo, 'current', rec$Datum, NA)
                                        saveCategory(repo, 'gas', rec$Datum, NA)
                                }
                        }
                }
        })

        output$dataSheet = renderRHandsontable({
                if (!is.null(input$dataSheet)) {
                        DF = hot_to_r(input$dataSheet)
                        DF <- DF[!is.na(DF$Datum),]
                        if(nrow(DF) == 0){
                                DF <- data.frame(
                                        Datum = as.Date(Sys.Date()),
                                        Wasser = as.numeric(0),
                                        Strom = as.numeric(0),
                                        Gas = as.numeric(0))
                        } else {
                                DF <- rbind(DF, c(NA, NA, NA, NA))       
                        }
                        colnames(DF) <- c('Datum', 'Wasser', 'Strom', 'Gas')
                } else {
                        DF <- allEnergyData()
                        if(nrow(DF)>0){
                                DF <- DF[,c('date', 'water', 'current', 'gas')]
                                DF <- DF[!is.na(DF$date),]
                                DF <- rbind(DF, c(NA, NA, NA, NA))
                        } else {
                                DF <- as.data.frame(matrix(NA, ncol=4, nrow=1))
                        }
                        colnames(DF) <- c('Datum', 'Wasser', 'Strom', 'Gas')
                        save(DF, file='tmpDF.RData')
                        DF$Datum <- as.Date(DF$Datum)
                        DF$Wasser <- as.numeric(DF$Wasser)
                        DF$Strom <- as.numeric(DF$Strom)
                        DF$Gas <- as.numeric(DF$Gas)
                }
                setHot(DF)
                if(nrow(DF)>20) {
                        rhandsontable(DF, useTypes=TRUE, height=400) %>%
                                hot_table(highlightCol=TRUE, highlightRow=TRUE,
                                          allowRowEdit=TRUE)
                } else {
                        rhandsontable(DF, useTypes=TRUE) %>%
                                hot_table(highlightCol=TRUE, highlightRow=TRUE,
                                          allowRowEdit=TRUE)
                }
        })
        
        output$plotGas <- renderPlot({
                input$dataSheet
                plotData('gas')
        })

        output$plotWater <- renderPlot({
                input$dataSheet
                plotData('water')
        })

        output$plotCurrent <- renderPlot({
                input$dataSheet
                plotData('current')
        })
        
        output$last_saved <- renderText({
                savedPia()
        })
        
        output$energy_token <- renderText({
                repo <- energyRepo()
                if (length(repo) == 0) {
                        '<strong>Token:</strong> nicht verfügbar'
                } else {
                        paste0('<strong>Token:</strong><br><small>', 
                               repo[['token']], '</small>')
                }
        })
        
        output$energy_records <- renderText({
                data <- allEnergyData()
                paste('<strong>Datensätze:</strong>',
                      nrow(data))
        })

# Email reminders =========================================        
        getLocalEmailConfig <- reactive({
                validEmailConfig <- FALSE
                server <- input$mailer_address
                port <- input$mailer_port
                user <- input$mailer_user
                pwd <- input$mailer_password
                if((nchar(server) > 0) & 
                   (nchar(port) > 0) & 
                   (nchar(user) > 0) & 
                   (nchar(pwd) > 0)) {
                        validEmailConfig <- TRUE
                }
                c('valid'=validEmailConfig,
                  'server'=server,
                  'port'=port,
                  'user'=user,
                  'pwd'=pwd)
        })
        
        emailConfigStatus <- function(repo){
                localMailConfig <- getLocalEmailConfig()
                piaMailConfig <- getPiaEmailConfig(repo)
                if (localMailConfig[['valid']]) {
                        # is there already a config in PIA?
                        if (length(piaMailConfig) > 0) {
                                # is it different?
                                if((localMailConfig[['server']] == piaMailConfig[['server']]) &
                                   (localMailConfig[['port']] == piaMailConfig[['port']]) &
                                   (localMailConfig[['user']] == piaMailConfig[['user']]) &
                                   (localMailConfig[['pwd']] == piaMailConfig[['pwd']])) {
                                        'config in sync'
                                } else {
                                        updateEmailConfig(repo, 
                                                          localMailConfig, 
                                                          piaMailConfig[['id']])
                                        'config updated'
                                }
                        } else {
                                writeEmailConfig(repo, localMailConfig)
                                'config saved'
                        }
                } else {
                        # is there already a config in PIA?
                        if (length(piaMailConfig) > 0) {
                                setEmailConfig(session, piaMailConfig)
                                'config loaded' # Mailkonfiguration von PIA gelesen
                        } else {
                                'not configured' # keine Mailkonfiguration vorhanden
                        }
                }
        }
        
        emailReminderStatus <- reactive({
                repo <- energyRepo()
                if(length(repo) > 0){
                        piaMailConfig <- getPiaEmailConfig(repo)
                        piaSchedulerEmail <- getPiaSchedulerEmail(repo)
                        piaEmail <- ''
                        piaEmailId <- NA
                        if (length(piaMailConfig) == 0) {
                                'no mail config'
                        } else {
                                if (length(piaSchedulerEmail) > 0) {
                                        piaEmail <- piaSchedulerEmail[['email']]
                                        piaEmailId <-  piaSchedulerEmail[['id']]
                                }
                                localEmail <- as.character(input$email)
                                if(validEmail(localEmail)) {
                                        if (localEmail == piaEmail) {
                                                'email in sync'
                                        } else {
                                                water_fields <- list(
                                                        date='Date.now',
                                                        value='line_1(Double)'
                                                )
                                                water_structure <- list(
                                                        repo=repo_water,
                                                        fields=water_fields
                                                )
                                                current_fields <- list(
                                                        date='Date.now',
                                                        value='line_2(Double)'
                                                )
                                                current_structure <- list(
                                                        repo=repo_current,
                                                        fields=current_fields
                                                )
                                                gas_fields <- list(
                                                        date='Date.now',
                                                        value='line_3(Double)'
                                                )
                                                gas_structure <- list(
                                                        repo=repo_gas,
                                                        fields=gas_fields
                                                )
                                                response_structure <- list(
                                                        water_structure,
                                                        current_structure,
                                                        gas_structure
                                                )
                                                content <- 'note current level of water, current, and gas consumption'
                                                timePattern <- '0 9 1 * *'
                                                if (piaEmail == '') {
                                                        writeSchedulerEmail(
                                                                repo,
                                                                localEmail,
                                                                content,
                                                                timePattern,
                                                                response_structure)
                                                        'email saved'
                                                } else {
                                                        updateSchedulerEmail(
                                                                repo,
                                                                localEmail,
                                                                content,
                                                                timePattern,
                                                                response_structure,
                                                                piaEmailId)
                                                        'email updated'
                                                }
                                        }
                                } else {
                                        if (nchar(localEmail) == 0) {
                                                if (piaEmail == '') {
                                                        'missing email'
                                                } else {
                                                        setSchedulerEmail(session, piaEmail)
                                                        'email loaded'
                                                }
                                        } else {
                                                'invalid email'
                                        }
                                }
                        }
                } else {
                        'no Pia'
                }
                
        })
        
        output$mail_config <- renderText({
                repo <- energyRepo()
                if(length(repo) > 0){
                        retVal <- emailConfigStatus(repo)
                        switch(retVal,
                               'config in sync' = 'Benachrichtigungen via Email sind eingerichtet',
                               'not configured' = 'Benachrichtigungen via Email sind noch nicht konfiguiert',
                               'config saved'   = 'Emailkonfiguration in PIA gespeichert',
                               'config updated' = 'Emailkonfiguration in PIA aktualisiert',
                               'config loaded'  = 'Emailkonfiguration aus PIA geladen')
                } else {
                        'keine Verbindung zu PIA'
                }
        })
        
        output$email_status <- renderText({
                retVal <- emailReminderStatus()
                paste('<strong>Status:</strong>',
                      switch(retVal,
                             'no Pia'         = 'keine Verbindung zu PIA',
                             'no mail config' = 'Emailkonfiguration noch nicht vorhanden',
                             'missing email'  = 'fehlende Emailadresse',
                             'invalid email'  = 'ungültige Emailadresse',
                             'email loaded'   = 'Emailadresse aus PIA geladen',
                             'email in sync'  = 'periodische Email-Benachrichtigungen werden versandt',
                             'email saved'    = 'Emailadresse in PIA gespeichert',
                             'email updated'  = 'Emailadresse in PIA aktualisiert'))
        })
        
})
