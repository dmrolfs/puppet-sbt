class sbt::params {
	$os_package_format = $::osfamily ? {
    'RedHat' => 'rpm',
    'Debian' => 'deb',
    default  => fail( 'Unsupported OS family' ),
  }

  $package_format = $::sbt_package_format ? {
    undef   => $os_package_format,
    default => $::sbt_package_format,
  }

  $version = $::sbt_version ? {
    undef   => '0.13.1',
    default => $::sbt_version,
  }

  $url = $::sbt_url ? {
    undef   => "http://repo.scala-sbt.org/scalasbt/sbt-native-packages/org/scala-sbt/sbt/{$version}/sbt.{$package_format}",
    default => $::sbt_url,
  }
}