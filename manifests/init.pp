class sbt(
  $version = 'UNSET',
  $url = 'UNSET',
  $package_format = 'UNSET'
) {
  include sbt::params

  $version_real = $version ? {
    'UNSET' => $::sbt::params::version,
    default => $version,
  }

  $package_format_real = $package_format ? {
    'UNSET' => $::sbt::params::package_format,
    default => $package_format,
  }

  $url_real = $url ? {
    'UNSET' => "http://repo.scala-sbt.org/scalasbt/sbt-native-packages/org/scala-sbt/sbt/${version_real}/sbt.${package_format_real}",
    default => $url,
  }

  notify { "osfamily = ${osfamily}": }
  notify { "version_real = ${version_real}": }
  notify { "package_format_real = ${package_format_real}": }
  notify { "archive download url = ${url_real}": }
  
  archive::download { "sbt-${version_real}.${package_format_real}" :
    url        => $url_real,
    checksum   => false,
    src_target => '/var/tmp',
  }

  $package_provider = $::osfamily ? {
    'RedHat' => 'rpm',
    'Debian' => 'dpkg',
    default  => fail( 'Unsupported OS family' ),
  }
  notify { "package_provider = ${package_provider}": }

#  file { "/var/tmp/sbt-${version_real}.${package_format_real}" :
#    source => $url_real,
#  }

  package { "sbt-${version_real}" :
    ensure   => installed,
    provider => $package_provider,
    source   => "/var/tmp/sbt-${version_real}.${package_format_real}",
    require  => Archive::Download[ "sbt-${version_real}.${package_format_real}" ],
  }

  file { '/usr/bin/sbt' :
    source => "puppet:///modules/sbt/sbt",
    mode => '0755',
  }
}