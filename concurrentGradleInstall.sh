BUILD_DIR=$1
languageName=$2
version=$3

# instal it
mkdir ../___$languageName-$version
rsync -aP --exclude=$BUILD_DIR * ../___$languageName-$version
cd ../___$languageName-$version
./gradlew install
cd -
rm -rf ../___$languageName-$version
# 