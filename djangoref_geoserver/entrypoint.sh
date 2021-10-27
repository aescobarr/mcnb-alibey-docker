#!/bin/sh

USERS_XML=${USERS_XML:-${GEOSERVER_DATA_DIR}/security/usergroup/default/users.xml}
ROLES_XML=${ROLES_XML:-${GEOSERVER_DATA_DIR}/security/role/default/roles.xml}
CONTEXT_XML=${CONTEXT_XML:-${TOMCAT_DIR}/webapps/manager/META-INF/context.xml}
CLASSPATH=${CLASSPATH:-${TOMCAT_DIR}/webapps/geoserver/WEB-INF/lib/}

#make_hash(){
#    NEW_PASSWORD=$1
#    (echo "digest1:" && java -classpath $(find $CLASSPATH -regex ".*jasypt-[0-9]\.[0-9]\.[0-9].*jar") org.jasypt.intf.cli.JasyptStringDigestCLI digest.sh algorithm=SHA-256 saltSizeBytes=16 iterations=100000 input="$NEW_PASSWORD" verbose=0) | tr -d '\n'
#}

#PWD_HASH=$(make_hash $GEOSERVER_ADMIN_PASSWORD)
PWD_HASH="plain:${GEOSERVER_ADMIN_PASSWORD}"

# users.xml setup
cp $USERS_XML $USERS_XML.orig

# <user enabled="true" name="admin" password="digest1:7/qC5lIvXIcOKcoQcCyQmPK8NCpsvbj6PcS/r3S7zqDEsIuBe731ZwpTtcSe9IiK"/>
cat $USERS_XML.orig | sed -e "s/ name=\".*\" / name=\"${GEOSERVER_ADMIN_USER}\" /" | sed -e "s/ password=\".*\"/ password=\"${PWD_HASH//\//\\/}\"/" > $USERS_XML

# roles.xml setup
cp $ROLES_XML $ROLES_XML.orig
# <userRoles username="admin">
cat $ROLES_XML.orig | sed -e "s/ username=\".*\"/ username=\"${GEOSERVER_ADMIN_USER}\"/" > $ROLES_XML

cp /tmp/context.xml $CONTEXT_XML

envsubst < /tmp/tomcat-users.xml > /usr/local/tomcat/conf/tomcat-users.xml
envsubst < /tmp/web.xml > /usr/local/tomcat/webapps/geoserver/WEB-INF/web.xml
envsubst < /tmp/datastore.xml > ${GEOSERVER_DATA_DIR}/workspaces/mzoologia/bd_zoo@kilauea/datastore.xml

/usr/local/tomcat/bin/catalina.sh start && tail -f /usr/local/tomcat/logs/catalina.out

exec "$@"