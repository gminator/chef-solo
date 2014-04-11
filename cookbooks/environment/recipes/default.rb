#
# Cookbook Name:: environment
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
user "application" do
	action :create
	supports :manage_home => true
	shell "/bin/bash"
end


Dirs = [
	"/home/application",
	"/home/application/public_html/",
	"/home/application/logs/",
	"/home/application/.ssh",
]

Dirs.each do |mydir|
	directory "#{mydir}" do
		action :create
		owner "application"
		group "application"
		mode 0755
		recursive true
	end
end	



cookbook_file "/home/application/.ssh/id_rsa" do
  source "id_rsa"
  mode "0700"
  owner "application"
  group "application"
end

cookbook_file "/etc/ssh/ssh_config" do
  source "ssh_config"
  mode "0775"
  owner "root"
  group "root"
end



cookbook_file "/etc/apache2/sites-enabled/000-default" do
	source "000-default"
	mode "0775"
	notifies :restart, resources(:service => "apache2"), :immediately
end



template "/home/application/database.sql" do
        source "database.sql"
        mode "0775"
	variables({
                :database => "#{node['mysql']['database']}"
        })
end



bash "Create Data Base" do
        not_if "test -d /var/lib/mysql/#{node['mysql']['database']}"
        cwd "/home/application/"
        user "application"
        code <<-EOF
		mysql -u root -p#{node['mysql']['root_password']} < /home/application/database.sql
        EOF
end



template "/etc/php5/apache2/php.ini" do
        source "php.ini"
        owner "root"
        group "root"
        mode 0755
	variables({
                :error_reporting => "#{node['php']['error']}"
        })

	notifies :restart, resources(:service => "apache2"), :immediately
end

template "/etc/php5/cli/php.ini" do
        source "php.ini"
        owner "root"
        group "root"
        mode 0755
	variables({
                :error_reporting => "On"
        })
        notifies :restart, resources(:service => "apache2"), :immediately
end



