#!/bin/bash

docker exec -it ghtk_php php -f $1/app/Console/cake.php ${@:2}