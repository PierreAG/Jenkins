# Use the official Jenkins LTS base image
FROM jenkins/jenkins:jdk17

# Switch to root user to perform system-level updates
USER root

# Set the Jenkins system property to disable the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV JENKINS_HOME /var/jenkins_home

# Set the Maven environment variables
ENV MAVEN_HOME=/opt/maven
ENV MAVEN_VERSION=3.9.4
ENV PATH=${MAVEN_HOME}/bin:${PATH}

# Copy the plugins.txt file into the image
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Example: You can copy additional configurations if needed
COPY custom-config.xml /usr/share/jenkins/ref/custom-config.xml

# Configure Jenkins to poll a repository by default
# For example, configuring Jenkins to poll a Git repository
COPY jobb-config.xml /var/jenkins_home/jobs/maven-build/config.xml

# Change ownership of the Jenkins home directory to the 'jenkins' user
RUN chown -R jenkins:jenkins $JENKINS_HOME

# Install maven
RUN curl -fsSL -o /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -xz -C /opt -f /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven \
    && rm /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && chown -R jenkins:jenkins /opt/maven

# Install Jenkins plugins using jenkins-plugin-cli
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Switch back to the jenkins user to run Jenkins
USER jenkins
