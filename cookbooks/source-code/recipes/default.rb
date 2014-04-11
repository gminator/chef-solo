#
# Cookbook Name:: source-code
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "Checkout Code" do
	not_if "test -d /home/application/public_html/.git/"
        cwd "/home/application/public_html/"
        user "application"
        code <<-EOF
          git clone git@github.com:gminator/gitflowdemo.git .
	  git flow init -fd
        EOF
end




link "/home/application/public_html/config.php" do
  to "/home/application/config.php"
end


