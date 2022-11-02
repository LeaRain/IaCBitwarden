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

# Create a docker volume for vaultwarden since it is running in a docker container
docker_volume { 'vaultwarden':
        ensure => present,
}

# Get the vaultwarden image: vaultwarden is delivered by one single ready to use image
docker::image { 'vaultwarden/server':
        image_tag => 'latest',
        ensure => present,
}

# Run vaultwarden
docker::run { 'vaultwarden/server':
        image  => 'vaultwarden/server',
	# vaultwarden port mapping requires this https/http mapping
        ports  => ['443:80'],
	# detach to false, so the container does not crash right after starting
        detach => false,
        volumes => ['/vaultwarden/:/data/', '/ssl/:/ssl/'],
	# Self signed certificate for web page
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
