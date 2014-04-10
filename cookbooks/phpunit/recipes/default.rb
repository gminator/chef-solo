#
# Cookbook Name:: phpunit
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "Isntall PHP Unit" do
  user "root"
  not_if "test -f /usr/bin/phpunit"
	 code <<-EOH
		pear channel-discover pear.phpunit.de
		pear channel-discover components.ez.no
		pear channel-discover pear.symfony.com
		pear install --alldeps phpunit/PHPUnit
	EOH
end


