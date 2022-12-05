FROM ubuntu:22.04 as maven_install

RUN apt-get update
RUN apt-get install -y maven

#

FROM bitnami/git:latest as clone_repo

RUN git clone 'https://github.com/paraskeuos/simple-java-maven-app.git'

#

FROM maven_install as build

COPY --from=clone_repo simple-java-maven-app .
RUN mvn -B clean package

#

FROM openjdk:11.0-jre

COPY --from=build target/my-app-1.0-SNAPSHOT.jar hello_maven.jar

CMD ["java", "-jar", "hello_maven.jar"]

