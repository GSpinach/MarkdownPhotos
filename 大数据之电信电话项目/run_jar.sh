#!/bin/bash
##Usage:./run_jar.sh [输出log路径] 

if [[ $# -lt 2 ]]; then
	echo "No params, Please enter the output path to the first parameter." ; 
	echo "##Usage:./run_jar.sh [jar包路径] [输出log路径] " ;
	exit ; 
fi

params=$1
path=$2

#java -cp $params $path
java -jar $params $path
