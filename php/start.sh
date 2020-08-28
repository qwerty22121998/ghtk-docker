#!/bin/bash


service supervisor start
gearmand -d
php-fpm
