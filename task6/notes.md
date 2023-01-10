## Infrastructure

- 1 bare-metal Linux machine acting as Kubernetes control node
- 1+ Linux VMs acting as worker nodes, installed with Vagrant (see the vagrant directory), using bridged connections to LAN (same as the control node)

The idea is to test scaling deployments spanning multiple nodes.

The simplest test deployment is specified in the nginx directory. It consists of one nginx deployment resource and a loadbalancer service accessible on port 30000 on every node that has running replicas of the deployment.

We simulate a production environment where we don't public access to any nodes. Additionaly, the LoadBalancer service type limits us to use non-standard web ports.
We deploy a reverse proxy VM running nginx/apache2 which redirects HTTP requests to worker nodes.

If we run <code>curl -v http://proxy_ip</code>, where proxy_ip is the IP of the reverse proxy apache2 VM, we can see that the curl agent communicates directly to the nginx server replicas running in Kubernetes pods (see the Server response header) and there is no mention of worker node IP or port 30000:

```
*   Trying 192.168.0.22:80...
* Connected to 192.168.0.22 (192.168.0.22) port 80 (#0)
> GET / HTTP/1.1
> Host: 192.168.0.22
> User-Agent: curl/7.81.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Tue, 10 Jan 2023 15:14:44 GMT
< Server: nginx/1.23.3
< Content-Type: text/html
< Content-Length: 615
< Last-Modified: Tue, 13 Dec 2022 15:53:53 GMT
< ETag: "6398a011-267"
< Accept-Ranges: bytes
< Vary: Accept-Encoding
< 
<!DOCTYPE html>
<html>
    ...
</html>
* Connection #0 to host 192.168.0.22 left intact
```

The idea of the mondodb/mongo-express stack is to test using various resource types of Kubernetes and add some complexity, such as having different deployments communicating between each other, using secrets, configmaps etc.

We have pods running mongodb containers which use environment variable specified in the Secret resource, with internal mongodb-service associated with the deployment. ConfigMap is used as a link between mongodb-service and other resources that would want access to it, such as mongo-express. Finally, we deploy a LoadBalancer service as a link between clients and the mongo-express frontend.

## Installing K3S (lightweight Kubernetes)

Run the following command on the server: <code>curl -sfL https://get.k3s.io | sh -</code>

To add worker nodes to the cluster, run the following command: 
<code>curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken K3S_NODE_NAME=mynodename sh -</code>

The value for the <code>K3S_TOKEN</code> variable can be found in the <code>/var/lib/rancher/k3s/server/node-token</code> on the server machine.
Worker nodes all need to have different names which can be specified using the <code>K3S_NODE_NAME</code> variable. Using the variable by itself is not required.

## CLI - basic usage

The CLI tool is <code>kubectl</code>. To list commands or get further explanation on them use the <code>-h</code> argument.
For example: <code>kubectl -h</code>, <code>kubectl create -h</code>.

The central CLI functions are CRUD commands that can be run against Kubernetes resources (nodes, pods, deployments, services etc).

Example: <code>kubectl create deployment nginx-deployment --image=nginx</code>

The command above would create the resource deployment called nginx-deployment that uses a container made from the nginx image (other resources will be created implicitly as well).

By running <code>kubectl edit deployment nginx-deployment</code> the default text editor will be opened and the deployment's configuration in yaml format can be edited. After editing, saving and exiting, Kubernetes will apply the changes if the configuration is correct.

The command <code>kubectl get deployment nginx-deployment</code> can be run to display some information about the resource. Adding the argument <code>-o wide</code> would add more detail. The argument <code>-o yaml</code> would display the resource configuration in yaml format.

To remove the deployment, run <code>kubectl delete deployment nginx-deployment</code>.

Example for non-CRUD commands: configure the control node as unschedulable (such that pods can't be deployed on it)

To display all nodes run <code>kubectl get nodes</code>. Mark the name of the control node. Run <code>kubectl cordon node_name</code> to set the node as unschedulable (<code>uncordon</code> is its inverse).

## Creating resources using yaml files

Resources such as deployments can be configured using yaml files which can look like the implicitly created nginx-deployment yaml configuration in the section above.
Run <code>kubectl apply -f file.yml</code> to apply the desired configuration.

To delete the resourced specified in the file, run <code>kubectl delete -f file.yml</code>.

## Reverse proxy using Nginx and Apache2

When using nginx as a reverse proxy, to enable proxying to upstream server group edit the <code>/etc/nginx/sites-available/default</code> file. The first snippet should stand outside the <code>server</code> block.

```
upstream backend {
    server 192.168.0.21:30000;
    server 192.168.0.23:30000;
}
```

This snippet goes inside the <code>server</code> block.

```
location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to displaying a 404.
    # try_files $uri $uri/ =404;
    proxy_pass http://backend;
}
```

The <code>upstream</code> directive defines a server group called 'backend'. Redirection decisions will be based on the default Round Robin policy.
Within the <code>location</code> block we specify the group name so that all '/' requests to the proxy server get redirected to one of the servers in the backend group.

For apache2, this can be achieved with the code in the following snippet, with the exception that the 'byrequests' load balancing method will be used, and the default configuration file is <code>/etc/apache2/sites-available/000-default.conf</code>.

```
<Proxy balancer://backend/>
    BalancerMember http://192.168.0.21:30000
    BalancerMember http://192.168.0.23:30000
    ProxySet lbmethod=byrequests
</Proxy>

ProxyPass "/"  "balancer://backend/"
ProxyPassReverse "/"  "balancer://backend/"
```

To enable the required modules run: 

```
sudo a2enmod proxy_http
sudo a2enmod lbmethod_byrequests
```

Restart the server after configuring.

## Miscellaneous

Data in the Secret resource should be base64 encoded, not in plaintext. If encoding using echo and base64 utilities (<code>echo -n "data" | base64</code>) make sure not to include the <code>-n</code> option as the echo command adds a trailing newline at the end of input by default.

ConfigMap and the service referring to it should be in the same namespace.

Should a container fail in launch, run <code>kubectl logs pod_name</code> for more details.