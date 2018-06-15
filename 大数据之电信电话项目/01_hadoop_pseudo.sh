#######################################
#
#	start-dfs.sh | stop-dfs.sh
#         NameNode
#         DataNode
#         SecondaryNameNode
#
#######################################
#
#	start-yarn.sh | stop-yarn.sh
#         ResourceManager
#         NodeManager
#
#######################################


#!/bin/bash
###################### 启动|停止 伪分布式 ######################
##Usage: ./hadoop_pseudo.sh start      ./hadoop_pseudo.sh stop

if [[ $# -lt 1 ]]; then
	echo "No params,Please add one params." ; 
	echo "##Usage: ./hadoop_pseudo.sh start      ./hadoop_pseudo.sh stop" ;
	exit ; 
fi

params=$1
user=`whoami`
hostname=`hostname`

#启动
zookeeper_start1="/bin/bash $HADOOP_HOME/../zookeeper/zookeeper001/bin/zkServer.sh start"
zookeeper_start2="/bin/bash $HADOOP_HOME/../zookeeper/zookeeper002/bin/zkServer.sh start"
zookeeper_start3="/bin/bash $HADOOP_HOME/../zookeeper/zookeeper003/bin/zkServer.sh start"
zookeeper_status1="/bin/bash $HADOOP_HOME/../zookeeper/zookeeper001/bin/zkServer.sh status"
zookeeper_status2="/bin/bash $HADOOP_HOME/../zookeeper/zookeeper002/bin/zkServer.sh status"
zookeeper_status3="/bin/bash $HADOOP_HOME/../zookeeper/zookeeper003/bin/zkServer.sh status"
dfs_start="/bin/bash $HADOOP_HOME/sbin/start-dfs.sh"
YARN_start="/bin/bash $HADOOP_HOME/sbin/start-yarn.sh"
hbase_start="/bin/bash $HBASE_HOME/bin/start-hbase.sh"

#停止
zookeeper_stop1="/bin/bash $HADOOP_HOME/../zookeeper/zookeeper001/bin/zkServer.sh stop"
zookeeper_stop2="/bin/bash $HADOOP_HOME/../zookeeper/zookeeper002/bin/zkServer.sh stop"
zookeeper_stop3="/bin/bash $HADOOP_HOME/../zookeeper/zookeeper003/bin/zkServer.sh stop"
dfs_stop="/bin/bash $HADOOP_HOME/sbin/stop-dfs.sh"
YARN_stop="/bin/bash $HADOOP_HOME/sbin/stop-yarn.sh"
hbase_stop="/bin/bash $HBASE_HOME/bin/stop-hbase.sh"

#jps
jps_start="$JAVA_HOME/bin/jps"

case $params in
	start )
		echo "=================================================| start process : ALL |============================================"
		echo "     NameNode DateNode SecondaryNameNode ResourceManager NodeManager Jps HMaster HRegionServer QuorumPeerMain*3 "
		echo "===================================================================================================================="
		echo "               --------------------------------------启动(伪分布式)--------------------------------------"
		sleep 2s
		ssh ${user}@$hostname $zookeeper_start1
		ssh ${user}@$hostname $zookeeper_start2
		ssh ${user}@$hostname $zookeeper_start3
		# 查看zk状态
		echo ">>>>>>>>>>>>>>> [zookeeper status] <<<<<<<<<<<<<<<"
		sleep 2s
		ssh ${user}@$hostname $zookeeper_status1
		ssh ${user}@$hostname $zookeeper_status2
		ssh ${user}@$hostname $zookeeper_status3
		ssh ${user}@$hostname $dfs_start
		ssh ${user}@$hostname $hbase_start
		ssh ${user}@$hostname $YARN_start
		sleep 2s
		echo ">>>>>>>>>>>>>>> [jps] <<<<<<<<<<<<<<<"
		ssh ${user}@$hostname $jps_start
		;;
	stop )

		echo "=================================================| stop process : ALL |============================================"
		echo "                                                  Jps"
		echo "===================================================================================================================="
		echo "               --------------------------------------停止(伪分布式)--------------------------------------"
		sleep 2s
		ssh ${user}@$hostname $hbase_stop
		sleep 1s
		ssh ${user}@$hostname $dfs_stop
		ssh ${user}@$hostname $YARN_stop
		ssh ${user}@$hostname $zookeeper_stop1
		ssh ${user}@$hostname $zookeeper_stop2
		ssh ${user}@$hostname $zookeeper_stop3
		
		sleep 2s
		echo ">>>>>>>>>>>>>>> [jps] <<<<<<<<<<<<<<<"
		ssh ${user}@$hostname $jps_start
		;;
esac


