class { 'docker':
        version => latest,
        docker_users => ['ubuntu'],
}

docker_volume { 'vaultwarden':
        ensure => present,
}

docker::image { 'vaultwarden/server':
        image_tag => 'latest',
        ensure => present
}


docker::run { 'vaultwarden':
        image  => 'vaultwarden/server',
        ports  => ['80:80'],
        detach => true,
        volumes => ['vaultwarden:/data'],
        restart_service => true,
        require => Class['docker'],
        ensure => present
}

