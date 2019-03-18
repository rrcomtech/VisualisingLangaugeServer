#!/bin/bash

count=$1
initialPort=$2

for ((currCount=1; currCount <= $count; currCount++)) {

	if [ $# -eq 2 ]; then
		let port=$currCount+$initialPort;
	else
		let port=$currCount+4000;
	fi
	#echo $port
	bash -x manage_LSP_instance.sh start grammar_MDR $port
}
