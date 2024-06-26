# Bitnami package for Apache Airflow Worker

## What is Apache Airflow Worker?

> Apache Airflow is a tool to express and execute workflows as directed acyclic graphs (DAGs). Airflow workers listen to, and process, queues containing workflow tasks.

[Overview of Apache Airflow Worker](https://airflow.apache.org/)
Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name airflow-worker bitnami/airflow-worker:latest
```

You can find the default credentials and available configuration options in the [Environment Variables](#environment-variables) section.

## Why use Bitnami Images?

* Bitnami closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Bitnami images the latest bug fixes and features are available as soon as possible.
* Bitnami containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/bitnami/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Bitnami images available in Docker Hub are signed with [Notation](https://notaryproject.dev/). [Check this post](https://blog.bitnami.com/2024/03/bitnami-packaged-containers-and-helm.html) to know how to verify the integrity of the images.
* Bitnami container images are released on a regular basis with the latest distribution packages available.

Looking to use Apache Airflow Worker in production? Try [VMware Tanzu Application Catalog](https://bitnami.com/enterprise), the enterprise edition of Bitnami Application Catalog.

## Supported tags and respective `Dockerfile` links

Learn more about the Bitnami tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.bitnami.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `bitnami/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [bitnami/containers GitHub repo](https://github.com/bitnami/containers).

## Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://docs.docker.com/compose/) is recommended with a version `1.6.0` or later.

## How to use this image

Airflow Worker is a component of an Airflow solution configuring with the `CeleryExecutor`. Hence, you will need to rest of Airflow components for this image to work.
You will need an [Airflow Webserver](https://github.com/bitnami/containers/tree/main/bitnami/airflow), an [Airflow Scheduler](https://github.com/bitnami/containers/tree/main/bitnami/airflow-scheduler), a [PostgreSQL database](https://github.com/bitnami/containers/tree/main/bitnami/postgresql) and a [Redis(R) server](https://github.com/bitnami/containers/tree/main/bitnami/redis).

### Using the Docker Command Line

1. Create a network

    ```console
    docker network create airflow-tier
    ```

2. Create a volume for PostgreSQL persistence and create a PostgreSQL container

   ```console
   docker volume create --name postgresql_data
   docker run -d --name postgresql \
     -e POSTGRESQL_USERNAME=bn_airflow \
     -e POSTGRESQL_PASSWORD=bitnami1 \
     -e POSTGRESQL_DATABASE=bitnami_airflow \
     --net airflow-tier \
     --volume postgresql_data:/bitnami/postgresql \
     bitnami/postgresql:latest
   ```

3. Create a volume for Redis(R) persistence and create a Redis(R) container

    ```console
    docker volume create --name redis_data
    docker run -d --name redis \
      -e ALLOW_EMPTY_PASSWORD=yes \
      --net airflow-tier \
      --volume redis_data:/bitnami \
      bitnami/redis:latest
    ```

4. Launch the Apache Airflow Worker web container

    ```console
    docker run -d --name airflow -p 8080:8080 \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
      -e AIRFLOW_LOAD_EXAMPLES=yes \
      -e AIRFLOW_PASSWORD=bitnami123 \
      -e AIRFLOW_USERNAME=user \
      -e AIRFLOW_EMAIL=user@example.com \
      --net airflow-tier \
      bitnami/airflow:latest
    ```

5. Launch the Apache Airflow Worker scheduler container

    ```console
    docker run -d --name airflow-scheduler \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
      -e AIRFLOW_LOAD_EXAMPLES=yes \
      --net airflow-tier \
      bitnami/airflow-scheduler:latest
    ```

6. Launch the Apache Airflow Worker worker container

    ```console
    docker run -d --name airflow-worker \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
      -e AIRFLOW_QUEUE=new_queue \
      --net airflow-tier \
      bitnami/airflow-worker:latest
    ```

  Access your application at `http://your-ip:8080`

### Using `docker-compose.yaml`

```console
curl -LO https://raw.githubusercontent.com/bitnami/containers/main/bitnami/airflow/docker-compose.yml
docker-compose up
```

Please be aware this file has not undergone internal testing. Consequently, we advise its use exclusively for development or testing purposes. For production-ready deployments, we highly recommend utilizing its associated [Bitnami Helm chart](https://github.com/bitnami/charts/tree/main/bitnami/airflow).

If you detect any issue in the `docker-compose.yaml` file, feel free to report it or contribute with a fix by following our [Contributing Guidelines](https://github.com/bitnami/containers/blob/main/CONTRIBUTING.md).

### Persisting your application

The Bitnami Airflow container relies on the PostgreSQL database & Redis to persist the data. This means that Airflow does not persist anything. To avoid loss of data, you should mount volumes for persistence of [PostgreSQL data](https://github.com/bitnami/containers/blob/main/bitnami/mariadb#persisting-your-database) and [Redis(R) data](https://github.com/bitnami/containers/blob/main/bitnami/redis#persisting-your-database)

The above examples define docker volumes namely `postgresql_data`, and `redis_data`. The Airflow application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

#### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'
services:
  postgresql:
    image: 'bitnami/postgresql:latest'
    environment:
      - POSTGRESQL_DATABASE=bitnami_airflow
      - POSTGRESQL_USERNAME=bn_airflow
      - POSTGRESQL_PASSWORD=bitnami1
    volumes:
      - /path/to/postgresql-persistence:/bitnami
  redis:
    image: 'bitnami/redis:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - /path/to/redis-persistence:/bitnami
  airflow-worker:
    image: bitnami/airflow-worker:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_LOAD_EXAMPLES=yes
  airflow-scheduler:
    image: bitnami/airflow-scheduler:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_LOAD_EXAMPLES=yes
  airflow:
    image: bitnami/airflow:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_PASSWORD=bitnami123
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@example.com
    ports:
      - '8080:8080'
```

#### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

    ```console
    docker network create airflow-tier
    ```

2. Create the PostgreSQL container with host volumes

    ```console
    docker run -d --name postgresql \
      -e POSTGRESQL_USERNAME=bn_airflow \
      -e POSTGRESQL_PASSWORD=bitnami1 \
      -e POSTGRESQL_DATABASE=bitnami_airflow \
      --net airflow-tier \
      --volume /path/to/postgresql-persistence:/bitnami \
      bitnami/postgresql:latest
    ```

3. Create the Redis(R) container with host volumes

    ```console
    docker run -d --name redis \
      -e ALLOW_EMPTY_PASSWORD=yes \
      --net airflow-tier \
      --volume /path/to/redis-persistence:/bitnami \
      bitnami/redis:latest
    ```

4. Create the Airflow container

    ```console
    docker run -d --name airflow -p 8080:8080 \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
      -e AIRFLOW_LOAD_EXAMPLES=yes \
      -e AIRFLOW_PASSWORD=bitnami123 \
      -e AIRFLOW_USERNAME=user \
      -e AIRFLOW_EMAIL=user@example.com \
      --net airflow-tier \
      bitnami/airflow:latest
    ```

5. Create the Airflow Scheduler container

    ```console
    docker run -d --name airflow-scheduler \
        -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
      -e AIRFLOW_LOAD_EXAMPLES=yes \
      --net airflow-tier \
        bitnami/airflow-scheduler:latest
    ```

6. Create the Airflow Worker container

    ```console
    docker run -d --name airflow-worker \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
      --net airflow-tier \
      bitnami/airflow-worker:latest
    ```

## Configuration

### Installing additional python modules

This container supports the installation of additional python modules at start-up time. In order to do that, you can mount a `requirements.txt` file with your specific needs under the path `/bitnami/python/requirements.txt`.

### Environment variables

#### Customizable environment variables

| Name                                | Description                                                       | Default Value        |
|-------------------------------------|-------------------------------------------------------------------|----------------------|
| `AIRFLOW_EXECUTOR`                  | Airflow executor.                                                 | `SequentialExecutor` |
| `AIRFLOW_EXECUTOR`                  | Airflow executor.                                                 | `CeleryExecutor`     |
| `AIRFLOW_FORCE_OVERWRITE_CONF_FILE` | Force the airflow.cfg config file generation.                     | `no`                 |
| `AIRFLOW_WEBSERVER_HOST`            | Airflow webserver host                                            | `127.0.0.1`          |
| `AIRFLOW_WEBSERVER_PORT_NUMBER`     | Airflow webserver port.                                           | `8080`               |
| `AIRFLOW_HOSTNAME_CALLABLE`         | Method to obtain the hostname.                                    | `socket.gethostname` |
| `AIRFLOW_DATABASE_HOST`             | Hostname for PostgreSQL server.                                   | `postgresql`         |
| `AIRFLOW_DATABASE_HOST`             | Hostname for PostgreSQL server.                                   | `127.0.0.1`          |
| `AIRFLOW_DATABASE_PORT_NUMBER`      | Port used by PostgreSQL server.                                   | `5432`               |
| `AIRFLOW_DATABASE_NAME`             | Database name that Airflow will use to connect with the database. | `bitnami_airflow`    |
| `AIRFLOW_DATABASE_USERNAME`         | Database user that Airflow will use to connect with the database. | `bn_airflow`         |
| `AIRFLOW_DATABASE_USE_SSL`          | Set to yes if the database is using SSL.                          | `no`                 |
| `AIRFLOW_REDIS_USE_SSL`             | Set to yes if Redis(R) uses SSL.                                  | `no`                 |
| `REDIS_HOST`                        | Hostname for Redis(R) server.                                     | `redis`              |
| `REDIS_HOST`                        | Hostname for Redis(R) server.                                     | `127.0.0.1`          |
| `REDIS_PORT_NUMBER`                 | Port used by Redis(R) server.                                     | `6379`               |
| `REDIS_DATABASE`                    | Name of the Redis(R) database.                                    | `1`                  |

#### Read-only environment variables

| Name                   | Description                               | Value                                    |
|------------------------|-------------------------------------------|------------------------------------------|
| `AIRFLOW_BASE_DIR`     | Airflow installation directory.           | `${BITNAMI_ROOT_DIR}/airflow`            |
| `AIRFLOW_HOME`         | Airflow home directory.                   | `${AIRFLOW_BASE_DIR}`                    |
| `AIRFLOW_BIN_DIR`      | Airflow directory for binary executables. | `${AIRFLOW_BASE_DIR}/venv/bin`           |
| `AIRFLOW_LOGS_DIR`     | Airflow logs directory.                   | `${AIRFLOW_BASE_DIR}/logs`               |
| `AIRFLOW_LOG_FILE`     | Airflow logs directory.                   | `${AIRFLOW_LOGS_DIR}/airflow-worker.log` |
| `AIRFLOW_CONF_FILE`    | Airflow configuration file.               | `${AIRFLOW_BASE_DIR}/airflow.cfg`        |
| `AIRFLOW_TMP_DIR`      | Airflow directory temporary files.        | `${AIRFLOW_BASE_DIR}/tmp`                |
| `AIRFLOW_PID_FILE`     | Path to the Airflow PID file.             | `${AIRFLOW_TMP_DIR}/airflow-worker.pid`  |
| `AIRFLOW_DAGS_DIR`     | Airflow data to be persisted.             | `${AIRFLOW_BASE_DIR}/dags`               |
| `AIRFLOW_DAEMON_USER`  | Airflow system user.                      | `airflow`                                |
| `AIRFLOW_DAEMON_GROUP` | Airflow system group.                     | `airflow`                                |

> In addition to the previous environment variables, all the parameters from the configuration file can be overwritten by using environment variables with this format: `AIRFLOW__{SECTION}__{KEY}`. Note the double underscores.

#### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  airflow:
    image: bitnami/airflow:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=bitnami_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=bitnami1
      - AIRFLOW_PASSWORD=bitnami123
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@example.com
```

#### Specifying Environment variables on the Docker command line

```console
docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=bitnami_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=bitnami1 \
    -e AIRFLOW_PASSWORD=bitnami123 \
    -e AIRFLOW_USERNAME=user \
    -e AIRFLOW_EMAIL=user@example.com \
    bitnami/airflow:latest
```

## Notable Changes

### Starting January 16, 2024

* The `docker-compose.yaml` file has been removed, as it was solely intended for internal testing purposes.

### 1.10.15-debian-10-r18 and 2.0.1-debian-10-r51

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/bitnami/containers/issues) or submitting a [pull request](https://github.com/bitnami/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2024 Broadcom. The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
