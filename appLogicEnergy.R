# configure energy types
# last update: 2017-03-24

# get energy types
readEnergyItems <- function(){
        app <- currApp()
        energyItems <- data.frame()
        if(length(app) > 0){
                url <- itemsUrl(app[['url']], app[['app_key']])
                energyItems <- readItems(app, url)
                if(nrow(energyItems) > 0){
                        rownames(energyItems) <- energyItems$name
                        energyItems <- energyItems[, c('email',
                                                       'interval',
                                                       'repo')]
                }
        }
        energyItems
}

energyList <- function(){
        energyTypes <- readEnergyItems()
        allTypes <- vector()
        sel <- ''
        if (nrow(energyTypes) > 0){
                allTypes <- rownames(energyTypes)
                sel <- rownames(energyTypes)[1]
        } else {
                allTypes <- c('nicht vorhanden')
                sel <- 'nicht vorhanden'
        }
        
        updateSelectInput(
                session,
                'energySelect',
                choices = allTypes,
                selected = sel)

        appRepos <<- append(appReposDefault,
                            setNames(as.character(energyTypes$repo),
                                     as.list(rownames(energyTypes))))
        updateSelectInput(
                session,
                'repoSelect',
                choices = names(appRepos),
                selected = 'Typen')
}

# show attributes on selecting an item in the energy list
observeEvent(input$energyList, {
        selItem <- input$energyList
        if(length(selItem)>1){
                selItem <- selItem[1]
                updateSelectInput(session, 'energyList', selected = selItem)
        }
        allItems <- readEnergyItems()
        selItemName <- selItem
        selItemEmail <- allItems[rownames(allItems) == selItem, 'email']
        selItemInterval <- allItems[rownames(allItems) == selItem, 'interval']
        selItemRepo <- allItems[rownames(allItems) == selItem, 'repo']
        updateTextInput(session, 'energyItemName',
                        value = selItemName)
        updateTextInput(session, 'energyItemEmail',
                        value = trim(as.character(selItemEmail)))
        updateTextInput(session, 'energyItemInterval',
                        value = trim(as.character(selItemInterval)))
        updateTextInput(session, 'energyItemRepo',
                        value = trim(as.character(selItemRepo)))
})

observeEvent(input$addEnergyItem, {
        errMsg   <- ''
        itemName <- input$energyItemName
        itemEmail <- input$energyItemEmail
        itemInterval <- input$energyItemInterval
        itemRepo <- input$energyItemRepo
        
        allItems <- readEnergyItems()
        if(itemName %in% rownames(allItems)){
                errMsg <- 'Name bereits vergeben'
        }
        if(errMsg == ''){
                app <- currApp()
                url <- itemsUrl(app[['url']], app[['app_key']])
                data <- list(name      = itemName,
                             email     = itemEmail,
                             interval  = itemInterval,
                             repo      = itemRepo) 
                data$`_oydRepoName` <- 'Typen'
                writeItem(app, url, data)
                
                # write email
                errMsg <- writeEnergyMail('',
                                          itemName, 
                                          itemEmail, 
                                          itemInterval, 
                                          itemRepo)
                
                initNames <- rownames(allItems)
                updateSelectInput(session, 'energyList',
                                  choices = c(initNames, itemName),
                                  selected = NA)
                updateTextInput(session, 'energyItemName',
                                value = '')
                updateTextInput(session, 'energyItemEmail',
                                value = '')
                updateTextInput(session, 'energyItemInterval',
                                value = '')
                updateTextInput(session, 'energyItemRepo',
                                value = '')
        }
        closeAlert(session, 'myEnergyItemStatus')
        if(errMsg != ''){
                createAlert(session, 'taskInfo', 
                            'myEnergyItemStatus',
                            title = 'Achtung',
                            content = errMsg,
                            style = 'warning',
                            append = 'false')
        }
})

observeEvent(input$updateEnergyItem, {
        errMsg   <- ''
        selItem <- input$energyList
        itemName <- input$energyItemName
        itemEmail <- input$energyItemEmail
        itemInterval <- input$energyItemInterval
        itemRepo <- input$energyItemRepo
        if(is.null(selItem)){
                errMsg <- 'Kein Typ ausgewählt.'
        }
        if(errMsg == ''){
                allItems <- readEnergyItems()
                app <- currApp()
                url <- itemsUrl(app[['url']], app[['app_key']])
                data <- list(name      = itemName,
                             email     = itemEmail,
                             interval  = itemInterval,
                             repo      = itemRepo)
                energyItems <- readItems(app, url)
                id <- energyItems[energyItems$name == selItem, 'id']
                updateItem(app, url, data, id)
                
                # write email
                errMsg <- writeEnergyMail(selItem,
                                          itemName, 
                                          itemEmail, 
                                          itemInterval, 
                                          itemRepo)
                
                newRowNames <- rownames(allItems)
                newRowNames[newRowNames == selItem] <- itemName
                updateSelectInput(session, 'energyList',
                                  choices = newRowNames,
                                  selected = NA)
                updateTextInput(session, 'energyItemName',
                                value = '')
                updateTextInput(session, 'energyItemEmail',
                                value = '')
                updateTextInput(session, 'energyItemInterval',
                                value = '')
                updateTextInput(session, 'energyItemRepo',
                                value = '')
        }
        closeAlert(session, 'myEnergyItemStatus')
        if(errMsg != ''){
                createAlert(session, 'taskInfo', 
                            'myEnergyItemStatus',
                            title = 'Achtung',
                            content = errMsg,
                            style = 'warning',
                            append = 'false')
        }
})

observeEvent(input$delEnergyList, {
        errMsg   <- ''
        selItem <- input$energyList
        if(is.null(selItem)){
                errMsg <- 'Kein Typ ausgewählt.'
        }
        if(errMsg == ''){
                # Scheduler Eintrag löschen
                deleteEnergyMail(selItem)
                
                # eintrag in Liste löschen
                allItems <- readEnergyItems()
                newRowNames <- rownames(allItems)
                app <- currApp()
                url <- itemsUrl(app[['url']], app[['app_key']])
                energyItems <- readItems(app, url)
                id <- energyItems[energyItems$name == selItem, 'id']
                deleteItem(app, url, id)
                newRowNames <- newRowNames[newRowNames != selItem]
                allItems <- allItems[rownames(allItems) != selItem, ]
                updateSelectInput(session, 'energyList',
                                  choices = newRowNames,
                                  selected = NA)
                updateTextInput(session, 'energyItemName',
                                value = '')
                updateTextInput(session, 'energyItemEmail',
                                value = '')
                updateTextInput(session, 'energyItemInterval',
                                value = '')
                updateTextInput(session, 'energyItemRepo',
                                value = '')
        }
        closeAlert(session, 'myEnergyItemStatus')
        if(errMsg != ''){
                createAlert(session, 'taskInfo', 
                            'myEnergyItemStatus',
                            title = 'Achtung',
                            content = errMsg,
                            style = 'warning',
                            append = 'false')
        }
})

writeEnergyMail <- function(selItem, itemName, itemEmail, itemInterval, itemRepo){
        errMsg <- ''
        if(validEmail(itemEmail)){
                # lösche - falls vorhanden - den Schedulereintrag
                deleteEnergyMail(selItem)
                
                # erstelle neuen Eintrag
                energy_fields <- list(
                        timestamp='Time.now',
                        value='line_1(Double)')
                energy_structure <- list(
                        repo=itemRepo,
                        repoName=itemName,
                        fields=energy_fields)
                response_structure <- list(energy_structure)
                energyEmailText <- paste0('Beantworte dieses Mail und gib dabei den aktuellen ',
                                          'Energieverbrauch für ', itemName, 'an.')
                writeSchedulerEmail(
                        app,
                        appTitle,
                        itemEmail,
                        paste0('Datenerfassung für Energieverbrauch - ',
                               itemName),
                        energyEmailText,
                        itemInterval,
                        response_structure)
        } else {
                if(nchar(itemEmail) > 0){
                        errMsg <- 'Ungültige Emailadresse! Es wurde kein Emailversand für diesen Energietyp eingerichtet.'
                }
        }
        errMsg
}

deleteEnergyMail <- function(selItem){
        energySchedulerItems <- readSchedulerItemsFunction()
        app <- currApp()
        url <- itemsUrl(app[['url']], schedulerKey)
        if(nrow(energySchedulerItems) > 0){
                apply(energySchedulerItems, 1, function(x) {
                        if(x$parameters$subject == 
                           paste0('Datenerfassung für Energieverbrauch - ',
                                  selItem))
                        {
                                deleteItem(app, 
                                           url,
                                           as.character(x$id))
                        }
                })
                
        }
}