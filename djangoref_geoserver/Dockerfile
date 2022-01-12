FROM alpine:latest

#ENV TOMCAT_USER=admintom
#ENV TOMCAT_PASSWORD=admintom
#ENV GEOSERVER_DATA_DIR=/opt/geoserver/data_dir

RUN apk update && apk upgrade
RUN apk fetch openjdk8
RUN apk add openjdk8

RUN apk --no-cache add zip
RUN apk --no-cache add gettext

## Descargar tomcat 8
RUN cd /tmp && wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.41/bin/apache-tomcat-8.5.41.tar.gz

## Descomprimir tomcat
RUN tar -zxvf /tmp/apache-tomcat-8.5.41.tar.gz -C /usr/local

## Renombrar la carpeta descomprimida a "tomcat"
RUN cd /usr/local && mv apache-tomcat-8.5.41 tomcat

RUN wget -q https://sourceforge.net/projects/geoserver/files/GeoServer/2.19.2/geoserver-2.19.2-war.zip -O /tmp/geoserver.zip
RUN unzip -q /tmp/geoserver.zip -d /tmp
RUN unzip /tmp/geoserver.war -d /usr/local/tomcat/webapps/geoserver
#RUN mv /tmp/geoserver.war /usr/local/tomcat/webapps/geoserver.war

## Exponer puerto
EXPOSE 8080

COPY conf/tomcat-users.xml /tmp/tomcat-users.xml
COPY conf/web.xml /tmp/web.xml
COPY conf/context.xml /tmp/context.xml
COPY conf/datastore.xml /tmp/datastore.xml
COPY entrypoint.sh /tmp/entrypoint.sh 
COPY var/log4j-1.2.17.norce.jar /usr/local/tomcat/webapps/geoserver/WEB-INF/lib/log4j-1.2.17.norce.jar
RUN rm /usr/local/tomcat/webapps/geoserver/WEB-INF/lib/log4j-1.2.17.jar

RUN chmod +x /tmp/entrypoint.sh

## Iniciar tomcat
ENTRYPOINT ["/tmp/entrypoint.sh"]