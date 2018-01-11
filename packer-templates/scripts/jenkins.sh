#!/bin/bash -eux

# JDK and JRE are required for Jenkins
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt-get update
sudo apt-get install -y openjdk-8-jre openjdk-8-jdk unzip dos2unix

sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | apt-key add -
sudo echo deb http://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list

sudo apt-get update
sudo apt-get install -y jenkins
sudo apt-get upgrade -y
sudo /var/lib/dpkg/info/ca-certificates-java.postinst configure

# copy premade configuration files
# jenkins default config, to set --prefix=jenkins
sudo cp -f /tmp/jenkins-config/jenkins /etc/default
# fix dos newlines for Windows users
sudo dos2unix /etc/default/jenkins
# install some extra plugins
sudo /bin/bash /tmp/jenkins-config/install_jenkins_plugins.sh
# jenkins security and pipeline plugin config
sudo cp -f /tmp/jenkins-config/config.xml /var/lib/jenkins
# set up username for vagrant
sudo mkdir -p /var/lib/jenkins/users/vagrant
sudo cp /tmp/jenkins-config/users/vagrant/config.xml /var/lib/jenkins/users/vagrant
# example job
sudo mkdir -p /var/lib/jenkins/jobs
cd /var/lib/jenkins/jobs
sudo tar zxvf /tmp/jenkins-config/example-job.tar.gz

# set permissions or else jenkins can't run jobs
sudo chown -R jenkins:jenkins /var/lib/jenkins

# restart for jenkins to pick up the new configs
sudo service jenkins restart