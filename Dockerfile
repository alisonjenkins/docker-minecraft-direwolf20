FROM monsantoco/min-jessie
MAINTAINER Alan Jenkins <alan.james.jenkins@gmail.com>

RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install openjdk-8-jre-headless -y
RUN apt-get install python2.7 -y
ADD get_pack.py /usr/bin/get_pack
RUN mkdir -p /srv/minecraft
RUN cd /srv/minecraft/ && /usr/bin/get_pack direwolf20
RUN mkdir /srv/minecraft/world && echo 'eula=true' > /srv/minecraft/eula.txt
RUN rm /srv/minecraft/minecraft.zip
RUN rm /usr/bin/get_pack
RUN apt-get remove --purge python2.7 -y
VOLUME /srv/minecraft/world
VOLUME /backups
RUN apt-get install -y curl tmux less
RUN cd /srv/minecraft/ && sh ./FTBInstall.sh
ADD mcrcon /usr/bin/mcrcon
ADD start_mc.sh /usr/bin/start_mc
RUN chmod +x /usr/bin/start_mc
RUN apt-get autoremove -y && \
        # AUTO_ADDED_PACKAGES=`apt-mark showauto` && \
        # apt-get remove --purge -y $AUTO_ADDED_PACKAGES && \
        apt-get clean
RUN groupadd -g 995 minecraft
RUN useradd -d /srv/minecraft --system --uid 996 --gid 995 minecraft
ADD MobiusCore-1.2.5_1.7.10.jar /srv/minecraft/mods/
ADD Opis-1.2.5_1.7.10.jar /srv/minecraft/mods/
RUN chown -R minecraft:minecraft /srv/minecraft
USER minecraft
CMD cd /srv/minecraft && /usr/bin/start_mc
