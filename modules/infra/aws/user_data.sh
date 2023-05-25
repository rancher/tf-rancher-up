#!/bin/bash

if [ ${install_docker} = true ]
  then
	  echo 'Installing Docker'
		export DEBIAN_FRONTEND=noninteractive
		curl -sSL https://releases.rancher.com/install-docker/20.10.sh | sh -
		sudo usermod -aG docker ${username}
fi