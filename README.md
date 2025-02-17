# TFG_AMG
Repositorio para el TFG de Alejandro Muñoz García: "Detección de anomalías mediante distribuciones alfa-estables y técnicas de aprendizaje automático"

- **Obtención del conjunto de datos**: El conjunto de datos que hemos utilizado ha sido el UGR'16 (https://nesg.ugr.es/nesg-ugr16/), el cual nos proporciona unas series temporales para diferentes semanas. Tras descomprimir los ficheros que deseemos debemos ejecutar el script**tref.sh** el
cual nos imprime por el terminal el primer segundo en POSIX del que se tienen los datos, es decir el
tiempo de referencia y después usaremos el **process.sh** del cual modificaremos la variable tref por el valor obtenido por pantalla antes. Con esto ya tendremos el fichero BPSyPPS.txt (Ficheros realizados por Benjamín Martín Gómez en su TFM: Estudio de la predictibilidad del tráfico en Internet para la detección de anomalías sutiles). 

- **Representación y generación de los ficheros de ataque**: Con el fichero **Parte1.m** podemos representar las series temporales (paquetes/s o bytes/s) que hemos obtenido de los ficheros BPSyPPS.txt y también podemos generar los ficheros de ataque, ya que el dataset que tenemos no tiene ficheros de ataque para todas las semanas. También se porporciona **ataques_tot.mat** que tiene 119 bandas de ataque DoS de los ficheros de UGR'16. 

- **Calculo de los parámetros de la red neuronal**: para el cálculo de los 4 parámetros alfa-estables tenemos dos funciones con 7 métodos para calcularlos, **f_CalculoParametrosTramos.m** que calcula los parámetros para un tramo del fichero y **f_CalculoParametrosCompleto.m** que los calcula para todo el fichero. Estas funciones se ejecutan en **CalculoParametrosMain.m**, donde además se calculan también el resto de parámetros para la red neuronal.  También se proporciona un .zip con las dependencias para poder ejecutar algunos métodos.
- 
- **Red neuronal** : se proporciona el diseño con la red neuronal que mejor rendimiento nos dio y también el **RedNeuronalMain.m** donde se pueden ver los resultados de la red y la parte de los umbrales de decisión
