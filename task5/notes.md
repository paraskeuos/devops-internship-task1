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

## Installing and configuring SonarQube on Ubuntu

First ensure the following prerequisites are met:

- vm.max_map_count is greater than or equal to 524288
- fs.file-max is greater than or equal to 131072
- the user running SonarQube can open at least 131072 file descriptors
- the user running SonarQube can open at least 8192 threads

To check these values use the following commands:
```
sysctl vm.max_map_count
sysctl fs.file-max
ulimit -n
ulimit -u
```

If the values of vm_max_map_count or fs.file-max aren't appropriate, you can set them by creating/editing <code>/etc/sysctl.d/99-sonarqube.conf</code> (or <code>/etc/sysctl.conf</code>) and entering the following:
```
vm.max_map_count=524288
fs.file-max=131072
```

For the later values, edit <code>/etc/security/limits.d/99-sonarqube.conf</code> or (<code>/etc/security/limits.conf</code>) and add the following lines:
```
sonarqube   -   nofile   131072
sonarqube   -   nproc    8192
```

Reboot after making changes.

### Additional prerequisites

Ensure Java is installed. SonarQube supports OpenJDK 11 for example.

SonarQube can work with multiple databases but this example will integrate PostgreSQL.

In Ubuntu, PostgreSQL is installable through standard apt repositories.

A database should be created for SonarQube to use along with a user/role with create, update and delete privileges.

One way to achieve this is to create an SQL script file with the following contents:
```
CREATE DATABASE sonarqube;
CREATE USER sonarqube WITH PASSWORD '<sonarqube_password>';
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;
```

You can save the temporary script file for example in the /tmp directory where the postgres user will have access to it.
Then run the script with this command: <code>sudo -u postgres psql -f script_file.sql</code>

### Running SonarQube

Download the .zip file from SonarQube's website, unzip it and within the extracted directory, edit the <code>/conf/sonar.properties</code>.
Find the lines <code>#sonar.jdbc.username=</code> and <code>#sonar.jdbc.password=</code>, uncomment them and add the PostgreSQL credentials to the end of the lines.

The web server will by default run on localhost:9000. If needed, change the address in the similar way as described above by uncommenting the line <code>#sonar.web.host=0.0.0.0</code> and setting the appropriate IP address. Similarly, the default port can be changed, however keep in my SonarQube must NOT be run with root privileges, therefore the standard HTTP port 80 won't be opened if <code>sonar.web.port</code> were set to 80.

To run SonarQube, go back to the root of the unzipped directory, navigate to <code>bin/linux-x86-64</code> and run the command <code>./sonar.sh start</code>.

## Adding JaCoCo coverage to Maven/SonarQube pipeline

In the pom.xml file of the Maven project add the following JaCoCo plugin specification to the plugins section:
```
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.8</version>
    <executions>
        <execution>
        <id>prepare-agent</id>
        <goals>
            <goal>prepare-agent</goal>
        </goals>
        </execution>
        <execution>
        <id>report</id>
        <goals>
            <goal>report</goal>
        </goals>
        </execution>
    </executions>
</plugin>
```

Under <code>executions</code>, the <code>prepare-agent</code> goal prepares the JaCoCo runtime for execution and the <code>report</code> goal generates reports based on the data provided by the agent. These two goals are the bare minimum.

The following can be added to the <code>properties</code> section:
```
<!-- JaCoCo Properties -->
<jacoco.version>0.8.8</jacoco.version>
<sonar.java.coveragePlugin>jacoco</sonar.java.coveragePlugin>
<sonar.exclusions>pom.xml</sonar.exclusions>
<sonar.dynamicAnalysis>reuseReports</sonar.dynamicAnalysis>
<sonar.language>java</sonar.language>
<sonar.coverage.xmlReportPaths>target/site/jacoco/jacoco.xml</sonar.coverage.xmlReportPaths>
```

Of special note is the last entry which tells SonarQube where to find the coverage report.


