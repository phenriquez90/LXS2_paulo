#!/bin/bash

# Este script respalda tres archivos en caso de que existan
# y lo hace en una manera jerarquica.

if test -e $1
then
	cp $1 $1.bck
	echo "El archivo $1 fue correctamente respaldado.."
elif test -e $2
then
	cp $2 $2.bck
	echo "El archivo $2 fue correctamente respaldado.."
elif test -e $3
then
	cp $3 $3.bck
	echo "El archivo $3 fue correctamente respaldado.."
else
	echo "No se pudo respaldar ninguno de los archivos $@"
fi



