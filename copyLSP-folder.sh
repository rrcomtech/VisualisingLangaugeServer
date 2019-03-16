#!/bin/bash

PORT=$1 
LSP_NAME=$2

cp -r `ls -A | grep -v xtext-lsp` ../xtext-lsp-$LSP_NAME-$PORT