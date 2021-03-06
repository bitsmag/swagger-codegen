#!/bin/sh

SCRIPT="$0"

while [ -h "$SCRIPT" ] ; do
  ls=`ls -ld "$SCRIPT"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    SCRIPT="$link"
  else
    SCRIPT=`dirname "$SCRIPT"`/"$link"
  fi
done

if [ ! -d "${APP_DIR}" ]; then
  APP_DIR=`dirname "$SCRIPT"`/..
  APP_DIR=`cd "${APP_DIR}"; pwd`
fi

executable="./modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"

if [ ! -f "$executable" ]
then
  mvn clean package
fi

# if you've executed sbt assembly previously it will use that instead.
export JAVA_OPTS="${JAVA_OPTS} -XX:MaxPermSize=256M -Xmx1024M -DloggerPath=conf/log4j.properties"
#ags="$@ generate -i modules/swagger-codegen/src/test/resources/2_0/petstore.yaml -l python-flask -o samples/server/petstore/flaskConnexion-python2 -DsupportPython2=true"
ags="$@ generate -t modules/swagger-codegen/src/main/resources/flaskConnexion -i modules/swagger-codegen/src/test/resources/2_0/petstore-flask.yaml -l python-flask -o samples/server/petstore/flaskConnexion-python2 -c bin/supportPython2.json -D service"

rm -rf samples/server/petstore/flaskConnexion-python2/*
java $JAVA_OPTS -jar $executable $ags
