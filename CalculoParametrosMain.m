clear all; close all; clc;
%% CALCULO DE LOS PARÁMETROS PARA UN TRAMO DEL FICHERO
addpath('./stableinterp_new_v3/');
addpath('./libstable_mex/matlab/');
load("stableinterp_new_v3\stable_table_40db.mat");

fichero = "./TimeSeriesData/may_week3_csv/BPSyPPS.txt";

data = readtable(fichero);
% Extrae las columnas de interés
tiempo = data{:, 1}; % Tiempo en UNIX
%ELEGIR OPCION: bits por segundo o numero de paquetes por segundo
bits = data{:, 2}; % Número de bits/s
paquetes = data{:, 3}; % Número de paquetes/s

ventana = 15;
size_ventana = ventana * 60;

% Variables para el metodo de FEDE
global T;
global tri;
global stable_table;
tri=delaunay(ab);
T=triangulation(tri,ab);
%triplot(T,'-b*');

% Para este caso solo queremos obtener valores en un lugar especifico
tiempo_comienzo = 1463057738;
indice_comienzo = find(tiempo == tiempo_comienzo);
tiempo_final = tiempo_comienzo + 500 -1; % Cuantos valores quieres calcular
indice_final = find(tiempo == tiempo_final);

paquetes_env = paquetes(indice_comienzo:indice_comienzo +900 -1);
tiempo_env = tiempo(indice_comienzo:indice_final);

%          EJECUCION           %
% Metodo 1 -> STBL: Alpha stable distributions for MATLAB by Mark Veillete -> "ECF"
tic;
[alpha_1, beta_1, gamma_1, delta_1,distancias_ks_1] = f_CalculoParametrosTramos(paquetes, ventana,1,indice_comienzo,indice_final);
tiempo_transcurrido1 = toc;
d1_media = mean(distancias_ks_1);
d1_desviacion = std(distancias_ks_1);

% Metodo 2 -> STBL: Alpha stable distributions for MATLAB by Mark Veillete -> "Percentile"
tic;
[alpha_2, beta_2, gamma_2, delta_2,distancias_ks_2] = f_CalculoParametrosTramos(paquetes, ventana,2,indice_comienzo,indice_final);
tiempo_transcurrido2 = toc;
d2_media = mean(distancias_ks_2);
d2_desviacion = std(distancias_ks_2);

% Metodo 3 -> Koutrouvelis
tic;
[alpha_3, beta_3, gamma_3, delta_3,distancias_ks_3] = f_CalculoParametrosTramos(paquetes, ventana,3,indice_comienzo,indice_final);
tiempo_transcurrido3 = toc;
d3_media = mean(distancias_ks_3);
d3_desviacion = std(distancias_ks_3);

% Metodo 4 -> Maximum likelihood 2-D
tic;
[alpha_4, beta_4, gamma_4, delta_4,distancias_ks_4] = f_CalculoParametrosTramos(paquetes, ventana,4,indice_comienzo,indice_final);
tiempo_transcurrido4 = toc;
d4_media = mean(distancias_ks_4);
d4_desviacion = std(distancias_ks_4);

% Metodo 5 -> Maximum likelihood estimation of alpha-stable parameters
tic;
[alpha_5, beta_5, gamma_5, delta_5,distancias_ks_5] = f_CalculoParametrosTramos(paquetes, ventana,5,indice_comienzo,indice_final);
tiempo_transcurrido5 = toc;
d5_media = mean(distancias_ks_5);
d5_desviacion = std(distancias_ks_5);

% Metodo 6 -> Fast calculation by Federico Simmross using the estimations
tic;
[alpha_6, beta_6, gamma_6, delta_6,distancias_ks_6] = f_CalculoParametrosTramos(paquetes, ventana,6,indice_comienzo,indice_final);
tiempo_transcurrido6 = toc;
d6_media = mean(distancias_ks_6);
d6_desviacion = std(distancias_ks_6);

% Metodo 7 -> Fast calculation by Federico Simmross with MLE, if error METODO 4
tic;
[alpha_7, beta_7, gamma_7, delta_7,distancias_ks_7] = f_CalculoParametrosTramos(paquetes, ventana,7,indice_comienzo,indice_final);
tiempo_transcurrido7 = toc;
d7_media = mean(distancias_ks_7);
d7_desviacion = std(distancias_ks_7);

tiempo_transcurrido1 = tiempo_transcurrido1/500;
tiempo_transcurrido2 = tiempo_transcurrido2/500;
tiempo_transcurrido3 = tiempo_transcurrido3/500;
tiempo_transcurrido4 = tiempo_transcurrido4/500;
tiempo_transcurrido5 = tiempo_transcurrido5/500;
tiempo_transcurrido6 = tiempo_transcurrido6/500;
tiempo_transcurrido7 = tiempo_transcurrido7/500;
%% CALCULO DE LOS PARÁMETROS PARA TODO EL FICHERO
addpath('./stableinterp_new_v3/');
addpath('./libstable_mex/matlab/');
load("stableinterp_new_v3\stable_table_40db.mat");

fichero = "./TimeSeriesData/may_week3_csv/BPSyPPS.txt";

data = readtable(fichero);
% Extrae las columnas de interés
tiempo = data{:, 1}; % Tiempo en UNIX
%ELEGIR OPCION: bits por segundo o numero de paquetes por segundo
bits = data{:, 2}; % Número de bits/s
paquetes = data{:, 3}; % Número de paquetes/s

ventana = 15;
size_ventana = ventana * 60;

% Variables para el metodo de FEDE
global T;
global tri;
global stable_table;
tri=delaunay(ab);
T=triangulation(tri,ab);
%triplot(T,'-b*');

% Para este caso solo queremos obtener valores en un lugar especifico
tiempo_comienzo = 1463057738;
indice_comienzo = find(tiempo == tiempo_comienzo);
tiempo_final = tiempo_comienzo + 500 -1; % Cuantos valores quieres calcular
indice_final = find(tiempo == tiempo_final);

paquetes_env = paquetes(indice_comienzo:indice_comienzo +900 -1);
tiempo_env = tiempo(indice_comienzo:indice_final);

%          EJECUCION           %
% Metodo 1 -> STBL: Alpha stable distributions for MATLAB by Mark Veillete -> "ECF"
tic;
[alpha_1, beta_1, gamma_1, delta_1,distancias_ks_1] = f_CalculoParametrosCompleto(paquetes, ventana,1);
tiempo_transcurrido1 = toc;
d1_media = mean(distancias_ks_1);
d1_desviacion = std(distancias_ks_1);

% Metodo 2 -> STBL: Alpha stable distributions for MATLAB by Mark Veillete -> "Percentile"
tic;
[alpha_2, beta_2, gamma_2, delta_2,distancias_ks_2] = f_CalculoParametrosCompleto(paquetes, ventana,2);
tiempo_transcurrido2 = toc;
d2_media = mean(distancias_ks_2);
d2_desviacion = std(distancias_ks_2);

% Metodo 3 -> Koutrouvelis
tic;
[alpha_3, beta_3, gamma_3, delta_3,distancias_ks_3] = f_CalculoParametrosCompleto(paquetes, ventana,3);
tiempo_transcurrido3 = toc;
d3_media = mean(distancias_ks_3);
d3_desviacion = std(distancias_ks_3);

% Metodo 4 -> Maximum likelihood 2-D
tic;
[alpha_4, beta_4, gamma_4, delta_4,distancias_ks_4] = f_CalculoParametrosCompleto(paquetes, ventana,4);
tiempo_transcurrido4 = toc;
d4_media = mean(distancias_ks_4);
d4_desviacion = std(distancias_ks_4);

% Metodo 5 -> Maximum likelihood estimation of alpha-stable parameters
tic;
[alpha_5, beta_5, gamma_5, delta_5,distancias_ks_5] = f_CalculoParametrosCompleto(paquetes, ventana,5);
tiempo_transcurrido5 = toc;
d5_media = mean(distancias_ks_5);
d5_desviacion = std(distancias_ks_5);

% Metodo 6 -> Fast calculation by Federico Simmross using the estimations
tic;
[alpha_6, beta_6, gamma_6, delta_6,distancias_ks_6] = f_CalculoParametrosCompleto(paquetes, ventana,6);
tiempo_transcurrido6 = toc;
d6_media = mean(distancias_ks_6);
d6_desviacion = std(distancias_ks_6);

% Metodo 7 -> Fast calculation by Federico Simmross with MLE, if error METODO 4
tic;
[alpha_7, beta_7, gamma_7, delta_7,distancias_ks_7] = f_CalculoParametrosCompleto(paquetes, ventana,7);
tiempo_transcurrido7 = toc;
d7_media = mean(distancias_ks_7);
d7_desviacion = std(distancias_ks_7);

tiempo_transcurrido1 = tiempo_transcurrido1/500;
tiempo_transcurrido2 = tiempo_transcurrido2/500;
tiempo_transcurrido3 = tiempo_transcurrido3/500;
tiempo_transcurrido4 = tiempo_transcurrido4/500;
tiempo_transcurrido5 = tiempo_transcurrido5/500;
tiempo_transcurrido6 = tiempo_transcurrido6/500;
tiempo_transcurrido7 = tiempo_transcurrido7/500;
%% Histograma
paquetes_hist = paquetes(indice_comienzo:indice_comienzo +900-1);
tiempo_hist = tiempo(indice_comienzo:indice_comienzo +900-1);
%ECDF
[f,x]= ecdf(paquetes_hist);

% METODO 1
alpha_hist_1 = alpha_1(1);
beta_hist_1 = beta_1(1);
gamma_hist_1 = gamma_1(1);
delta_hist_1 = delta_1(1);
pd1 = makedist('Stable', 'alpha', alpha_hist_1, 'beta', beta_hist_1, 'gam', gamma_hist_1, 'delta', delta_hist_1);


% METODO 2
alpha_hist_2 = alpha_2(1);
beta_hist_2 = beta_2(1);
gamma_hist_2 = gamma_2(1);
delta_hist_2 = delta_2(1);
pd2 = makedist('Stable', 'alpha', alpha_hist_2, 'beta', beta_hist_2, 'gam', gamma_hist_2, 'delta', delta_hist_2);


% METODO 3
alpha_hist_3 = alpha_3(1);
beta_hist_3 = beta_3(1);
gamma_hist_3 = gamma_3(1);
delta_hist_3 = delta_3(1);
pd3 = makedist('Stable', 'alpha', alpha_hist_3, 'beta', beta_hist_3, 'gam', gamma_hist_3, 'delta', delta_hist_3);

% METODO 4
alpha_hist_4 = alpha_4(1);
beta_hist_4 = beta_4(1);
gamma_hist_4 = gamma_4(1);
delta_hist_4 = delta_4(1);
pd4 = makedist('Stable', 'alpha', alpha_hist_4, 'beta', beta_hist_4, 'gam', gamma_hist_4, 'delta', delta_hist_4);


% METODO 5
alpha_hist_5 = alpha_5(1);
beta_hist_5 = beta_5(1);
gamma_hist_5 = gamma_5(1);
delta_hist_5 = delta_5(1);
pd5 = makedist('Stable', 'alpha', alpha_hist_5, 'beta', beta_hist_5, 'gam', gamma_hist_5, 'delta', delta_hist_5);


% METODO 6
alpha_hist_6 = alpha_6(1);
beta_hist_6 = beta_6(1);
gamma_hist_6 = gamma_6(1);
delta_hist_6 = delta_6(1);
pd6 = makedist('Stable', 'alpha', alpha_hist_6, 'beta', beta_hist_6, 'gam', gamma_hist_6, 'delta', delta_hist_6);

% METODO 7
alpha_hist_7 = alpha_7(1);
beta_hist_7 = beta_7(1);
gamma_hist_7 = gamma_7(1);
delta_hist_7 = delta_7(1);
pd7 = makedist('Stable', 'alpha', alpha_hist_7, 'beta', beta_hist_7, 'gam', gamma_hist_7, 'delta', delta_hist_7);

subplot(2,1,1);
plot(tiempo_hist, paquetes_hist);

xlabel('Fecha y Hora');
ylabel('Número de paquetes por segundo');

subplot(2,1,2);
ecdfhist(f,x, 30);
hold on;
p1 = plot(pd1);
p2 = plot(pd2);
p3 = plot(pd3);
p4 = plot(pd4);
p5 = plot(pd5);
p6 = plot(pd6);
p7 = plot(pd7);
legend('Histograma', 'Método ECF', 'Método PERCENTILE', 'Método Koutrouvelis','Método MLE 2D', 'Método MLE', 'Método FEDE ESTIMACIONES', 'Método FEDE MLE');
hold off;

%% Representacion parámetros
figure;

% Plotear los tres conjuntos de valores Alpha
plot(tiempo_env, alpha_1, 'b--', 'LineWidth', 1);
hold on;
plot(tiempo_env, alpha_2, 'r--', 'LineWidth', 1);
plot(tiempo_env, alpha_3, 'g--', 'LineWidth', 1);
plot(tiempo_env, alpha_4, 'y--', 'LineWidth', 1);
plot(tiempo_env, alpha_5, 'k--', 'LineWidth', 1);
plot(tiempo_env, alpha_6, 'm--', 'LineWidth', 1);
plot(tiempo_env, alpha_7, 'c--', 'LineWidth', 1);
% Agregar etiquetas y leyenda
xlabel('Tiempo');
ylabel('Valor Alpha');
title('Valores Alpha para Diferentes Métodos');
legend('Método 1', 'Método 2', 'Método 3','Método 4','Método 5','Método 6','Método 7' );

% Mostrar la cuadrícula
grid on;

% Liberar el bloqueo de la superposición de gráficos
hold off;

figure;

% Plotear los tres conjuntos de valores beta
plot(tiempo_env, beta_1, 'b--', 'LineWidth', 1);
hold on;
plot(tiempo_env, beta_2, 'r--', 'LineWidth', 1);
plot(tiempo_env, beta_3, 'g--', 'LineWidth', 1);
plot(tiempo_env, beta_4, 'y--', 'LineWidth', 1);
plot(tiempo_env, beta_5, 'k--', 'LineWidth', 1);
plot(tiempo_env, beta_6, 'm--', 'LineWidth', 1);
plot(tiempo_env, beta_7, 'c--', 'LineWidth', 1);

% Agregar etiquetas y leyenda
xlabel('Tiempo');
ylabel('Valor Beta');
title('Valores Beta para Diferentes Métodos');
legend('Método 1', 'Método 2', 'Método 3','Método 4','Método 5','Método 6','Método 7' );

% Mostrar la cuadrícula
grid on;

% Liberar el bloqueo de la superposición de gráficos
hold off;

figure;

% Plotear los tres conjuntos de valores gamma
plot(tiempo_env, gamma_1, 'b--', 'LineWidth', 1);
hold on;
plot(tiempo_env, gamma_2, 'r--', 'LineWidth', 1);
plot(tiempo_env, gamma_3, 'g--', 'LineWidth', 1);
plot(tiempo_env, gamma_4, 'y--', 'LineWidth', 1);
plot(tiempo_env, gamma_5, 'k--', 'LineWidth', 1);
plot(tiempo_env, gamma_6, 'm--', 'LineWidth', 1);
plot(tiempo_env, gamma_7, 'c--', 'LineWidth', 1);
% Agregar etiquetas y leyenda
xlabel('Tiempo');
ylabel('Valor Gamma');
title('Valores Gamma para Diferentes Métodos');
legend('Método 1', 'Método 2', 'Método 3','Método 4','Método 5','Método 6','Método 7' );

% Mostrar la cuadrícula
grid on;

% Liberar el bloqueo de la superposición de gráficos
hold off;

figure;

% Plotear los tres conjuntos de valores delta
plot(tiempo_env, delta_1, 'b--', 'LineWidth', 1);
hold on;
plot(tiempo_env, delta_2, 'r--', 'LineWidth', 1);
plot(tiempo_env, delta_3, 'g--', 'LineWidth', 1);
plot(tiempo_env, delta_4, 'y--', 'LineWidth', 1);
plot(tiempo_env, delta_5, 'k--', 'LineWidth', 1);
plot(tiempo_env, delta_6, 'm--', 'LineWidth', 1);
plot(tiempo_env, delta_7, 'c--', 'LineWidth', 1);
% Agregar etiquetas y leyenda
xlabel('Tiempo');
ylabel('Valor Delta');
title('Valores Delta para Diferentes Métodos');
legend('Método 1', 'Método 2', 'Método 3','Método 4','Método 5','Método 6','Método 7' );

% Mostrar la cuadrícula
grid on;

% Liberar el bloqueo de la superposición de gráficos
hold off;