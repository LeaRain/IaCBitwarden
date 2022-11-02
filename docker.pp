# Providing a minimal working example for running an example docker service, source: https://www.linuxjournal.com/content/managing-docker-instances-puppet

class { 'docker':
  docker_users => ['ubuntu'],
}

# Install an Apache2 image based on Alpine Linux.
# Use port forwarding to map port 8080 on the
# Docker host to port 80 inside the container.
docker::run { 'apache2':
  image   => 'httpd:alpine',
  ports   => ['8080:80'],
  require => Class['docker'],
}
