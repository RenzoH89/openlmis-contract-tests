#!/usr/bin/env bash

#download env file
curl -LO https://raw.githubusercontent.com/OpenLMIS/openlmis-config/master/.env

#pull all images
docker-compose pull

#change VIRTUAL_HOST value from localhost to nginx
ip="VIRTUAL_HOST=nginx"
sed -e "s/VIRTUAL_HOST=localhost/$ip/g" -i .env

#change CONSUL_HOST value from localhost to consul
ip="CONSUL_HOST=consul"
sed -e "s/CONSUL_HOST=localhost/$ip/g" -i .env

#run docker file
/usr/local/bin/docker-compose run contract_tests

#cleaning after tests
contract_test_result=$?

if [ $contract_test_result -ne 0 ]; then
  echo "========== Logging output from containers =========="
  /usr/local/bin/docker-compose logs
fi

/usr/local/bin/docker-compose down $1
#don't remove the $1 in the line above
#CI will append -v to it, so all dangling volumes are removed after the job runs

exit ${contract_test_result}
#this line above makes sure when jenkins runs this script

#the build success/failure result is determined by contract test run not by the clean up run
