########### Using ubuntu os


sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins


Beginning with Jenkins 2.335 and Jenkins 2.332.1, the package is configured with systemd rather than the older System V init. More information is available in "Managing systemd services".

The package installation will:

Setup Jenkins as a daemon launched on start. Run systemctl cat jenkins for more details.

Create a ‘jenkins’ user to run this service.

Direct console log output to systemd-journald. Run journalctl -u jenkins.service if you are troubleshooting Jenkins.

Populate /lib/systemd/system/jenkins.service with configuration parameters for the launch, e.g JENKINS_HOME

Set Jenkins to listen on port 8080. Access this port with your browser to start configuration.

If Jenkins fails to start because a port is in use, run systemctl edit jenkins and add the following:

[Service]
Environment="JENKINS_PORT=8081"
Here, "8081" was chosen but you can put another port available.

Why use apt and not apt-get or another command? The apt command has been available since 2014. It has a command structure that is similar to apt-get but was created to be a more pleasant experience for typical users. Simple software management tasks like install, search and remove are easier with apt.
