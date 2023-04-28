# Docker Installation

Install latest docker tool based on OS from [here](https://docs.docker.com/engine/install/)

## Manage Docker as a non-root user
After Docker engine installation it is mandatory to make docker
as non-root user to avoid permission issues while running the flow.
Run below commands to make docker as non-root user.

```
sudo groupadd docker
sudo usermod -aG docker $USER
sudo reboot # REBOOT!
```

You must restart your operating system for the group permissions to apply.

## Checking the Docker Installation

After that, you can run Docker Hello World without root. To test
it use the following command:

```
docker run hello-world
```

You will get a little happy message of Hello world, once again,
but this time without root.

```
Hello from Docker!
```

This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
- The Docker client contacted the Docker daemon.
- The Docker daemon pulled the `hello-world` image from the Docker Hub.
   (amd64)
- The Docker daemon created a new container from that image which runs
   the executable that produces the output you are currently reading.
- The Docker daemon streamed that output to the Docker client, which
   sent it to your terminal.

