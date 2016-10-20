# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# +++ Inicio del Script "Problema2-Consumo Agua Enero/Junio"+++
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Script corre co bash
#!/bin/bash

# Declaracion de variables globales
DATA=$PWD/hojasExcel
CSV_DATA=$DATA/archivos_csv
GRAF_DATA=$DATA/datos_graf
# creacion de directorios necesarios para guardar resultados
mkdir $CSV_DATA
mkdir $GRAF_DATA



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
	xls2csv $XLS > $CSV_DATA/data-$m.csv
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
	GET_TOTAL=`cat $CSV_VAR | awk -F, "\",\""'{print $1 " " $2}' | sed '1,$ s/"//g' | cut -d' ' -f 2 | sed -n '3p'`
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


#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Definicion de funcion graficar para utilizar la herramienta gnuplot
# donde le especificamos los parametros necesarios para crear el 
# grafico con referencia al archivo full.dat
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
graficar()
{
	gnuplot << EOF 2> error4.log
	set terminal png
	set output 'GraficoConsumoAgua.png' 
	set xlabel "Meses"
	set autoscale
	set ylabel "Consumo por Precio"
	set title "Consumo Agua Enero a Junio"
	set key reverse Left outside
	set grid
	set style data linespoints
	plot "full.dat" using 1:2 title "Colones"
EOF
}

graficar

