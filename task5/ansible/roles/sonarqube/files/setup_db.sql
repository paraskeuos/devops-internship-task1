CREATE DATABASE sonarqube;
CREATE USER sonarqube WITH PASSWORD 'sonarqube';
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;