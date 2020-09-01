# Ecom Docker

Ecom's Development enviroment:

* redis
* php (with xdebug and gearman client)
* nginx
* elasticsearch

## Instructions

### How to build

1. Create data folder for db and for elastic

```
mkdir -p database/db.env
mkdir -p tmp/es_data
```

2. Build and run

```
bash build.sh
```

3. Config in 

### Usages

1. Flush all redis

```
bash flushredis.sh
```

2. Run shell command

```
bash run.sh [project_folder] [...command]
```

4. Interactive with php

```
bash ssh.sh
```