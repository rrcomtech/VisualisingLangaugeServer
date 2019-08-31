languageName=$1
BUILD_DIR=$2

# instal it
mkdir ../___$languageName
rsync -aP --exclude=$BUILD_DIR * ../___$languageName
cd ../___$languageName
./gradlew install
cd -
rm -rf ../___$languageName
# 