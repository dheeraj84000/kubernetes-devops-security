#!/bin/bash

dockerImageName=`awk 'NR==1 {print $2}' Dockerfile`

docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.46.0 -q image --exit-code 0 --severity HIGH --light $dockerImageName

docker run -v /var/run/docker.sock:/var/run/docker.sock -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.46.0 -q image --exit-code 0 --severity CRITICAL --light $dockerImageName

exitCode=$?
 echo "Exit_Code: $exitCode"

if [[ "${exitCode}" == 1 ]]; then
      echo "Image Scanning Faild Vulnerbilites found"
      exit 1
else 
     echo "Image Scanning passed, No vulnerbilities found"
fi
