# Oracle 11g R2 Database Server

### 1. Oracle配置：
  * PORT: 1521
  * SID: orcl
  * USER: system,sys,sysman
  * PASS: oracle

### 2. 创建docker镜像并运行，容器名为oracle11g
  * docker run -itd -p 1521:1521 --name oracle11g --privileged talent518/oracle11g /usr/sbin/init

### 3. 启动监听与数据库实例
  * 修复主机名：sed -i 's|83126d1c1ade|'\`hostname\`'|g' /opt/oracle/product/11.2.0/db1/network/admin/*.ora
  * 启动监听，在oracle用户下执行命令：lsnrctl start
  * 启动数据库实例，在oracle用户下执行如下命令：
```shell
sqlplus / as sysdba <<!
startup
exit
!
```

### 4. 以root进行docker容器命令行
  * docker exec -it oracle bash -l

### 5. 默认以oracle进行docker容器命令行
  * docker exec -it -u oracle oracle11g bash -l
