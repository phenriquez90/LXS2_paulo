# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++ Inicio del Script "Problema2-Consumo Agua Enero/Junio"+++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Script corre con bash
#!/bin/bash

# Num Argumentos
ARGS=2

# Valida si recibe los dos argumentos requeridos
if [ $# -ne $ARGS ]
then
	echo "ERROR:"
	echo "Por favor ingrese los parametros requeridos"
	echo "Ejemplo: $0 <CantMeses(2-6)> <NombreServicio>"
	exit 1
fi

# Admite minusculas con 2do parametro al script
shopt -s nocasematch

# almacena variabes con parametros del script
MESES=$1
ARG_SERV=$2

# asigna valores a variables que pueden variar de acuerdo a las opciones seleccionadas
# en un principio
case "$ARG_SERV" in
	Agua)
		SERVICIO=$ARG_SERV
		echo "Servicio seleccionado: $SERVICIO"
		NUM_SERV='3p' 	
	;;
	Luz)
		SERVICIO=$ARG_SERV
		echo "Servicio seleccionado: $SERVICIO"
		NUM_SERV='4p'
	;;
	Telefono)
		SERVICIO=$ARG_SERV
		echo "Servicio seleccionado: $SERVICIO"
		NUM_SERV='5p'
	;;
	Celular)
		SERVICIO=$ARG_SERV
		echo "Servicio seleccionado: $SERVICIO"
		NUM_SERV='6p'
	;;
	Internet)
		SERVICIO=$ARG_SERV
		echo "Servicio seleccionado: $SERVICIO"
		NUM_SERV='7p'
	;;
	Alquiler)
		SERVICIO=$ARG_SERV
		echo "Servicio seleccionado: $SERVICIO"
		NUM_SERV='8p'
	;;
	Aseo)
		SERVICIO=$ARG_SERV
		echo "Servicio seleccionado: $SERVICIO"
		NUM_SERV='9p'
	;;
	Cable)
		SERVICIO=$ARG_SERV
		echo "Servicio seleccionado: $SERVICIO"
		NUM_SERV='10p'
	;;
	*)
		echo "ERROR:"
		echo "Servicio $2 no disponible!!!"
		echo "Argumentos de servicios disponibles:"
		for SRV in agua luz telefono celular internet alquiler aseo cable
		do 
			echo $SRV
		done
		exit 1
esac


# Declaracion de variables globales
DATA=$PWD/hojasExcel
CSV_DATA=$DATA/archivos_csv
GRAF_DATA=$DATA/datos_graf
# creacion de directorios necesarios para guardar resultados

mkdir $CSV_DATA 2> Problema2.log
mkdir $GRAF_DATA 2> Problema2.log
rm $PWD/Problema2.log


m=0
v=1
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Bucle definido para buscar dentro de $DATA todos los excel y luego 
# por medio del comando xls2csv convertirlos a archivos .csv, la 
# accion se encuentra redirigida para capturar errores en un log
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
for i in `find $DATA -name '*.xls'`
do
	XLS=$DATA/bills0"$v"_2012.xls

	if [ "$v" -gt "$MESES" ];
	then
		VAR="var"
	else 		 	
		xls2csv $XLS > $CSV_DATA/data-$m.csv		
	fi
	let v=v+1
	let m=m+1
done 2> error1.log

m=0
t=0
v=1
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Bucle for para buscar todos los archivos csv generados
# anteriormente, para luego almacenar en la variable GET_TOTAL
# los dos primeros parametros separados por una coma y fitrarlos
# de tal forma que obtengamos un dato en especifico(gasto total agua)
# luego le agregamos una variable $v y lo agregamos en un archivo
# .dat que nos va a servir mas adelante para graficar.
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
for e in `find $CSV_DATA -name "*.csv"`
do 
	CSV_VAR=$CSV_DATA/data-$t.csv
	GET_TOTAL=`cat $CSV_VAR | awk -F, "\",\""'{print $1 " " $2}' | sed '1,$ s/"//g' | cut -d' ' -f 2 | sed -n $NUM_SERV`
	VAR="$v $GET_TOTAL"
	echo $VAR > $GRAF_DATA/graf-$m.dat
	let v=v+1
	let m=m+1
	let t=t+1
done 2> error2.log

m=0
#++++++++++++++++++++++++++++++++++++++++++++++++++
# Bucle para leer la informacion de los archivos .dat
# para luego almacenar cada dato de archivo en 
# uno solo llamado full.dat 
#++++++++++++++++++++++++++++++++++++++++++++++++++
for k in `find $GRAF_DATA -name "*.dat"`
do
	DAT=$GRAF_DATA/graf-$m.dat	
	sed '2d' $DAT >> $PWD/full.dat
	let m=m+1
done 2> error3.log
echo "Archivo full.dat para graficar creado"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Definicion de funcion graficar para utilizar la herramienta gnuplot
# donde le especificamos los parametros necesarios para crear el 
# grafico con referencia al archivo full.dat
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
graficar()
{
	gnuplot << EOF 2> error4.log
	set terminal png
	set output 'GraficoVariacion$SERVICIO.png' 
	set xlabel "Meses"
	set autoscale
	set ylabel "Consumo por Precio"
	set title "Variacion y Consumo de $SERVICIO por $MESES Meses"
	set key reverse Left outside
	set grid
	set style data linespoints
	plot "full.dat" using 1:2 title "Monto"
EOF
}

graficar

echo "GraficoVariacion$SERVICIO.png generado!!!"

