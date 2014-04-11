#
# Cookbook Name:: jenkins-client
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

packages = [
"openjdk-6-jre", "screen"
]


packages.each do |pack|
        package "#{pack}" do
                action :install
        end
end

cookbook_file "/home/application/slave.jar" do
        source "slave.jar"
        owner "root"
        group "root"
        mode 0755
end

bash "Start Jenkins Slave Node" do
	  code <<-EOH
		killall java
		su -l application -c 'cd ~/ && java -jar slave.jar -jnlpUrl http://#{node['jenkins']}:8080/computer/Staging%20Node%201/slave-agent.jnlp > /dev/null 2>&1 &'
	EOH
end


