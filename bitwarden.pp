node default {
        group { 'docker':
                ensure => 'present',
                name => 'docker',
        }
        file { '/opt/bitwarden':
                ensure => 'directory',
                mode => '0700',
        }
        user { 'bitwarden':
                ensure => 'present',
                name => 'bitwarden',
                groups => 'docker',
                # password => 'hereisaplaceforoursupersensitivepassword',
                home => '/opt/bitwarden',
        }
}

