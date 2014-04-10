#
# Cookbook Name:: apt
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "Update Reposiory" do
  code <<-EOF
  	apt-get update
  EOF
end


packages = [
"apache2",
"php5",
"php5-mysql",
"php-pear",
"php5-curl",
"mysql-server",
"mysql-client",
"libmysqlclient-dev",
"git",
"git-core",
"phpmyadmin",
"git-flow"
]

packages.each do |pack|
	package "#{pack}" do
		action :install
	end
end


execute "disable_mod_php" do
   command "a2enmod php5"
  creates "/etc/apache2/mods-enabled/rewrite.load"
  action :run
end

service "apache2" do
        supports :status => true, :restart => true
        action [ :enable, :start ]
end

cron "ntpdate" do
	minute "0"
	command "/usr/sbin/ntpdate ntp.rsaweb.co.za"
	user "root"
end	

execute "enable_mod_rewrite" do
        command "a2enmod rewrite"
        creates "/etc/apache2/mods-enabled/rewrite.load"
        action :run
end



service "mysql" do
        supports :status => true, :restart => true
        action [ :enable, :start ]
end

execute "mysql_pwd" do
        command "/usr/bin/mysqladmin -u root password '#{node['mysql']['root_password']}'"
        action :run
        only_if "mysql -uroot -e 'show databases' |grep mysql"
end



cookbook_file "/etc/apache2/conf.d/phpmyadmin.conf" do
        source "phpmyadmin.conf"
        owner "root"
        group "root"
        mode 0755
        notifies :restart, resources(:service => "apache2"), :immediately
end

