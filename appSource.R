# layout for section "Source"
# last update: 2016-10-06

source('appSourceEnergy.R')
source('appSourceData.R')

appSource <- function(){
        fluidRow(
                column(12,
                       tabsetPanel(
                               type='tabs',
                               appSourceEnergy(),
                               appSourceData()
                       )
                )
        )
}
