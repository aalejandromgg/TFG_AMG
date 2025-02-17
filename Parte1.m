clear all; close all; clc;
%% Representacion de las series temporales 

ficheros = ["./TimeSeriesData/april_week2_csv/BPSyPPS.txt";
    "./TimeSeriesData/z_ataques/dos_august_week1_csv/BPSyPPS.txt";];

for i = 1:length(ficheros)
    % Lee los datos desde el archivo
    data = readtable(ficheros(i));
    tiempo = data{:, 1}; % Tiempo en UNIX
    bytes = data{:, 2}; % Segunda columna Número de bytes/s
    paquetes = data{:, 3}; % Tercera columna Número de paquetes/s
    % Tiempo UNIX a un objeto datetime
    tiempoFechaHora = datetime(tiempo, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd HH:mm:ss');
    
    figure;
    plot(tiempoFechaHora, paquetes);
    xlabel('Fecha y Hora');
    ylabel('paquetes/seg');
    title(['Gráfico de Número de Paquetes respecto al tiempo - ', strrep(ficheros(i), '_', ' ')]); % Agrega el nombre del archivo al título

    figure;
    plot(tiempoFechaHora, bytes);
    xlabel('Fecha y Hora');
    ylabel('bytes/seg');
    title(['Gráfico de Número de Bytes respecto al tiempo - ', strrep(ficheros(i), '_', ' ')]); % Agrega el nombre del archivo al título
end

%% Generar ataques
load('ataques_individuales\ataques_tot.mat');
fichero = "./TimeSeriesData/april_week3_csv/BPSyPPS.txt";

data = readtable(fichero);

% Extrae las columnas de interés
tiempo = data{:, 1}; % Tiempo en UNIX
%ELEGIR OPCION: bits por segundo o numero de paquetes por segundo
bits = data{:, 2}; % Número de bits/s
paquetes = data{:, 3}; % Número de paquetes/s

tiempoFechaHora = datetime(tiempo, 'ConvertFrom', 'posixtime', 'Format', 'yyyy-MM-dd HH:mm:ss');

array_ataques = zeros(size(paquetes, 1), 1);
% Generar array_ataque
for i = 1:500 % Número a variar dependiendo del tamaño del fichero
    indice_columna = randi(size(ataques_tot, 2)); % Generar un número aleatorio entre 1 y el número de columnas
    
    % Seleccionar la columna aleatoria
    ataque_aleatorio = ataques_tot(:, indice_columna);
    ataque_aleatorio = ataque_aleatorio(ataque_aleatorio ~= 0); % Le quitamos los 0
    ataque_aleatorio = ataque_aleatorio(~isnan(ataque_aleatorio));
    
    % Generar un índice aleatorio para la posición en array_ataques
    indice_posicion = randi(length(array_ataques) - length(ataque_aleatorio) + 1);
    
    % Comprobar si la posición ya está ocupada por otro ataque aleatorio
    if any(array_ataques(indice_posicion:indice_posicion + length(ataque_aleatorio) - 1))
        continue; % Si sí, continuar con la próxima iteración
    end
    
    array_ataques(indice_posicion:indice_posicion + length(ataque_aleatorio) -1) = ataque_aleatorio;
end


% Inicializar el nuevo array para ver si hay ataque o no
array_ataques_sn = zeros(size(array_ataques));
% Ver donde hay 0s
for i = 1:length(array_ataques)
    if array_ataques(i) ~= 0
        array_ataques_sn(i) = 1;
    end
end
figure;

plot(tiempoFechaHora,array_ataques);
xlabel('Fecha y Hora');
ylabel('paquetes/seg');
title(['Gráfico de Número de Paquetes respecto al tiempo']);

% Mezcla del ataque con los paquetes/s normales
paquetes_mezcla = paquetes + array_ataques;

figure;
plot(tiempoFechaHora,paquetes_mezcla, 'r--');
hold on;
plot(tiempoFechaHora,paquetes, 'b');
xlabel('Fecha y Hora');
ylabel('Número de paquetes por segundo');
title(['Gráfico de Número de Paquetes respecto al tiempo']);
legend('Tráfico normal', 'Trafico mezclado');
hold off;

%% Generar txt

% Abre el archivo para escribir
fid = fopen('BPSyPPS_ataque_v2.txt', 'w');

% Verifica si el archivo se abrió correctamente
if fid == -1
    error('No se pudo abrir el archivo para escribir.');
end


% Obtiene el número de filas (asumiendo que todos los arrays tienen la misma longitud)
num_filas = length(tiempo);

% Escribe los datos en el archivo
for i = 1:num_filas
    fprintf(fid, '%f,%f,%f\n', tiempo(i), array_ataques(i), paquetes_mezcla(i));
end
