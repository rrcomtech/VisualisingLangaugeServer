#!/bin/bash

PORT=$1 
LSP_NAME=$2

while [[ ! `lsof -t -i:$PORT` ]]
do 
	sleep 0.5
done

rm -rf xtext-lsp-$LSP_NAME-$PORT