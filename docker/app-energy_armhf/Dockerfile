FROM oydeu/oyd-shiny_armhf:latest
MAINTAINER "Christoph Fabianek" christoph@ownyourdata.eu

RUN cd /srv/shiny-server \
        && rm -rf * \
        && git clone https://github.com/OwnYourData/app-energy.git \
        && mv app-energy/* . \
        && rm -r app-energy \
        && R -e "source('init.r')"

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]