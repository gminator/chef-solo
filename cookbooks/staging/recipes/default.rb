#
# Cookbook Name:: staging
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


bash "Update Reposiory" do
	only_if "test -d /home/application/public_html/"
	code <<-EOF
		mv /home/application/public_html/config.php /home/application/public_html/
		rm -r /home/application/public_html/
	EOF
end
