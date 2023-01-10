## Installing K3S (lightweight Kubernetes)

Run the following command on the server: <code>curl -sfL https://get.k3s.io | sh -</code>

To add worker nodes to the cluster, run the following command: 
<code>curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken K3S_NODE_NAME=mynodename sh -</code>

The value for the <code>K3S_TOKEN</code> variable can be found in the <code>/var/lib/rancher/k3s/server/node-token</code> on the server machine.
Worker nodes all need to have different names which can be specified using the <code>K3S_NODE_NAME</code> variable. Using the variable by itself is not required.

## CLI - basic usage

The CLI tool is <code>kubectl</code>. To list commands or get further explanation on them use the <code>help</code> argument.
For example: <code>kubectl help</code>, <code>kubectl create help</code>.

The central CLI functions are CRUD commands that can be run against Kubernetes resources (nodes, pods, deployments, services etc).

Example: <code>kubectl create deployment nginx-deployment --image=nginx</code>

The command above would create the resource deployment called nginx-deployment that uses a container made from the nginx image (other resources will be created implicitly as well).

By running <code>kubectl edit deployment nginx-deployment</code> the default text editor will be opened and the deployment's configuration in yaml format can be edited. After editing, saving and exiting, Kubernetes will apply the changes if the configuration is correct.

The command <code>kubectl get deployment nginx-deployment</code> can be run to display some information about the resource. Adding the argument <code>-o wide</code> would add more detail. The argument <code>-o yaml</code> would display the resource configuration in yaml format.

To remove the deployment, run <code>kubectl delete deployment nginx-deployment</code>.

Example for non-CRUD commands: configure the master node as unschedulable (such that pods can't be deployed on it)

To display all nodes run <code>kubectl get nodes</code>. Mark the name of the master node. Run <code>kubectl cordon node_name</code> to set the node as unschedulable (<code>uncordon</code> is the inverse command).

## Creating resources using yaml files

Resources such as deployments can be configured using yaml files which can look like the implicitly created nginx-deployment yaml configuration in the section above.
Run <code>kubectl apply -f file.yml</code> to apply the desired configuration.