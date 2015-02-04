FROM rhel7

# -------------------
# RHSCL requirements:
# (from https://github.com/sclorg/rhscl-dockerfiles/blob/master/rhel7.httpd24-php55/Dockerfile)

RUN yum update -y && yum clean all
RUN yum install yum-utils -y && yum clean all
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
RUN yum-config-manager --enable rhel-7-server-optional-rpms

#TODO: Use httpd24 and php55 SCLs instead once their dependencies are fixed:
#      https://github.com/sclorg/rhscl-dockerfiles/issues/1
#RUN yum install -y --setopt=tsflags=nodocs httpd24 php55 php55-php && yum clean all
#ADD ./enablehttpd24.sh /etc/profile.d/
RUN yum install -y --setopt=tsflags=nodocs httpd php && yum clean all

# -----------------
# STI requirements:

RUN yum install -y wget tar gettext tar which gcc-c++ automake autoconf curl-devel \
    openssl-devel zlib-devel libxslt-devel libxml2-devel \
    mysql-libs mysql-devel postgresql-devel sqlite-devel && \
    yum clean all

# -------------------
# STI specific files:

# ADD ./php         /opt/php/
RUN mkdir -p /opt/php/bin/
ADD ./.sti/bin/usage /opt/php/bin/

# -----------------------------------
# STI specific environment variables:

#TODO: minor version?
ENV PHP_VERSION 5.4.16
ENV STI_SCRIPTS_URL https://raw.githubusercontent.com/VojtechVitek/php/master/.sti/bin
ENV STI_LOCATION /tmp

ENV APP_ROOT .
ENV HOME /opt/php
ENV PATH $HOME/bin:$PATH

WORKDIR /opt/php/src

#TODO: fix the permission error
#USER apache

EXPOSE 80

#TODO: Add HTTPS support
#EXPOSE 443

CMD ["/opt/php/bin/usage"]