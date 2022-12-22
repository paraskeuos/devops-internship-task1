## Using SonarQube Docker container

Run the container using the following command: <code>docker run -d --name sonarqube -v sonarqube_data:/opt/sonarqube sonarqube:latest</code>

For more volume granularity, create separate volumes for sonarqube data, logs and extensions, which are stored in <code>/opt/sonarqube/data</code>, <code>/opt/sonarqube/logs</code> and <code>/opt/sonarqube/extensions</code> within the container.

Once set up, navigate to <code>localhost:9000</code> and for the initial login use <code>admin</code> as both username and password.

### Guide for a minimalistic pipeline run by Jenkins

Create a project manually by selecting the Manually icon. After choosing a name click the Locally icon to test the project locally.
When prompted, generate and save a token, which will be used to login to SonarQube when analyzing the project.

In the pipeline, analyze the project:
```
mvn clean verify sonar:sonar \
    -Dsonar.projectKey=<project_name> \
    -Dsonar.host.url=http://sonarqube:9000 \
    -Dsonar.login=${ACCESS_TOKEN}</code>
```

The new report will be available within the SonarQube web interface.


