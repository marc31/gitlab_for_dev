# Setting up GitLab, GitLab Runner, and Registry for Local Testing

## Prerequisites

### Generating SSL Certificate for Docker Compose

Before running your Docker Compose setup, you must generate an SSL certificate and specify its path in the docker-compose.yml file.

You have two options for generating the certificate:

- [mkcert](https://github.com/FiloSottile/mkcert)
- [my_mkcert](https://github.com/marc31/my_mkcert)

### Modifying Hosts File

To ensure proper functionality, add the following line to your /etc/hosts file:

```
127.0.0.1 gitlab.loc
```

This step is necessary for correct domain resolution within your local environment.

## First Start

```bash
docker compose up -d
docker compose logs -f gitlab

# Retrieve the initial password:
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

Then navigate to http://gitlab.loc:8930 to log in using the root user and the previously retrieved password.

It is advisable to disable the root user, which can be subjected to brute-force attacks. Instead, create a new user for yourself and disable account creation on your instance.

## GitLab Runner

To configure the GitLab Runner, follow these steps:

1. Navigate to http://gitlab.loc:8930/admin/runners and register a new runner. Make sure to note down the registration token. Note: The GitLab Runner and GitLab instances are on the same network. However, the runner accesses GitLab via the URL https://gitlab.loc:8930, which is specified in the hosts file.

2. Define the Docker network mode shared by both GitLab and the runner. You can find this information by running either docker compose gitlab-runner down or docker network ls. Typically, the network name is gitlab_default (where gitlab is the container name specified in the Docker Compose file and default because no network is explicitly declared in the Docker Compose file).

```bash
docker compose exec -it gitlab-runner gitlab-runner register --docker-network-mode gitlab_default
```

Alternatively, you can register the runner without interaction using the following command:

```bash
docker compose exec -it gitlab-runner gitlab-runner register \
--non-interactive \
--url https://gitlab.loc:8930 \
--registration-token ADD_TOKEN_HERE \
--executor docker \
--docker-image alpine:3.19.1 \
--docker-network-mode gitlab_default
```

During the registration process, you will be prompted to select the default Docker image (e.g., I chose alpine:3.19.1).

**If you forget to specify the docker-network-mode, you may encounter an error when a job starts, such as:**

```
fatal: unable to access 'https://gitlab.loc:8930/root/xxxx.git/': Could not resolve host: gitlab.loc
```

To avoid this error, set the network_mode option in the ./config-runner/config.toml file with your network name, as follows:

```toml
[[runners]]
  ...
  [runners.docker]
    ...
    network_mode = "gitlab_default"
```

It's essential to restart it to apply any changes made. You can restart the GitLab Runner using the following command:

```bash
docker compose restart gitlab-runner
```

This command ensures that any configuration changes take effect and the GitLab Runner operates with the updated settings.

## Registry

To test the registry, you can perform the following steps:

```bash
# Login
docker login gitlab.loc:5050

# Pull hello-world from the Docker registry
docker pull hello-world

# Tag the image to be pushed
docker tag hello-world gitlab.loc:5050/root/hello-world

# Push the image to the registry
docker push gitlab.loc:5050/root/hello-world

# Remove the local image
docker rmi gitlab.loc:5050/root/hello-world

# Pull the image from our local registry
docker pull gitlab.loc:5050/root/hello-world

# Get a list of images
curl -X GET http://gitlab.loc:5050/v2/_catalog
curl -X GET http://gitlab.loc:5050/v2/ubuntu/tags/list
curl -X GET -u <user>:<pass> http://gitlab.loc:5050/v2/_catalog
```
