#
# Cookbook Name:: timezone-ii
# Recipe:: CentOS 6/RHEL 6/<etc RHEL 6 based distribs>
#
# Copyright 2013, fraD00r4 <frad00r4@gmail.com>
#
# Apache 2.0 License.
#

major_version = node['platform_version'].split('.').first.to_i

template "/etc/sysconfig/clock" do
  source "clock.erb"
  owner 'root'
  group 'root'
  mode 0644
  notifies(:run, 'bash[tzdata-update]') unless major_version == 7
  notifies(:create, 'link[localtime]') if major_version == 7
end

link "localtime" do
  owner 'root'
  target_file '/etc/localtime'
  to "/usr/share/zoneinfo/#{node[:tz]}"
  action :nothing
end

bash 'tzdata-update' do
  user 'root'
  code "/usr/sbin/tzdata-update"
  action :nothing
end
