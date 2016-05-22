tabEnergySourceUI <- function(){
        fluidRow(
                column(1),
                column(10,
                       tabsetPanel(
                               type="tabs",
                               tabPanel("Email-Benachrichtigungen",
                                        fluidRow(
                                                column(2,
                                                       img(src='email.png',width='100px')),
                                                column(9,
                                                       helpText('Wenn du hier deine Emailadresse eingeben, erhältst du zu Monatsanfang eine Email mit der Abfrage nach den Werten auf den Zählergeräten für Wasser, Strom und Gas.'),
                                                       textInput('email', 'Emailadresse:'),
                                                       htmlOutput('email_status'),
                                                       checkboxInput('showEmailsetup', 'Emailsetup konfigurieren', FALSE),
                                                       conditionalPanel(condition = 'input.showEmailsetup',
                                                                        wellPanel(
                                                                                h3('Email Konfiguration'),
                                                                                htmlOutput('mail_config'),
                                                                                textInput('mailer_address', 'Mail Server:'),
                                                                                numericInput('mailer_port', 'Port:', 0),
                                                                                textInput('mailer_user', 'Benutzer:'),
                                                                                passwordInput('mailer_password', 'Passwort')
                                                                        )
                                                       )
                                                )
                                        )
                                )
                       )
                )
        )
}