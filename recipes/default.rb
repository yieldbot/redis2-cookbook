#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "silverware"
include_recipe "runit"
if node["redis2"]["install_from"] == "package"
  include_recipe "redis2::package"
else
  include_recipe "redis2::source"
end

daemon_user(:redis2) do
  home node[:redis2][:data_dir]
end

volume_dirs('redis2.data') do
  type          :persistent
  selects       :single
  path          "redis/data"
end

standard_dirs(:redis2) do
  directories   :conf_dir, :log_dir, :pid_dir
end
