#!/bin/bash

PROY_PATH=../proyectos/proyecto1/

for OBJ in bashrc dhcpd.conf file file2
do
	chmod 750 ../misc/$OBJ
done

