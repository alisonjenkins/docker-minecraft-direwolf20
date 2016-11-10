FROM monsantoco/min-jessie
MAINTAINER Alan Jenkins <alan.james.jenkins@gmail.com>

RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install openjdk-8-jre-headless -y
RUN apt-get install python2.7 -y
ADD get_pack.py /usr/bin/get_pack
RUN mkdir -p /srv/minecraft && cd /srv/minecraft/ && /usr/bin/get_pack direwolf20 && mkdir /srv/minecraft/world && echo 'eula=true' > /srv/minecraft/eula.txt && rm /srv/minecraft/minecraft.zip
RUN rm /usr/bin/get_pack
RUN apt-get remove --purge python2.7 -y
VOLUME /srv/minecraft/world
VOLUME /backups
RUN apt-get install -y curl tmux
RUN cd /srv/minecraft/ && sh ./FTBInstall.sh
ADD mcrcon /usr/bin/mcrcon
ADD start_mc.sh /usr/bin/start_mc
RUN chmod +x /usr/bin/start_mc
RUN apt-get autoremove -y && \
        # AUTO_ADDED_PACKAGES=`apt-mark showauto` && \
        # apt-get remove --purge -y $AUTO_ADDED_PACKAGES && \
        apt-get clean
CMD /usr/bin/start_mc
