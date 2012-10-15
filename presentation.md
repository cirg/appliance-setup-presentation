% Standard Server Builds with `appliance-setup` and Puppet
% Svend Sorensen \<svends@uw.edu>
% October 16, 2012

# Summary

A description of the `appliance-setup` package, how to use it, and the
technologies it uses.

# `appliance-setup`

`appliance-setup` is a package for building standard server builds in
a reproducible way.

Code is on [GitHub](https://github.com):

<https://github.com/cirg/appliance-setup>

# Process

1. Import/Instantiate VM
2. Boot VM
3. Download `appliance-setup`
4. Run `appliance-setup`

# Instantiate VM

The process for creating and booting the virtual machine depends on
the virtualization software.

Download [TurnKey Linux Core](http://www.turnkeylinux.org/core).

<http://www.turnkeylinux.org/docs/installation-appliances-virtual box>

# Download `appliance-setup`

From a root prompt on the fresh VM:

	git clone --recursive \
		https://github.com/cirg/appliance-setup.git \
		/opt/appliance-setup

# Run `appliance-setup`

	APPLIANCE_COMPONENTS="apache tomcat mysql" \
	/opt/appliance-setup/bin/appliance-setup apply

`APPLIANCE_COMPONENTS` is a space separated list of components. Available components are under
[puppet/modules/appliance_components/manifests](https://github.com/cirg/appliance-setup/tree/master/puppet/modules/appliance_components/manifests)

# How `appliance-setup` Works

`appliance-setup` uses

* TurnKey Core virtual machine image
* Puppet configuration management system
* `appliance-setup` script

# TurnKey Linux

TurnKey Linux provides prebuilt virtual machines.

* images work on VirtualBox, VMware KVM, Xen, Amazon EC2, as well as
  physical machines
* based on Debian

TurnKey images provides a standard base on which to create our
standard server builds.

<http://www.turnkeylinux.org>

# Puppet

Puppet is a configuration management system.

Puppet includes a language for defining the state of a system, tools
for applying the defined state, and a server/client service for
configuring systems.

Puppet provides:

* templates
* dry-runs
* logging
* reporting

<http://puppetlabs.com/puppet/puppet-open-source/>

# Puppet Language

* Resource: packages, files, services, etc.
* Class: a collection of resources
* Module: a collection of puppet files

# Puppet Resources

[Package](http://docs.puppetlabs.com/references/stable/type.html#package)

	package { 'ntpd':
		ensure => installed,
	}

[File](http://docs.puppetlabs.com/references/stable/type.html#file)
	
	file { '/etc/ntp.conf':
		ensure  =>  file,
		mode	=> '0644',
		owner   => 'root',
		group   => 'root',
		source  => template('ntp/ntp.conf.erb'),
	}

[Service](http://docs.puppetlabs.com/references/stable/type.html#service)
	
	service { 'ntpd':
		ensure => running,
	}

# Puppet Classes

	class ntp {
		package { 'ntpd':
			ensure => installed,
		}

		file { '/etc/ntp.conf':
			ensure  =>  file,
			source  => template('ntp/ntp.conf.erb'),
		}

		service { 'ntpd':
			ensure => running,
		}
	}

# Dependencies

	class ntp {
		package { 'ntpd':
			ensure => installed,
		}
		file { '/etc/ntp.conf':
			ensure  => file,
			source  => template('ntp/ntp.conf.erb'),
			require => Package['ntpd'],
		}
		service { 'ntpd':
			ensure => running,
			subscribe => File['/etc/ntp.conf'],
		}
	}

# Puppet Modules

	$ tree ntp
	ntp/
	|-- files
	|-- templates
	|   `-- ntp.conf.el.erb
	`-- manifests
	    `-- init.pp
	
# Puppet Templates

<https://github.com/puppetlabs/puppetlabs-mysql/blob/master/templates/my.cnf.pass.erb>

	[client]
	user=root
	host=localhost
	<% unless root_password == 'UNSET' -%>
	password=<%= root_password %>
	<% end -%>

# Facter

Facter is a library that gathers information (called facts) about a
system. These facts are available as variables in Puppet files.

# Facter (Command Line)

	$ facter
	architecture => i386
	hardwaremodel => i686
	hostname => core
	id => root
	interfaces => eth0,lo
	ipaddress => 10.0.2.15
	is_virtual => true
	kernelversion => 2.6.32
	macaddress => 52:54:00:6d:ee:93
	memoryfree => 396.07 MB
	memorysize => 502.67 MB
	operatingsystem => Debian
	operatingsystemrelease => 6.0.5
	processorcount => 1
	virtual => kvm
	...

# Contributing

* Set up git and a GitHub account: <https://help.github.com/articles/set-up-git>
* Fork `appliance-setup` repo: <https://help.github.com/articles/fork-a-repo>
* Send pull requests
* File bugs, issues, feature requests: <https://github.com/cirg/appliance-setup/issues?state=open>

# Next Steps

* Testing
* Configuring applications
* Additional components
* Configuration file
