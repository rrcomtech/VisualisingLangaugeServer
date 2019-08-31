#!/bin/bash
COMMAND_SUPPLEMENT=$1
LANGUAGE_NAME=$2
PORT=$3 

########################################################################
############################## FUNCTIONS ###############################
########################################################################

performTask() {

	BUILD_DIR="LSP_BUILDS"
	buildTask=$1
	languageName=$2

	( 
	flock -e 200
	
		# checkout LSP configuration to be started --- not used currently
		git checkout $languageName
		
		if [ $buildTask == "initialize" ]; then
			build_LSP_binary $BUILD_DIR $languageName
			installLanguageIntoLocalMavenRepo

		elif [ $buildTask == "install" ]; then

			installLanguageIntoLocalMavenRepo

		elif [ $buildTask == "build" ]; then

			build_LSP_binary $BUILD_DIR $languageName
		fi

	) 200>/tmp/$BUILD_DIR.lockfile 

}

build_LSP_binary() {

	# check if LSP has been built in the mean time
	if [ ! -d "$BUILD_DIR/$languageName" ]; then

		# create build directory if necessary
		if [ ! -d "$BUILD_DIR" ]; then
			mkdir $BUILD_DIR;
		fi	

		BUILD_DIR=$1
		languageName=$2

		# build it
		./gradlew distZip
		# cp build to LSP_BUILDS folder
		cp `find . -name "*ide*zip"` $BUILD_DIR
		# 
		cd $BUILD_DIR
		# extract it
		unzip -o *.zip -d $languageName
		# clean up
		rm *.zip
		# leave
		cd ..
		#
	fi
}


installLanguageIntoLocalMavenRepo() {

	# instal it
	./gradlew clean install
	# clean up
	#cd ~/.m2/repository/de/btu/sst/swt/xtextLsp/
	# 
}

########################################################################
################################ SCRIPT ################################
########################################################################

## --- if kill is specified, kill a concrete instance
if [[ $1 == "kill" ]]; then
	if [[ `screen -ls | grep -e LSP-$LANGUAGE_NAME-$PORT` ]]; then 
		screen -ls | grep -e LSP-$LANGUAGE_NAME-$PORT | cut -d. -f1 | awk '{print $1}' | xargs kill -9;
		screen -wipe
	fi
## --- if killAll is specified, kill all LSP instances
elif [[ $1 == "killAll" ]]; then
	if [[ `screen -ls | grep -e LSP-` ]]; then 
		screen -ls | grep -e LSP- | cut -d. -f1 | awk '{print $1}' | xargs kill -9;
		screen -wipe
	fi
## --- if killAll-FromLanguage is specified, kill all LSP instances running that language
elif [[ $1 == "killAll-FromLanguage" ]]; then

	if [[ `screen -ls | grep -e LSP-$LANGUAGE_NAME-` ]]; then 
		screen -ls | grep -e LSP-$LANGUAGE_NAME- | cut -d. -f1 | awk '{print $1}' | xargs kill -9;
		screen -wipe
	fi
# otherwise start an LSP instance accordingly
elif [[ $1 == "start" ]]; then

	# # check if the requested LSP needs to be built first
	# if [ ! -d "LSP_BUILDS/$LANGUAGE_NAME" ]; then
	# 	# build the LSP code first
	# 	( 
	# 	flock -e 200
	# 	# check if LSP has been built in the mean time
	# 	if [ ! -d "LSP_BUILDS/$LANGUAGE_NAME" ]; then
	# 		# create build directory if necessary
	# 		if [ ! -d "LSP_BUILDS" ]; then
	# 			mkdir LSP_BUILDS;
	# 		fi
	# 		# checkout LSP configuration to be started --- not used currently
	# 		git checkout $LANGUAGE_NAME
	# 		# build it
	# 		./gradlew distZip
	# 		# cp build to LSP_BUILDS folder
	# 		cp `find . -name "*ide*zip"` LSP_BUILDS
	# 		# 
	# 		cd LSP_BUILDS
	# 		# extract it
	# 		unzip -o *.zip -d $LANGUAGE_NAME
	# 		# clean up
	# 		rm *.zip
	# 		# leave
	# 		cd ..
	# 		#
	# 	fi
	# 	) 200>/tmp/LSP_BUILDER.lockfile 

	# fi

	performTask build $LANGUAGE_NAME

	# create a copy of the necessary files
	#mkdir xtext-lsp-$LANGUAGE_NAME-$PORT 
	
	# get an exclusive lock for copying the necessary files	
	#flock -e LSP_BUILDS/$LANGUAGE_NAME -c "bash copyLSP-folder.sh $LANGUAGE_NAME $PORT"

	# change into build dir of the language 
	# cd $LSP_BUILDS/$LANGUAGE_NAME-$PORT
	# change to containing bin dir
	#cd `find . -type d -name "bin" | grep $LANGUAGE_NAME-$PORT`
	#echo $PORT > .lsp_portConfiguration
	
	# # checkout LSP configuration to be started --- not used currently
	# # git checkout $LANGUAGE_NAME

	# # place PORT into config file
	# # echo $PORT > org.xtext.example.mydsl.ide/.lsp_portConfiguration

	# # start LSP in screen
	cd `find . -type d -name "bin" | grep LSP_BUILDS/$LANGUAGE_NAME`
	screen -dmS LSP-$LANGUAGE_NAME-$PORT bash -c "./mydsl-socket $PORT"

	# # go back to root folder 
	projectRoot=`pwd | awk -v rootFolder="LSP_BUILDS" '{print substr($_,0,index($_,rootFolder)-1)}'`
	# echo "changing back to $projectRoot"
	cd $projectRoot
	# start cleanup script, that will erase the folder specific to that lsp instance after it is finished / killed 
	#screen -dmS LSP_CLEANUP_$PORT bash -c "bash -x cleanup-LSP.sh $LANGUAGE_NAME $PORT"
    
# for all available languages (equiv. to all branches but master and dev) build the 
# LSP wrapper binaries and install the language build into the local repository
elif [[ $1 == "init" ]]; then

	availableBranches=`git branch > tmp.txt`
	availableBranches=`cat tmp.txt | grep -v develop | grep -v master`

	for currLang in $availableBranches; do 
		performTask initialize $currLang
	done

#		performTask initialize $currLang

# otherwise
else
	echo "Unknown command - please retry"
fi


# USAGE EXAMPLES

### start an LSP on port "4400" with language "grammar_MDR" 

# bash manage_LSP_instance.sh start grammar_MDR 4400

### kill all a specific LSP instance running the "grammar_MDR" on port 4400

# bash manage_LSP_instance.sh kill grammar_MDR 4400

### kill all LSP instances

# bash manage_LSP_instance.sh killAll 

### kill all LSP instances running the "grammar_MDR" language

# bash manage_LSP_instance.sh killAll-FromLanguage grammar_MDR

### initialize all languages

# bash manage_LSP_instance.sh init 