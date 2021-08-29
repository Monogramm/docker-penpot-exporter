#!/bin/sh

set -e

################################################################################
# Testing docker containers

echo "Waiting to ensure everything is fully ready for the tests..."
sleep 60

echo "Checking main containers are reachable..."
if ! ping -c 10 -q "${DOCKER_TEST_CONTAINER}" ; then
    echo 'Main container is not responding!'
    # TODO Display logs to help bug fixing
    #echo 'Check the following logs for details:'
    #tail -n 100 logs/*.log
    exit 2
fi


################################################################################
# Success
echo 'Docker tests successful'


################################################################################
# Automated Unit tests
# https://docs.docker.com/docker-hub/builds/automated-testing/
################################################################################

# TODO Check API is responding
# curl "http://${DOCKER_WEB_CONTAINER:${DOCKER_TEST_CONTAINER}}:80"


################################################################################
# Success
echo "Docker app '${DOCKER_TEST_CONTAINER}' tests finished"
echo 'Check the CI reports and logs for details.'
exit 0
