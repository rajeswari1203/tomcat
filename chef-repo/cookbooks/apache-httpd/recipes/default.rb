remote_file "/home/user/tomcat.tar.gz" do
   source "http://mirrors.fibergrid.in/apache/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34.tar.gz"
end
package '/home/user/tomcat.tar.gz' do
  action :install
end
