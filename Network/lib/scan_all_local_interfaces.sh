#!/bin/bash

#This script will scan all local interfaces for open ports and services using nmap

ifconfig -a | grep -Po '\b(?!255)(?:\d{1,3}\.){3}(?!255)\d{1,3}\b' | xargs nmap -A -p0-