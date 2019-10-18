#!/bin/bash --login

# 先创建docker容器: docker run -itd -v $PWD/oracle11g:/instfile:rw --name oracle11gr2 -P centos:centos7 /usr/sbin/init

# 安装依赖包
yum -y install gcc* glibc* libnsl gcc make binutils gcc-c++ libstdc* elfutils-* ksh libaio libaio-devel numactl-devel sysstat unixODBC unixODBC-devel pcre-devel net-tools unzip vim

mkdir /opt/oracle
cd /opt/oracle

# 解决oracle11g的安装包
unzip /instfile/linux.x64_11gR2_database_1of2.zip && unzip /instfile/linux.x64_11gR2_database_2of2.zip

# 创建oracle用户与oinstall,dba组
groupadd dba
groupadd oinstall
useradd -g dba oracle
usermod -aG oinstall oracle

# 创建目录
mkdir /opt/oracle/inventory /opt/oracle/product

# 创建目录权限
chown -R oracle.dba /opt/oracle/inventory /opt/oracle/product
chown -R oracle.oinstall /opt/oracle/database
chmod -R 755 /opt/oracle

# 设置oracle用户环境变量
cat - >> /home/oracle/.bash_profile << !
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/db1
export ORACLE_SID=orcl
export ORACLE_UNQNAME=orcl
export PATH=\$PATH:\$ORACLE_HOME/bin
!

cp oracle-st*.sh /usr/local/sbin/
chmod +x /usr/local/sbin/oracle-st*.sh

echo "根据INSTALL.md中的说明，你自己操作执行第9、10、12和14步。"
echo "。。。"
echo "之后就可以使用 oracle-start.sh 和 oracle-stop.sh 脚本进行启动监听与数据库实例了。"
echo "注意以上两个脚本已经放到环境变量中，无需再复制或添加环境变量！！！"

# \cp /instfile/oracle11g/*.rsp /opt/oracle/database/response/

# su - oracle /opt/oracle/database/runInstaller -ignoreSysPrereqs -ignorePrereq -silent -responseFile /opt/oracle/database/response/db_install.rsp
# su - oracle netca /silent /responsefile /opt/oracle/database/response/netca.rsp
# su - oracle dbca -silent -responseFile /opt/oracle/database/response/dbca.rsp






