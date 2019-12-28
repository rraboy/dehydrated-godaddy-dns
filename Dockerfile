FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y

RUN ln -fs /usr/share/zoneinfo/America/Toronto /etc/localtime
RUN apt-get install -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y software-properties-common curl vim git python3 python3-pip

RUN add-apt-repository ppa:certbot/certbot && \
	apt-get update && \
	apt-get install -y python-certbot-apache 

ENV ROOTDIR=/opt/letsencrypt
RUN mkdir -p $ROOTDIR && \
	cd $ROOTDIR && \
	git clone https://github.com/lukas2511/dehydrated && \
	git clone https://github.com/josteink/le-godaddy-dns && \
	cd $ROOTDIR/le-godaddy-dns && \
	python3 -m pip install -r requirements.txt

