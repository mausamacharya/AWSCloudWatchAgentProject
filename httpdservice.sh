#!/bin/bash

#################
## Version = 1
## Date = 28th-May-2024
#################

# check the status of httpd.service and save the output in a variable called status

status=$(systemctl is-active httpd.service)

# print the output on the screen

echo $status >> /home/ec2-user/httpdservice.log
