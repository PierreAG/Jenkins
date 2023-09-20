# Use the official Jenkins LTS base image
FROM jenkins/jenkins:lts

# Set the Jenkins system property to disable the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Copy the plugins.txt file into the image
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Example: You can copy additional configurations if needed
COPY jenkins-config.xml /usr/share/jenkins/ref/custom-config.xml

# Install Jenkins plugins using jenkins-plugin-cli
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt


