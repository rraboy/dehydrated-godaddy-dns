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

RUN useradd -M -d /opt/letsencrypt -U -s /bin/bash -u 1000 letsencrypt
VOLUME /opt/letsencrypt/dehydrated/accounts
VOLUME /opt/letsencrypt/dehydrated/chains
VOLUME /opt/letsencrypt/dehydrated/certs
RUN chown -R letsencrypt:letsencrypt /opt/letsencrypt
USER letsencrypt
WORKDIR /opt/letsencrypt
ENTRYPOINT [ "/opt/letsencrypt/dehydrated/dehydrated", "-c", "-4", "-t", "dns-01", "-k", "/opt/letsencrypt/le-godaddy-dns/godaddy.py" ]
