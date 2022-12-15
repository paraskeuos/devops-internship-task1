## On JFrog repositories

Among local, remote and virtual repositories, local is the only type that physically stores artifacts.
A remote repository acts as a caching proxy to another repository which can be of any type.
Virtual repositories are aggregates of other suitable repositories. For example, a virtual Docker repository can encompass a local Docker registry and a proxy to Docker Hub.

## Accessing JFrog Docker registries

JFrog Docker registries require a reverse proxy. However, newer version of JFrog come with a preconfigured Tomcat reverse proxy that works out-of-the-box.

To access a JFrog registry on new versions of JFrog, unlike with other types of repositories, use urls without the <code>/artifactory/</code> path segment.

```
docker login 10.0.0.15:8082/my-docker-repository
docker pull 10.0.0.15:8082/my-docker-repository/hello-world:latest
```