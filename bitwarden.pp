# Set up directory permissions
file { '/vaultwarden':
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0700',
}

# Set up ssl
file { '/ssl':
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0500',
}

# Docker setup
class { 'docker':
        version => latest,
}

docker_volume { 'vaultwarden':
        ensure => present,
}

docker::image { 'vaultwarden/server':
        image_tag => 'latest',
        ensure => present,
}

# Run vaultwarden
docker::run { 'vaultwarden/server':
        image  => 'vaultwarden/server',
        ports  => ['80:80'],
        detach => false,
        volumes => ['/vaultwarden/:/data/', '/ssl/:/ssl/'],
        env => ['ROCKET_TLS=\'{certs=\"/ssl/server.crt\",key=\"/ssl/server.key\"}\'']
        restart_service => true,
        require => Class['docker'],
        ensure => present
}
