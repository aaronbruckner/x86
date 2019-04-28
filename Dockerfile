FROM i386/ubuntu

RUN apt-get update

RUN apt-get -y install gcc
RUN apt-get -y install nasm
RUN apt-get -y install vim
RUN apt-get -y install ddd

CMD bash
