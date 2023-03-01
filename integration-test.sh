#!/bin/bash

#integration-test.sh

sleep 5s

PORT=$(kubectl -n default get svc ${svcName} -o json | jq .spec.ports[].nodePort)

echo $PORT
echo $serverURL:$PORT/$appURI
response=$(curl -s $serverURL:$PORT/$appURI)

http_code=$(curl -s -o /dev/null -w "%{http_code}" $serverURL:$PORT/$appURI)

echo $http_code

if [[ ! -z "$PORT" ]];
then
    if [[ "$response" == 100 ]];
        then
            echo "Increment Test Passed"
        else
            echo "Increment Test Failed"
            exit 1;
    fi;

    # if [[ "$http_code" == 200 ]];
    #     then
    #         echo "HTTP Status Code Test Passed"
    #     else
    #         echo "HTTP Status code is not 200"
    #         exit 1;
    # fi;

else
        echo "The Service does not have a NodePort"
        exit 1;
fi;