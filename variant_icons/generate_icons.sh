#!/bin/bash
normal=$(tput sgr0)
red=$(tput setaf 1)

FIND="find"
if [[ ! -z `which gfind` ]]; then
    FIND=`gfind`
fi

if [[ -z `which magick` ]]; then
    echo "Installing Image Magick"
    if [[ "`uname -s`" == "Darwin" ]]; then
        brew install imagemagick
    else
        pacman -S imagemagick
    fi
    if [[ $? != 0 ]]; then
        echo "${red}Unable to install image magick, Exiting.${normal}"
        exit $?
    fi
fi

if [[ "$1" == "-c" ]];then 
    rm -fr output/*
    for i in `ls switch/ic_app_icon/res/`;do mkdir output/$i;done
fi

paths=(
    "drawable-xxxhdpi"
    "drawable-xxhdpi" 
    "drawable-xhdpi" 
    "drawable-hdpi" 
    "drawable-mdpi" 
)
sizes=(
    "192"
    "144" 
    "96" 
    "72" 
    "48" 
)
for (( i=0; i<${#paths[@]}; i++ )); do
    for input in `$FIND . -name "*ic_launcher*" |grep -E "/.*"`;do 
        outputPath="../NvidiaShieldTVController/app/src/main/res/${paths[$i]}/"
        output=$(echo $input |awk -v path=$outputPath -F "/" '{print path$2"_"$3}';)
        magick $input -resize ${sizes[$i]} $output
    done
done

paths=(
    "drawable-xxxhdpi"
    "drawable-xxhdpi" 
    "drawable-xhdpi" 
)
sizes=(
    "1280x720"
    "640x360" 
    "320x180" 
)
for (( i=0; i<${#paths[@]}; i++ )); do
    for input in `$FIND . -name "*ic_banner*" |grep -E "/.*"`;do 
        outputPath="../NvidiaShieldTVController/app/src/main/res/${paths[$i]}/"
        output=$(echo $input |awk -v path=$outputPath -F "/" '{print path$2"_"$3}';)
        magick $input -resize ${sizes[$i]} $output
    done
done
