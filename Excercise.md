

Oberon
    Existing tutorials
        See academy.oberon.nl >backend>docker
            https://academy.oberon.nl/backend/docker
                Describes:
                -What is docker
                -How to use docker
                    https://www.youtube.com/watch?v=fqMOX6JJhGo
                    https://www.youtube.com/watch?v=fqMOX6JJhGo
                -How to setup docker for Oberon
                    https://www.notion.so/teamoberon/Docker-setup-8c27cc9a30cc44c1819279c0613adfe7


    Additional links:
        Notion>Disciplines/Backend/Deployment/Docker
            https://www.notion.so/teamoberon/Docker-92983a4714874677b926e384747ffccb

    Folow the udemy course
        Hands on With Docker & Docker Compose From a Docker Captain


-----

Docker Execercices
This is intended to help learn aspects of Docker by presenting challenges. The challenges will address
- Docker
- docker-compose
- networking
- logging
- debugging and general approaches to trouble shooting.


prequisict


Topics:

- docker override
- 'hello world' with docker-compose
- cpu usages / status
- db backup restore
- resource consumption / and running proccesses
- docker-inspect
    - 34 clean up after yourtr self
    - q&a
    - start docker without docker-compose.yml
    - file sharing with host and network sharing
    - naming network
    - naming volumes
    - env vars
    - 06,11,14,16,19,22
    - 25, 26
    - extracting image


# 01  Hello world' with docker.#
    ** Exercise**
        a) run an docker-image that will display 'Hello world'
        b) create and run an docker-image (without dokcer-compose) bassed on alpine that will display 'midsummer-night'
    ** Posible solution **
        a) docker run hello-world
        b) docker run alpine:latest "echo" "Hello world"

# 02 'docker-compose.override.yml'#
    ** Background **
        The docker-compose.override.yml is the configuration file where you can override existing settings from docker-compose.yml or even add completely new services.
        By default, this file does not exist and you must create it. You can either copy the existing docker-compose.override.yml-example or create a new one.
    ** Exercise **
        Taken the following content of a 'docker-compose.yml'

> 'docker-compose.yml'
> version: '3'
> services:
>   db:
>     image: mysql:5.7.37
>     command: --default-authentication-plugin=mysql_native_password
>     restart: always
>     ports:
>       - 3357:3306
>       - 33570:33060
>     environment:
>       MYSQL_ROOT_PASSWORD: password
>       MYSQL_USER: user
>       MYSQL_PASSWORD: password

        Add a 'docker-compose.override.yml' that will
        - adjust the file so port 3306 is accisable on port --> '4813'.
        - adjust the container_name to 'myTestSqlVers57'.
        (Note: adjusting the container-name can be helpfull to id the correct container)

    ** Posible solution **

> 'docker-compose.override.yml'
> version: '3'
> services:
>     db:
>         container_name: myTestSqlVers57
>         ports:
>         - 4813:3306
>         - 33570:33060

# 03 create a db from a sql-file when the container is created.#
    ** Excersice **
        You need to test a project. And must be able to reset te dataset.
        Adjust the following composer file
        So it will create a db from a sql-file when the container is created.

> 'docker-compose.yml'
> version: '3'
> services:
>   db:
>     image: mysql:5.7.37
>     command: --default-authentication-plugin=mysql_native_password
>     restart: always
>     ports:
>       - 3357:3306
>       - 33570:33060
>     environment:
>       MYSQL_ROOT_PASSWORD: password
>       MYSQL_USER: user
>       MYSQL_PASSWORD: password

> 'create_db.sql'
> CREATE DATABASE testDB;
> USE testDB;
> CREATE TABLE `log_message_create_request` (  `reason` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL);
> INSERT INTO log_message_create_request(reason) VALUES('created by creation of Container');


    ** Posible solution **
> 'docker-compose.yml'
> version: '3'
> services:
>   db:
>     image: mysql:5.7.37
>     command: --default-authentication-plugin=mysql_native_password
>     restart: always
>    volumes:
>      - ./create_db.sql:/docker-entrypoint-initdb.d/create_db.sql:ro
>     ports:
>       - 3357:3306
>       - 33570:33060
>     environment:
>       MYSQL_ROOT_PASSWORD: password
>       MYSQL_USER: user
>       MYSQL_PASSWORD: password

Side note: we usally install mysql local

# 04 Backup and Restore mysql db
    ** Excersice **
        - Create a back-up of the database named 'backup.sql'
        - Restore the backup 'backup.sql'
        - Reset the database
    ** Posible solution **

## Backup
docker exec CONTAINER /usr/bin/mysqldump -u root --password=root DATABASE > backup.sql
## Restore
cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=root DATABASE
## reset the database option 1
docker exec -it mysql_container mysql -u root -p database_name < /docker-entrypoint-initdb.d/create_db.sql
## reset the database option 2
docker-compose down
docker-compose up -d


# 05 resource consumption / and running proccesses #
    ** Excersice **
        - find out how to get information about the resources a docker container consumes.
        - find out what proccess a docker container is running
    ** Posible solutions **
## Viewing resource consumption
### list all resource consumption of all active containers
docker stats
### list resource consumption of all active containers but formated
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}
### list resource consumption of containername1  containername2
docker stats containername1  containername2
## Finding Resource Metrics With the Docker API
curl --unix-socket /var/run/docker.sock "http://localhost/v1.41/containers/{id}/stats" | jq
Replace {id} with your container’s ID.
## Viewing Running Processes
docker top bam-homestudiosapi-dev_beanstalk_1

# 06 docker inspect #
    ** Excersice **
    find out what the command 'docker inspect' does. And Get an instance’s log path.
    https://docs.docker.com/engine/reference/commandline/inspect/
    ** Posible solution **
     docker inspect --format='{{.LogPath}}' $INSTANCE_ID

# 07 docker clean-up #
    ** Excersice **

    Working with Docker, you’ll soon find objects on your system that are hanging around from previous activities. It is time to see if you can clean up Docker objects. clean up all stopped containers, images and volumes.

* Posible (helpfull) commands:

* Information regarding the amount of disk space used
> $ docker system df
* List All Docker containers
> $ docker container ls -a
* remove all stopped containers
> $ docker container prune
* list all dangling images
> $ docker image ls -f "dangling=true"
* remove all dangling images
> $ docker image prune
* remove all local volumes not used by at least one container
> $ docker volume prune
* remove all custom networks not used by at least one container
> $ docker network prune
* command to remove:
  - all stopped containers
  - all networks not used by at least one container
  - all dangling images
  - all dangling build cache
> $ docker system prune


# 08 stop the entry point script from running #
    ** Excersice **
a) You got a docker compose file. In this file there is the code block.
>    worker:
>        image: oberonamsterdam/php:7.4-fpm
>        restart: always
>        network_mode: "bridge"
>        links:
>            - redis
>            - beanstalk
>        depends_on:
>            - redis
>            - beanstalk
>        volumes:
>            - .:/app/:delegated
>            - ./contrib/supervisor.conf:/etc/supervisor/conf.d/homestudios.conf:ro
>        environment:
>            - "PHP_MAX_EXECUTION_TIME=0"
>            - "PHP_MEMORY_LIMIT=3G"
>        external_links:
>            - wkhtmltopdf_prod
>        entrypoint: ["/app/start-crontab-supervisord.sh"]
>        healthcheck:
>            disable: true
Create a docker-compose.override.yml that stops the entry point script from running, but keeps the image running.
    ** Posible solution **
docker-compose.override.yml
> version: '3'
> services:
>     worker:
>         entrypoint: ["tail", "-f", "/dev/null"]

# 09 view logs #

** Excersice **
It looks like something happened about 15 minutes ago.
How can you determine what containers ran in the last 20 minutes?

** Posible solution **
the command `docker logs` tell you what you need to know but
better use the command `docker events --since '20m'` to see what docker was doing recently.


# 10 include docker containers in a pipeline #

** Excersice **
Did you know that you can include docker containers in pipelines?
This can be useful when you have tools using stdin/stdout that you are going to Dockerize.

Using a pipeline, echo the string "change this word to" from a docker container into sed in another container and replace "this" with "that".

The echo command looks like this:

    echo "change this word to"

The sed command looks like this:

    sed -n 's/this/that/p'

** Posible solution **

    docker run -i --rm alpine echo "change this word to" | docker run -i alpine sed -n 's/this/that/p'

Note that if you include a pseudo tty with (-t) in the sed container you will get this error

    the input device is not a TTY

The reason for this is that the -t option causes a pseudo tty (terminal) to be allocated but there is no terminal to attach it to.




---- example
    https://linuxhint.com/docker_basic_command_line_tips/
    https://github.com/Vizuri/docker-exercises
    https://www.viget.com/articles/local-docker-best-practices/
    https://devopscube.com/keep-docker-container-running/
--------
docker file --> image -->container

apt-install

rar

wouter

volgende week 1 nieuw plan