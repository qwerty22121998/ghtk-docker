# Ecom Docker

Ecom's Development enviroment:

- redis
- php (with xdebug and gearman client)
- nginx
- elasticsearch

## Instructions

### How to build

1. Create data folder for db and for elastic

```
touch database/db.env
mkdir -p tmp/es_data
```

2. Build and run

```
make build
make run
```

3. Config in

### Usages

1. Flush all redis

```
make flushredis
```

2. Run shell command

```
bash run.sh [project_folder] [...command]
```

4. Interactive with php

```
make ssh
```
