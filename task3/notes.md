# Docker containers as agents - controller as executor

Using Jenkins as a Docker container, this requires installation of Docker inside it.

Add jenkins user to the docker group: <code>usermod -aG docker jenkins</code>

Docker socket file should be mapped to that of the host:
Use <code>-v /var/run/docker.sock:/var/run/docker.sock</code> when running the <code>docker run</code> command

Docker group id inside the container should equal to the one of the host: <code>groupmod -g host_gid docker</code>

Use container agents in Jenkins script:

'''
agent {
    docker {
        image 'name'
    }
}
'''

# Docker containers as builder nodes

Use an image with a running SSH server.

Create a user which Jenkins controller will use to connect with the node.
For key pair login, add a public key to the user's .ssh/authorized_keys file.

If using known_hosts file verification, add the builder node to Jenkins .ssh/known_hosts file - <code>ssh-keyscan node_host >> known_hosts</code>

For the controller to connect with the node, use credentials created by adding the corresponding private key.

See Docker files in the docker directories for more.
