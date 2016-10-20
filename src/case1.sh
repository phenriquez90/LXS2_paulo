#!/bin/bash

# Ejemplo de case, determina si la distro esta soportada

shopt -s nocasematch

DISTRO=$1



case "$DISTRO" in
	Ubuntu)
		echo "Distribucion $DISTRO soportada"
	;;
	Centos)	
		echo "Distribucion $DISTRO soportada"
	;;
	Fedora)
		echo "Distribucion $DISTRO soportada"
	;;
	*)	
		echo "Distro no soportada"
esac


