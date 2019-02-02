FROM jboss/wildfly

# Maintainer
MAINTAINER "kunalpise@gmail.com"

ADD target/spring-test-mvc-configuration.war /opt/jboss/wildfly/standalone/deployments/spring-test-mvc-configuration.war

# Expose the ports we're interested in
EXPOSE 8390
EXPOSE 8090
EXPOSE 8190
EXPOSE 8290

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
