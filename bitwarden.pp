node default {
        class { 'docker':
                version => latest,
                docker_users => ['bitwarden'],
        }

        docker::image { 'vaultwarden/server':
                image_tag => 'latest'
        }

        docker::run { 'vaultwarden':
                image => 'vaultwarden/server',
                detach => true,
                volumes => ['/opt/bitwarden'],
                ports => ['80'],
                expose => ['80'],
                command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
        }

        file { '/opt/bitwarden':
                ensure => 'directory',
                mode => '0700',
        }

        user { 'bitwarden':
                ensure => 'present',
                name => 'bitwarden',
                # password => 'hereisaplaceforoursupersensitivepassword',
                home => '/opt/bitwarden',
        }
}
