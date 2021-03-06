FROM jenkins/jenkins

MAINTAINER Enrique Ibarra <enrique@enriqueibarra.me>

# ENV JENKINS_HOME /var/jenkins_home
ENV DEBIAN_FRONTEND noninteractive

USER root

# Add source.list
RUN echo "deb-src http://httpredir.debian.org/debian stretch main" >> /etc/apt/sources.list
RUN echo "deb-src http://httpredir.debian.org/debian stretch-updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org stretch/updates main" >> /etc/apt/sources.list

# Basic tools
RUN apt-get update \
  && apt-get -qqy install sudo \
  && apt-get -qqy install ant vim nano ant-contrib mysql-client graphviz doxygen sqlite3 wget \
  && apt-get -qqy install \
    --ignore-missing \
    php7.0 \
    php7.0-dev \
    php7.0-cli \
    php-pear \
    php7.0-curl \
    php7.0-fpm \
    php7.0-intl \
    php7.0-mcrypt \
    php7.0-mbstring \
    php7.0-gd \
    php7.0-mysql \
    php7.0-pdo \
    php7.0-xdebug \
    autoconf automake curl build-essential \
    libxslt1-dev re2c libxml2 libxml2-dev  \
    bison libbz2-dev libreadline-dev \
    libfreetype6 libfreetype6-dev libpng16-16 libpng-dev libjpeg-dev libgd-dev libgd3 libxpm4 \
    libssl-dev openssl \
    gettext libgettextpo-dev libgettextpo0 \
    libicu-dev \
    libmhash2 libmhash-dev \
    libmcrypt4 libmcrypt-dev \
    libpcre3-dev libpcre++-dev \
  && apt-get -q clean -y \
  && apt-get -q autoclean -y \
  && apt-get -q autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && rm -rf /var/lib/apt/lists/*


# Install php tools
RUN  mkdir -p /usr/bin \
  && wget -q -O /usr/bin/phpunit https://phar.phpunit.de/phpunit-3.7.9.phar && chmod +x /usr/bin/phpunit \
  && wget -q -O /usr/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/bin/composer \
  && wget -q -O /usr/bin/phpmd http://static.phpmd.org/php/latest/phpmd.phar && chmod +x /usr/bin/phpmd \
  && wget -q -O /usr/bin/sami http://get.sensiolabs.org/sami.phar && chmod +x /usr/bin/sami \
  && wget -q -O /usr/bin/phpcov https://phar.phpunit.de/phpcov.phar && chmod +x /usr/bin/phpcov \
  && wget -q -O /usr/bin/phpcb https://github.com/mayflower/PHP_CodeBrowser/releases/download/1.1.1/phpcb-1.1.1.phar && chmod +x /usr/bin/phpcb \
  && wget -q -O /usr/bin/pdepend http://static.pdepend.org/php/latest/pdepend.phar && chmod +x /usr/bin/pdepend \
  && wget -q -O /usr/bin/phpcs https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar && chmod +x /usr/bin/phpcs \
  && wget -q -O /usr/bin/phpcpd https://phar.phpunit.de/phpcpd.phar && chmod +x /usr/bin/phpcpd \
  && wget -q -O /usr/bin/phpdoc https://phpdoc.org/phpDocumentor.phar && chmod +x /usr/bin/phpdoc \
  && wget -q -O /usr/bin/phploc https://phar.phpunit.de/phploc.phar && chmod +x /usr/bin/phploc \
  && wget -q -O /usr/bin/phptok https://phar.phpunit.de/phptok.phar && chmod +x /usr/bin/phptok \
  && wget -q -O /usr/bin/phpdox https://github.com/theseer/phpdox/releases/download/0.8.1.1/phpdox-0.8.1.1.phar && chmod +x /usr/bin/phpdox \
  && wget -q -O /usr/bin/box https://github.com/box-project/box2/releases/download/2.5.2/box-2.5.2.phar && chmod +x /usr/bin/box \
  && wget -q -O /usr/bin/phpbrew https://github.com/phpbrew/phpbrew/raw/master/phpbrew && chmod +x /usr/bin/phpbrew

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN echo "America/Los_Angeles" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

# RUN mkdir -p $JENKINS_HOME/jobs \
#     && cd $JENKINS_HOME/jobs \
#     && mkdir php-template \
#     && cd php-template \
#     && wget https://raw.githubusercontent.com/sebastianbergmann/php-jenkins-template/master/config.xml \
#     && cd .. \
#     && chown -R jenkins:jenkins php-template/


EXPOSE 8080 50000
