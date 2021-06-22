#!/bin/bash

set -ex
set -o pipefail

go_to_build_dir() {
    if [ ! -z $INPUT_SUBDIR ]; then
        cd $INPUT_SUBDIR
    fi
}

check_if_meta_yaml_file_exists() {
    if [ ! -f meta.yaml ]; then
        echo "meta.yaml must exist in the directory that is being packaged and published."
        exit 1
    fi
}

build_package(){
    conda build -c conda-forge -c bioconda --output-folder . .

    if [[ $INPUT_PLATFORMS == *"osx"* ]] && [[ $INPUT_ARCH == *32* ]]; then
    conda convert -p osx-32 linux-64/*.tar.bz2
    fi
    if [[ $INPUT_PLATFORMS == *"win"* ]] && [[ $INPUT_ARCH == *32* ]]; then
    conda convert -p win-32 linux-64/*.tar.bz2
    fi
    if [[ $INPUT_PLATFORMS == *"osx"* ]] && [[ $INPUT_ARCH == *64* ]]; then
    conda convert -p osx-64 linux-64/*.tar.bz2
    fi
    if [[ $INPUT_PLATFORMS == *"win"* ]] && [[ $INPUT_ARCH == *64* ]]; then
    conda convert -p win-64 linux-64/*.tar.bz2
    fi


}

upload_package(){
    export ANACONDA_API_TOKEN=$INPUT_ANACONDATOKEN
    
    if [[ $PLATFORMS == *"osx"* ]] && [[ $INPUT_ARCH == *32* ]]; then
    anaconda upload --label main osx-32/*.tar.bz2
    fi
    if [[ $PLATFORMS == *"linux"* ]] && [[ $INPUT_ARCH == *32* ]]; then
    anaconda upload --label main linux-32/*.tar.bz2
    fi
    if [[ $PLATFORMS == *"win"* ]] && [[ $INPUT_ARCH == *32* ]]; then
    anaconda upload --label main win-32/*.tar.bz2
    fi
    if [[ $PLATFORMS == *"osx"* ]] && [[ $INPUT_ARCH == *64* ]]; then
    anaconda upload --label main osx-64/*.tar.bz2
    fi
    if [[ $PLATFORMS == *"linux"* ]] && [[ $INPUT_ARCH == *64* ]]; then
    anaconda upload --label main linux-64/*.tar.bz2
    fi
    if [[ $PLATFORMS == *"win"* ]] && [[ $INPUT_ARCH == *64* ]]; then
    anaconda upload --label main win-64/*.tar.bz2
    fi
}

go_to_build_dir
check_if_meta_yaml_file_exists
build_package
upload_package
