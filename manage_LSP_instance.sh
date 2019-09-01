#!/bin/bash
command=$1
languageName=$2
commandParam=$3 

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
			# concurrentInstallIntoLocalMavenRepo $languageName $BUILD_DIR

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

concurrentInstallIntoLocalMavenRepo() {

	languageName=$1
	BUILD_DIR=$2


	screen -dmS concurrentInstall-$languageName bash -c "bash -x concurrentGradleInstall.sh $languageName $BUILD_DIR"			
	# instal it
	# mkdir ../___$languageName
	# rsync -aP --exclude=$BUILD_DIR * ../___$languageName
	# cd ../___$languageName
	# ./gradlew install
	# cd -
	# rm -rf ../___$languageName
	# 
}

installLanguageIntoLocalMavenRepo() {

	# instal it
	./gradlew install
	# clean up
	#cd ~/.m2/repository/de/btu/sst/swt/xtextLsp/
	# 
}

########################################################################
################################ SCRIPT ################################
########################################################################


#----------------------------------------------------------------------
#------------------------------- INIT ---------------------------------
#----------------------------------------------------------------------
    
# for all available languages (equiv. to all branches but master and dev) build the 
# LSP wrapper binaries and install the language build into the local repository
if [[ $command == "init" ]]; then

	git branch > tmp.txt
	availableBranches=`cat tmp.txt | grep -v develop | grep -v master`
	# remove asteriks of current branch
	availableBranches=${availableBranches//"*"/" "}  

	for currLang in $availableBranches; do 
		performTask initialize $currLang
	done

	rm tmp.txt

#----------------------------------------------------------------------
#------------------------------- START --------------------------------
#----------------------------------------------------------------------

# otherwise start an LSP instance accordingly
elif [[ $command == "start" ]]; then

	performTask build $languageName

	# start LSP in screen
	cd `find . -type d -name "bin" | grep LSP_BUILDS/$languageName`
	screen -dmS LSP-$languageName-$commandParam bash -c "./mydsl-socket $commandParam"

	# go back to root folder 
	# projectRoot=`pwd | awk -v rootFolder="LSP_BUILDS" '{print substr($_,0,index($_,rootFolder)-1)}'`
	# echo "changing back to $projectRoot"
	# cd $projectRoot

#----------------------------------------------------------------------
#-------------------------------- KILL --------------------------------
#----------------------------------------------------------------------

## --- if kill is specified, kill a concrete instance
elif [[ $command == "kill" ]]; then
	if [[ `screen -ls | grep -e LSP-$languageName-$commandParam` ]]; then 
		screen -ls | grep -e LSP-$languageName-$commandParam | cut -d. -f1 | awk '{print $1}' | xargs kill -9;
		screen -wipe
	fi
## --- if killAll is specified, kill all LSP instances
elif [[ $command == "killAll" ]]; then
	if [[ `screen -ls | grep -e LSP-` ]]; then 
		screen -ls | grep -e LSP- | cut -d. -f1 | awk '{print $1}' | xargs kill -9;
		screen -wipe
	fi
## --- if killAll-FromLanguage is specified, kill all LSP instances running that language
elif [[ $command == "killAll-FromLanguage" ]]; then

	if [[ `screen -ls | grep -e LSP-$languageName-` ]]; then 
		screen -ls | grep -e LSP-$languageName- | cut -d. -f1 | awk '{print $1}' | xargs kill -9;
		screen -wipe
	fi

#----------------------------------------------------------------------
#---------------------- CREATE NEW LSP PROJECT ------------------------
#----------------------------------------------------------------------

## will create a copy of an LSP project in order to start with an git example project
elif [[ $command == "createNewLSP" ]]; then

	# briefly lock lock the folder
	( 
	flock -e 200

		git checkout templateLang		
		# last slash is important, otherwise it will not be interpreted as a folder
		git checkout-index -a -f --prefix=tmpLang-$languageName-$commandParam/

	) 200>/tmp/$BUILD_DIR.lockfile 

	# fix build configuration
	# adapt name configuration
	gradleConfig=`cat settings.gradle | head -3`
	echo $gradleConfig > settings.gradle
	echo "rootProject.name = '$languageName'" > settings.gradle
	# adapt version configuration
	echo "version = $commandParam" > gradle.properties

#----------------------------------------------------------------------
#------------------------------- ELSE ---------------------------------
#----------------------------------------------------------------------

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