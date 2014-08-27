#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM debian:stable
MAINTAINER Tim Sutton<tim@kartoza.com>
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------


RUN apt-get install -y python-imaging python-yaml libproj0 libgeos-dev python-lxml libgdal-dev build-essential python-dev libjpeg-dev zlib1g-dev libfreetype6-dev python-virtualenv
RUN virtualenv /venv; /venv/bin/pip install Shapely Pillow MapProxy

EXPOSE 80

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

USER www-data
# Now launch mappproxy in the foreground
# The script will create a simple config in /mapproxy
# if one does not exist. Typically you should mount 
# /mapproxy as a volume
CMD /start.sh