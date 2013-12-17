# This recipe is for compiling redis from source.
#
#
node.default["redis2"]["daemon"] = "/usr/local/bin/redis-server"
directory node["redis2"]["build_dir"] do
  owner node["redis2"]["build_user"]
  mode "0755"
  recursive true
end

remote_file ::File.join(node["redis2"]["build_dir"], ::File.basename(node["redis2"]["source_url"])) do
  source node["redis2"]["source_url"]
  checksum node["redis2"]["source_checksum"] if node["redis2"]["source_checksum"]
  mode "0644"
end

url = node["redis2"]["source_url"]
tarball = url.split("?").first.split("/").last
script "unpack and make redis" do
  cwd node["redis2"]["build_dir"]
  code <<EOS
  wget -O #{tarball} #{url}
  tar -xzf #{tarball}
  cd #{tarball.sub('.tar.gz','')}
  make
  make install
EOS
  interpreter "bash"
  creates node["redis2"]["daemon"]
end

