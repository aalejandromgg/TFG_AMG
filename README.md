# TFG_AMG
Repositorio para el TFG de Alejandro Muñoz García: "Detección de anomalías mediante distribuciones alfa-estables y técnicas de aprendizaje automático"

- Obtención del conjunto de datos: El conjunto de datos que hemos utilizado ha sido el UGR'16 (https://nesg.ugr.es/nesg-ugr16/), el cual nos proporciona unas series temporales para diferentes semanas. Tras descomprimir los ficheros que deseemos debemos ejecutar el script “tref.sh” el
cual nos imprime por el terminal el primer segundo en POSIX del que se tienen los datos, es decir el
tiempo de referencia y después usaremos el “process.sh” del cual modificaremos la variable tref por el valor obtenido por pantalla antes. Con esto ya tendremos el fichero BPSyPPS.txt.  
