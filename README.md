# Energieverbrauch
Der [OwnYourData](https://www.ownyourdata.eu) Energieverbrauch erlaubt ein periodisches Monitoring des eigenen Resourcenkonsums (Wasser, Strom, Gas).

## Installation

Die App kann gratis über den offiziellen [OwnYourData SAM](http://oyd-sam.herokuapp.com) (Store for Algorithms) installiert werden. Klicke dazu in der PIA App-Liste "Plugin installieren" und wähle "Energieverbrauch" (ID: eu.ownyourdata.energy) aus.

Die Energieverbrauch-App benötigt das Shiny-Host-Service (ebenfalls verfügbar am OwnYourData SAM, ID: eu.ownyourdata.shinyhost) und [Docker](https://www.docker.com/) installiert.


## Verwendung

Die App umfasst folgende Funktionen:

* Energieverbrauch für folgende 3 Resourcen
    * Wasser (in m^3)
    * Strom (in kWh)
    * Gas (in m^3)
* Visualisierung der vorhandenen Daten zur Identifikation von Zusammenhängen
* Einschränkung der Darstellung auf ein bestimmtes Zeitfenster
* optional: automatisierte monatliche Emails zur Abfrage der 3 beschriebenen Resourcen


## Für Entwickler  

Diese App wurde in [R](https://cran.r-project.org/) entwickelt und verwendet [Shiny](http://shiny.rstudio.com/). Zur Ausführung wird entweder das OwnYourData Shiny Service benötigt (siehe oben: Installation) oder es existiert ein bereits [installierter Shiny Server](https://github.com/rstudio/shiny-server/wiki/Building-Shiny-Server-from-Source). Wird ein eigener Shiny Server betrieben, kann in der PIA App-Liste mit "Register a new Plugin" das Manifest base64-encodiert hinzugefügt werden (angegeben am Beginn der Datei `server.R`) und in der App unter Konfiguration müssen die Parameter URL, App-Key und App-Secret selbst gesetzt werden.  
Zum Ausprobieren kann die App auf [Heroku](https://www.heroku.com/) deployed werden:  
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)


## Verbessere die Beziehungsstatus-App

1. Fork it!
2. erstelle einen Feature Branch: `git checkout -b my-new-feature`
3. Commit deine Änderungen: `git commit -am 'Add some feature'`
4. Push in den Branch: `git push origin my-new-feature`
5. Sende einen Pull Request

## Lizenz

MIT Lizenz 2016 - Own Your Data
