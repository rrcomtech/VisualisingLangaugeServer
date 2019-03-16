#!/bin/bash

PORT=$1 
LSP_NAME=$2

while [[ `screen -ls | grep -e LSP-$LSP_NAME-$PORT` ]] && [[ ! `lsof -t -i:$PORT` ]]
do 
	sleep 1
done

rm -rf xtext-lsp-$LSP_NAME-$PORT

# wait until LSP is finished

while [[ `lsof -t -i:$PORT` ]]
do 
	sleep 10
done

# if the LSP has been killed, there folder should be restored with files -> delete it

if [ ! -d "xtext-lsp-$LSP_NAME-$PORT" ]; then

	rm -rf xtext-lsp-$LSP_NAME-$PORT

fi