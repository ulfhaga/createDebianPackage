FROM ubuntu:18.04

RUN apt-get update 
RUN apt-get install -y firefox
RUN apt-get install -y apache2
RUN apt-get install -y gedit
RUN apt-get install -y curl
RUN apt-get install -y xterm
RUN apt-get install -y vim

# Replace 1000 with your user / group id
#RUN export uid=1000 gid=1000 && \
#    mkdir -p /home/developer && \
#    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
#    echo "developer:x:${uid}:" >> /etc/group && \
#    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
#    chmod 0440 /etc/sudoers.d/developer && \
#    chown ${uid}:${gid} -R /home/developer

#USER developer
#ENV HOME /home/developer

EXPOSE 80
EXPOSE 63080

CMD /bin/bash
