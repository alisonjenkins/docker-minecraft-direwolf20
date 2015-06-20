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
CMD cd /srv/minecraft/ && tmux new-session -d -n minecraft:0 -s minecraft && tmux -q send -t minecraft:minecraft "java -server -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:NewRatio=1 -Xmx8096M -Xms8096M -jar FTBServer-1.7.10-1408.jar nogui" C-m && tmux attach
ADD mcrcon /usr/bin/mcrcon
RUN apt-get autoremove -y && \
        # AUTO_ADDED_PACKAGES=`apt-mark showauto` && \
        # apt-get remove --purge -y $AUTO_ADDED_PACKAGES && \
        apt-get clean
