#!/bin/bash

set -e

/etc/init.d/nginx restart > /dev/null
systemctl nginx restart
