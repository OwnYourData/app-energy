# global constants available to the app
# last update:2016-01-17

# constants required for every app
appName <- 'energy'
appTitle <- 'Energieverbrauch'
app_id <- 'eu.ownyourdata.energy'
helpUrl <- 'https://www.ownyourdata.eu/apps/energieverbrauch/'

# definition of data structure
currRepoSelect <- ''
appRepos <- list()
appReposDefault <- list(Typen = 'eu.ownyourdata.energy',
                        Verlauf = 'eu.ownyourdata.energy.log')
appStruct <- list(
        Typen = list(
                fields      = c('name', 'email', 'interval', 'repo'),
                fieldKey    = 'name',
                fieldTypes  = c('string', 'string', 'string', 'string'),
                fieldInits  = c('empty', 'empty', 'empty', 'empty'),
                fieldTitles = c('Name', 'Email', 'Intervall', 'Liste'),
                fieldWidths = c(200, 250, 150, 150)),
        Verlauf = list(
                fields      = c('date', 'description'),
                fieldKey    = 'date',
                fieldTypes  = c('date', 'string'),
                fieldInits  = c('empty', 'empty'),
                fieldTitles = c('Datum', 'Text'),
                fieldWidths = c(150, 450)))

# Version information
currVersion <- "0.3.0"
verHistory <- data.frame(rbind(
        c(version = "0.3.0",
          text    = "erstes Release")
))

# app specific constants
energyUiList <- vector()
