#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


bash "Update Reposiory" do
	code <<-EOF
		wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
		sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
		apt-get update
	EOF
end

packages = [
"jenkins",
"nginx"
]


packages.each do |pack|
	package "#{pack}" do
		action :install
	end
end


cookbook_file "/etc/nginx/sites-available/jenkins" do
        source "jenkins"
        owner "root"
        group "root"
        mode 0755
end

link "/etc/nginx/sites-enabled/jenkins" do
  to "/etc/nginx/sites-available/jenkins"
end
