class { 'docker':
        version => latest,
        docker_users => ['ubuntu'],
}

docker_volume { 'vaultwarden':
        ensure => present,
}

docker::image { 'vaultwarden/server':
        image_tag => 'latest',
        ensure => present,
}


docker::run { 'vaultwarden/server':
        image  => 'vaultwarden/server',
        ports  => ['80:80'],
        detach => false,
        volumes => ['/vaultwarden/:/data/'],
        restart_service => true,
        require => Class['docker'],
        ensure => present
}
