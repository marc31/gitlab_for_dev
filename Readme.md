# Setting up GitLab, GitLab Runner, and Registry for Local Testing

## Prerequisites

You need to generate a certificate and specify its path in the docker-compose.yml file.

You can do this either with [mkcert](https://github.com/FiloSottile/mkcert) or using [my_mkcert](https://github.com/marc31/my_mkcert).

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

Navigate to http://gitlab.loc:8930/admin/runners and register a new runner, keeping note of the token.

```bash
docker compose exec -it gitlab-runner gitlab-runner register
```

Answer the prompts (I chose Debian) for the default image.

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
