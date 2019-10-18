# Oracle 11g R2 安装说明

### 注意：可以在docker容器中执行 install.sh 脚本，可以省去除第9、10、12和14以外的步骤！！！

1. 创建docker容器oracle11g并运行，**注意：不要用最新centos8版本，会安装失败的**
```shell
docker run -itd -v ~/oracle11g:/instfile:rw --name oracle11g -p 1521:1521 --privileged centos:centos7 /usr/sbin/init
```

2. 进入oracle11g窗口命令行
```shell
docker exec -it oracle11g bash
```

3. 在第2步运行的命令行中执行如下命令进行安装依赖包，之后的命令者如此执行
```shell
yum -y install gcc* glibc* libnsl
yum -y install gcc make binutils gcc-c++ libstdc* elfutils-* ksh libaio libaio-devel numactl-devel sysstat unixODBC unixODBC-devel pcre-devel net-tools
yum -y install unzip vim
```

4. 创建用户与组
```shell
groupadd dba
groupadd oinstall
useradd -g dba oracle
usermod -aG oinstall oracle
```

5. 创建目录
```shell
mkdir -p /opt/oracle/database /opt/oracle/inventory /opt/oracle/product
```

6. 解压oracle11g的zip安装包到/opt/oracle，[下载地址](https://www.oracle.com/database/technologies/112010-linuxsoft.html)
```shell
unzip /instfile/linux.x64_11gR2_database_1of2.zip -d /opt/oracle
unzip /instfile/linux.x64_11gR2_database_2of2.zip -d /opt/oracle
chown -R oracle.dba /opt/oracle/inventory /opt/oracle/product
chown -R oracle.oinstall /opt/oracle/database
chmod -R 755 /opt/oracle
```

7. 设置环境变量：~/.bash_profile
```shell
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=$ORACLE_BASE/product/11.2.0/db1
export ORACLE_SID=orcl
export ORACLE_UNQNAME=orcl
export PATH=$PATH:$ORACLE_HOME/bin
```

8. 配置响应文件：/opt/oracle/database/response/db_install.rsp
  * oracle.install.option=INSTALL_DB_SWONLY		# 只装数据库软件
  * ORACLE_HOSTNAME=47ce51d8869d			# 指定操作系统主机名
  * SELECTED_LANGUAGES=en,zh_CN			# 指定数据库语言，可以选择多个，用逗号隔开。选择en, zh_CN(英文和简体中文)
  * ORACLE_HOME=/opt/oracle/product/11.2.0/db1	# 设置ORALCE_HOME的路径
  * ORACLE_BASE=/opt/oracle				# 设置ORALCE_BASE的路径
  * oracle.install.db.InstallEdition=EE		# 选择Oracle安装数据库软件的版本（企业版，标准版，标准版1），不同的版本功能不同
  * oracle.install.db.isCustomInstall=true		# 1. 是否自定义Oracle的组件，如果选择false，则会使用默认的组件；2. 如果选择true否则需要自己在下面一条参数将要安装的组件一一列出；3. 安装相应版权后会安装所有的组件，后期如果缺乏某个组件，再次安装会非常的麻烦。
  * oracle.install.db.DBA_GROUP=dba			# 指定拥有OSDBA、OSOPER权限的用户组，通常会是dba组
oracle.install.db.OPER_GROUP=dba
  * oracle.install.db.config.starterdb.type=GENERAL_PURPOSE		# 选择数据库的用途，一般用途/事物处理，数据仓库
  * oracle.install.db.config.starterdb.globalDBName=orcl		# 指定GlobalName
oracle.install.db.config.starterdb.SID=orcl
  * oracle.install.db.config.starterdb.characterSet=AL32UTF8	# 选择字符集。不正确的字符集会给数据显示和存储带来麻烦无数。通常中文选择的有ZHS16GBK简体中文库，建议选择unicode的AL32UTF8国际字符集
  * oracle.install.db.config.starterdb.memoryOption=true		# 11g的新特性自动内存管理，也就是SGA_TARGET和PAG_AGGREGATE_TARGET都#不用设置了，Oracle会自动调配两部分大小
  * oracle.install.db.config.starterdb.memoryLimit=512		# 指定Oracle自动管理内存的大小，最小是256MB
  * oracle.install.db.config.starterdb.installExampleSchemas=false	# 是否载入模板示例
  * oracle.install.db.config.starterdb.enableSecuritySettings=true	# 是否启用安全设置
  * oracle.install.db.config.starterdb.password.ALL=oracle		# 设定所有数据库用户使用同一个密码，其它数据库用户就不用单独设置了。
  * oracle.install.db.config.starterdb.control=DB_CONTROL		# 数据库本地管理工具DB_CONTROL，远程集中管理工具GRID_CONTROL
  * oracle.install.db.config.starterdb.gridcontrol.gridControlServiceURL=		# GRID_CONTROL需要设定grid control的远程路径URL
  * oracle.install.db.config.starterdb.dbcontrol.enableEmailNotification=false	# 是否启用Email通知, 启用后会将告警等信息发送到指定邮箱
  * oracle.install.db.config.starterdb.dbcontrol.emailAddress=	# 设置通知EMAIL地址
oracle.install.db.config.starterdb.dbcontrol.SMTPServer=
  * oracle.install.db.config.starterdb.automatedBackup.enable=false	# 设置自动备份，和OUI里的自动备份一样。
  * oracle.install.db.config.starterdb.automatedBackup.osuid=	# 自动备份会启动一个job，指定启动JOB的系统用户ID
  * oracle.install.db.config.starterdb.automatedBackup.ospwd=	# 自动备份会开启一个job，需要指定OSUser的密码
  * oracle.install.db.config.starterdb.storageType=			# 自动备份，要求指定使用的文件系统存放数据库文件还是ASM
  * oracle.install.db.config.starterdb.fileSystemStorage.dataLocation=	# 使用文件系统存放数据库文件才需要指定数据文件、控制文件、Redo log的存放目录
  * oracle.install.db.config.starterdb.fileSystemStorage.recoveryLocation=	# 使用文件系统存放数据库文件才需要指定备份恢复目录
  * oracle.install.db.config.asm.diskGroup=					# 使用ASM存放数据库文件才需要指定存放的磁盘组
  * oracle.install.db.config.asm.ASMSNMPPassword=				# 使用ASM存放数据库文件才需要指定ASM实例密码
  * MYORACLESUPPORT_USERNAME=		# 指定metalink账户用户名
  * MYORACLESUPPORT_PASSWORD=		# 指定metalink账户密码
  * SECURITY_UPDATES_VIA_MYORACLESUPPORT=	# 用户是否可以设置metalink密码
  * DECLINE_SECURITY_UPDATES=true		# 1. False表示不需要设置安全更新，注意：在11.2的静默安装中疑似有一个BUG；2. Response File中必须指定为true，否则会提示错误,不管是否正确填写了邮件地址；3. 这里必须为 true 否则会失败

9. 在oracle用户下执行如下安装命令
```shell
/opt/oracle/database/runInstaller -ignoreSysPrereqs -ignorePrereq -silent -responseFile /opt/oracle/database/response/db_install.rsp
```

10. 慢慢等待，直到输出如“4. Return to this window and hit "Enter" key to continue”这个的信息，在root用户下执行接下来的命令
```shell
/opt/oracle/inventory/orainstRoot.sh
/opt/oracle/product/11.2.0/db1/root.sh
```

11. 另外开一个docker窗口执行如下命令，监控安装日志，监控的文件是第9步中输出的信息中的
```shell
tail -f /opt/oracle/inventory/logs/installActions2019-10-10_07-37-03AM.log
```

12. 安装listener，在oracle用户下执行如下命令
```shell
netca /silent /responsefile /opt/oracle/database/response/netca.rsp
```

13. 配置静默配置文件：/opt/oracle/database/response/dbca.rsp
  * RESPONSEFILE_VERSION = "11.2.0"		# 不能更改
OPERATION_TYPE = "createDatabase"
  * GDBNAME = "orcl"			# 数据库的名字
  * SID = "orcl"				# 对应的实例名字
  * TEMPLATENAME = "General_Purpose.dbc"	# 建库用的模板文件
  * SYSPASSWORD = "oracle"			# SYS管理员密码
  * SYSTEMPASSWORD = "oracle"		# SYSTEM管理员密码
  * DATAFILEDESTINATION =			# 数据文件存放目录 默认为 $ORACLE_BASE/oradata
  * RECOVERYAREADESTINATION=		# 恢复数据存放目录 默认为$ORACLE_BASE/flash_recovery_area
  * CHARACTERSET = "UTF8"			# 字符集，重要!!! 建库后一般不能更改，所以建库前要确定清楚。
  * TOTALMEMORY = "5120"			# oracle内存5120MB

14. 创建数据库和实例，在oracle用户下执行如下命令
```shell
dbca -silent -responseFile /opt/oracle/database/response/dbca.rsp
```
