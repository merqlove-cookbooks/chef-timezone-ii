#
# Cookbook Name:: timezone-ii
# Recipe:: rhel
#
# Copyright 2013, fraD00r4 <frad00r4@gmail.com>
# Copyright 2015, Lawrence Leonard Gilbert <larry@L2G.to>
#
# Apache 2.0 License.
#

el_version = node['platform_version'].split('.').first.to_i

template "/etc/sysconfig/clock" do
  source "clock.erb"
  owner 'root'
  group 'root'
  mode 0644
  notifies(:run, 'execute[tzdata-update]') unless el_version == 7
  notifies(:create, 'link[localtime]') if el_version == 7
end

link "localtime" do
  owner 'root'
  target_file '/etc/localtime'
  to "/usr/share/zoneinfo/#{node['tz']}"
  action :nothing
end

execute 'tzdata-update' do
  command '/usr/sbin/tzdata-update'
  action :nothing
  # Amazon Linux doesn't have this command!
  only_if { ::File.executable?('/usr/sbin/tzdata-update') }
end
