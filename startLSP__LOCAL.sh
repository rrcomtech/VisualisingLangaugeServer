#!/bin/bash

PORT=$1 
LSP_NAME=$2
COMMAND_SUPPLEMENT=$3

## --- if COMMAND_SUPPLEMENT is specified, kill LSPs accordingly
if [[ $# -eq 3 ]]; then

	if [[ $3 == "kill" ]]; then
		if [[ `screen -ls | grep -e LSP-$LSP_NAME-$PORT` ]]; then 
			screen -ls | grep -e LSP-$LSP_NAME-$PORT | cut -d. -f1 | awk '{print $1}' | xargs kill;
		fi
	elif [[ $3 == "killAll-FromLanguage" ]]; then
		if [[ `screen -ls | grep -e LSP-$LSP_NAME-` ]]; then 
			screen -ls | grep -e LSP-$LSP_NAME- | cut -d. -f1 | awk '{print $1}' | xargs kill;
		fi
	elif [[ $3 == "killAll" ]]; then
		if [[ `screen -ls | grep -e LSP-` ]]; then 
			screen -ls | grep -e LSP- | cut -d. -f1 | awk '{print $1}' | xargs kill;
		fi
	fi
# otherwise start LSP accordingly
else
	# unzip xtext lsp git project 

	# if [ ! -d "xtext-lsp" ]; then
	# 	unzip xtext-lsp-git-project.zip -d xtext-lsp
	# fi

	# # change dir into xtext project 
	# cd xtext-lsp

	# checkout LSP configuration to be started --- not used currently
	git checkout $LSP_NAME

	# place PORT into xtext files
	src=./org.xtext.example.mydsl.websockets/src/org/xtext/example/mydsl/websockets/RunWebSocketServer.template;
	destination=./org.xtext.example.mydsl.websockets/src/org/xtext/example/mydsl/websockets/RunWebSocketServer.xtend;

	sed "s/<PORT>/$PORT/g" $src > $destination;

	# start LSP in screen
	screen -dmS LSP-$LSP_NAME-$PORT bash -c "./gradlew clean run"

fi

# EXAMPLES

### start an LSP on port "4400" with language "grammar_MDR" 

# bash startLSP.sh 4400 grammar_MDR 

### kill all LSP instances

# bash startLSP.sh X X killAll 

### kill all LSP instances running the "grammar_MDR" language

# bash startLSP.sh X grammar_MDR killAll-FromLanguage 

### kill all a specific LSP instance running the "grammar_MDR" on port 4400

# bash startLSP.sh 4400 grammar_MDR killAll-FromLanguage 