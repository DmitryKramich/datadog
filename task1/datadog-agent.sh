#!/bin/bash

# conf selinux
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

# install java and tomcat 
sudo yum install -y java-1.8.0-openjdk
sudo yum install -y tomcat wget tomcat-admin-webapps tomcat-docs-webapp tomcat-javadoc tomcat-webapps
sudo wget -P /var/lib/tomcat/webapps/ https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war
sudo chown tomcat:tomcat /var/lib/tomcat/webapps/sample.war
sudo chmod 775 /var/lib/tomcat/webapps/sample.war
sudo systemctl enable tomcat
sudo systemctl start tomcat


# install and configure datadog-agent. ${key} from terraform input from terminal
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=${key} DD_SITE="datadoghq.eu" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# configure web check
cp /etc/datadog-agent/conf.d/http_check.d/conf.yaml.example /etc/datadog-agent/conf.d/http_check.d/conf.yaml
sudo sed -i 's!- name: My first service!- name: tomcat sample app!' /etc/datadog-agent/conf.d/http_check.d/conf.yaml
sudo sed -i 's!url: http://some.url.example.com!url: http://34.67.31.249:8080/sample/!' /etc/datadog-agent/conf.d/http_check.d/conf.yaml

# enable logs (tomcat)

sudo sed -i 's!# logs_enabled: false!logs_enabled: true!' /etc/datadog-agent/datadog.yaml
sudo cp /etc/datadog-agent/conf.d/tomcat.d/conf.yaml.example /etc/datadog-agent/conf.d/tomcat.d/conf.yaml
sudo chmod 775 -R /usr/share/tomcat/logs/
sudo cat >> /etc/datadog-agent/conf.d/tomcat.d/conf.yaml <<EOF
logs:
  - type: file
    path: /var/log/tomcat/*.log
    source: tomcat
    service: sample
EOF

sudo systemctl restart datadog-agent

#sudo datadog-agent status