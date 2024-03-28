# Environment variables
host_name = ENV['HOST_NAME']
https_port = ENV['HTTPS_PORT']
https_port_registry = ENV['HTTPS_PORT_REGISTRY']

# If a port and HTTPS are specified here, Nginx will automatically utilize the specified port,
# and this is the one that should be exposed in the docker-compose.yml file.
external_url "https://#{host_name}:#{https_port}"

# Use our local ssl
letsencrypt['enable'] = false
nginx['redirect_http_to_https'] = true
# We do not need this because we bind to default folder /etc/gitlab/ssl/
# nginx['ssl_certificate'] = "/etc/ssl/certs/gitlab/gitlab.loc.crt"
# nginx['ssl_certificate_key'] = "/etc/ssl/certs/gitlab/gitlab.loc.key"
# Use this if your key as a password
# nginx['ssl_password_file'] = '/etc/gitlab/ssl/key_file_password.txt'

# SSH port
gitlab_rails['gitlab_shell_ssh_port'] = ENV['SSH_PORT']
gitlab_rails['time_zone'] = "Europe/Paris"

# Enable registry
registry['enable'] = true
registry_external_url "https://#{host_name}:#{https_port_registry}"
registry_nginx['redirect_http_to_https'] = true
# gitlab_rails['registry_path'] = "/path/to/registry/storage"
