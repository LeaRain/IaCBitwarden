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
        ports  => ['443:80'],
        detach => false,
        volumes => ['/vaultwarden/:/data/', '/ssl/:/ssl/'],
        env => ['ROCKET_TLS={certs="/ssl/server.crt",key="/ssl/server.key"}'],
        restart_service => true,
        require => Class['docker'],
        ensure => present
}

# Create backup directory
file { '/vaultwarden-backup':
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0700',
}

# Create backup cronjob (backup database every 6 hours)
cron { 'vaultwarden-backup':
        ensure => present,
        command => 'sh -c "tar -zcvpf /vaultwarden-backup/backup-$(date +\%Y-\%m-\%d_\%H-\%M-\%S).tar.gz /vaultwarden"',
        user => 'root',
        hour => '*/6',
        minute => '0',
        weekday => absent,
        month => absent,
        monthday => absent,
}
