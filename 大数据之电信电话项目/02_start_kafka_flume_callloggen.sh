#!/bin/bash
##Usage:./start_kafka_flum_callloggen.sh [1 start_kafka | 2 kafka-console-consumer | 3 flume | 4 run_jar | clean remove_CallLog.log_file | 11 stop_kafka]



if [[ $# -lt 1 ]]; then
	echo "No params,Please add one params. [1 start_kafka | 2 kafka-console-consumer | 3 flume | 4 run_jar | clean remove_CallLog.log_file | 11 stop_kafka]" ; 
	echo "##Usage:./start_kafka_flum_callloggen.sh [1 | 2 | 3 | 4 | clean | 11]" ;
	echo ""
	exit ; 
fi

params=$1

case $params in
	1 )
	# 启动kafka
	kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties

	# 创建主题CallLog
	# kafka-topics.sh --zookeeper localhost:2181 --topic CallLog --create --replication-factor 1 --partitions 1

	# 查看主题列表
	# kafka-topics.sh --zookeeper localhost:2181 --list
	;;
	2 )
	# 启动控制台消费者,消费CallLog主题,用于测试
	kafka-console-consumer.sh --zookeeper localhost:2181 --topic CallLog
	;;
	3 )
	# 启动flume
	flume-ng agent -f $FLUME_HOME/example/CallLog.conf -n a1 &
	;;
	4 )
	# 运行jar包
	java -jar $HADOOP_HOME/../Call/CallLogGenSystem.jar $HADOOP_HOME/../Call/CallLog.log
	;;
	clean )
	# 删除log文件
	rm -fr $HADOOP_HOME/../Call/CallLog.log
	;;
	11 )
	kafka-server-stop.sh
	;;
esac







