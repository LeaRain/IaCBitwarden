node default {
        class { 'docker':
                version => latest,
        }


        docker_volume { 'vaultwarden':
                ensure => present,
        }

        docker::image { 'vaultwarden/server':
                image_tag => 'latest',
                ensure => present
        }

        docker::run { 'vaultwarden':
                image => 'vaultwarden/server',
                detach => true,
                volumes => ['vaultwarden:/data'],
                ports => ['80:80'],
                restart_service => true
        }
}

