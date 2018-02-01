#!/usr/bin/env bash

apt-get update
apt-get -y install nginx

echo "Hello and welcome to terraform" > /usr/share/nginx/html/index.html