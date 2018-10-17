#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
include_recipe 'java'

tmp_path = Chef::Config[:file_cache_path]
remote_file "#{tmp_path}/tomcat8.tar.gz" do
  source node['tomcat8']['download_url']
  owner node['tomcat8']['tomcat_user']
  mode '0644'
  action :create
end
directory node['tomcat8']['install_location'] do
  owner node['tomcat8']['tomcat_user']
  mode '0755'
  action :create
end
bash 'Extract tomcat archive' do
  user node['tomcat8']['tomcat_user']
  cwd node['tomcat8']['install_location']
  code <<-EOH
    tar -zxvf #{tmp_path}/tomcat8.tar.gz --strip 1
    rm -rf /var/tomcat8/webapps/*
  EOH
  action :run
end
remote_file "/var/tomcat8/webapps/student.war" do
  source "https://github.com/devops2k18/DevOpsDecember/raw/master/APPSTACK/student.war"
  owner node['tomcat8']['tomcat_user']
  mode '0644'
  action :create
end
remote_file "/var/tomcat8/lib/mysql-connector-java-5.1.40.jar" do
  source "https://github.com/devops2k18/DevOpsDecember/raw/master/APPSTACK/mysql-connector-java-5.1.40.jar"
  owner node['tomcat8']['tomcat_user']
  mode '0644'
  action :create
end
template "/etc/init.d/tomcat8" do
  source 'tomcat.erb'
  owner 'root'
  mode '0755'
end
service 'tomcat8' do
  action [:enable, :start]
  only_if { node['tomcat8']['autostart'] }
end
execute 'start_tomcat' do
  command 'sh /var/tomcat8/bin/startup.sh'
end
cookbook_file '/var/tomcat8/conf/context.xml' do
  source 'context.xml'
  owner node['tomcat8']['tomcat_user']
  mode '0644'
  action :create
end
