# mkdebs
Docker-compose scripts for interfacing with Travis-CI

## Prerequisites
- Install `docker-compose` by following the instructions [here](https://docs.docker.com/compose/install/)
- [Travis-CI](https://travis-ci.org/) account

## Installation
- Clone this repository 

	```
	git clone https://github.com/kinsamanka/mkdebs
	```
- Perform initial setup 

	```
    cd mkdebs
    ./setup.sh
    ```
- Encrypt sftp access key 

    ```
    REPO=<USER/machinekit> ./cmds/encrypt_sftp_keys.sh
    ```

  `travis-cli` will ask for github login details.
  The user must have admin privileges over `<USER/machinekit>`
- Startup the docker containers

  ```
  docker-compose up -d
  ```
- The default configuration will listen on ports `9080` and `9443` for the web access and port `9022` for the sftp access

## Additional steps
- Setup your firewall rules so that the three ports (`9080`, `9443` and `9022`) can be accessed from the wan side
- Optionally enable port-forwarding
- Go to the [Travis-CI](https://travis-ci.org/) settings page for the repo `<USER/machinekit>` and add the following __*Environment Variables*__:
  - `SFTP_DEPLOY_ADDR`
  - `SFTP_DEPLOY_PORT`

## Notes
- To shutdown the containers:

  ```
  cd <mkdebs dir>
  docker-compose stop
  ```
- To start again:

  ```
  cd <mkdebs dir>
  docker-compose start
  ```
- More info about Docker containers can be found [here](https://docs.docker.com/compose/)



