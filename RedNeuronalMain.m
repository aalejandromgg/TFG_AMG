
clear all; close all; clc; warning off;
data1 = addpath('../myRED/');
data2 = addpath('../myTFG/');
%% RED
load('salida_red_epoch10_batchsize32_LSTM_v3_tanh_energia.mat');
% Lista de ficheros
ficheros = ["./TimeSeriesData/march_week5_csv/BPSyPPS.txt";...
            "./TimeSeriesData/may_week1_csv/BPSyPPS.txt";...
            "./TimeSeriesData/may_week3_csv/BPSyPPS.txt"];

% Inicializar una variable para almacenar los resultados
longitudesColumnas = zeros(length(ficheros), 1);

% Bucle para recorrer cada fichero
for i = 1:length(ficheros)
    % Leer el fichero como una tabla
    data = readtable(ficheros(i), 'Delimiter', '\t'); % Asumiendo que está delimitado por tabuladores
    
    % Guardar la longitud de las columnas en la variable
    longitudesColumnas(i) = height(data) - 898; % Suponiendo que todas las columnas tienen la misma longitud
end

long_march_week5 = longitudesColumnas(1);
long_may_week1 = longitudesColumnas(2);
long_may_week3 = longitudesColumnas(3);

final_0 = long_march_week5;

y_pred_march_week5_no = y_pred(1:final_0);
y_test_march_week5_no = y_test(1:final_0);

inicio_1 = long_march_week5;
final_1 = long_march_week5*2;

y_pred_march_week5_si = y_pred(inicio_1 +1:final_1);
y_test_march_week5_si = y_test(inicio_1 +1:final_1);


inicio_2 = final_1;
final_2 = final_1 + long_may_week1;

y_pred_may_week1_no = y_pred(inicio_2 +1:final_2);
y_test_may_week1_no = y_test(inicio_2 +1:final_2);

inicio_3 = final_2;
final_3 = final_2 + long_may_week1;


y_pred_may_week1_si = y_pred(inicio_3 +1:final_3);
y_test_may_week1_si = y_test(inicio_3 +1:final_3);


inicio_4 = final_3;
final_4 = final_3 + long_may_week3;

y_pred_may_week3_no = y_pred(inicio_4 +1:final_4);
y_test_may_week3_no = y_test(inicio_4 +1:final_4);

inicio_5 = final_4;
final_5 = final_4 + long_may_week3;

y_pred_may_week3_si = y_pred(inicio_5 +1:final_5);
y_test_may_week3_si = y_test(inicio_5 +1:final_5);

inicializaciones = {final_0, final_1, final_2, final_3, final_4, final_5, inicio_1, inicio_2, inicio_3, inicio_4, inicio_5};
clear final_0 final_1 final_2 final_3 final_4 final_5 inicio_1 inicio_2 inicio_3 inicio_4 inicio_5 y_pred y_test;
%% REPRESENTACION
%NO
figure;
plot(y_test_may_week3_no);
hold on;
plot(y_pred_may_week3_no);
hold off;
legend('TEST', 'PRED');
xlabel('Tiempo');
ylabel('ENERGIA');
title('SEMANA 3 MAY NO ATAQUE');

%SI
figure;
plot(y_test_may_week3_si);
hold on;
plot(y_pred_may_week3_si);
hold off;
legend('TEST', 'PRED');
xlabel('Tiempo');
ylabel('ENERGIA');
title('SEMANA 3 MAY SI ATAQUE');


%%
% Cálculo del MAE
MAE_march_week5_si = mean(abs(y_test_march_week5_si - y_pred_march_week5_si));
MAE_may_week1_si = mean(abs(y_test_may_week1_si - y_pred_may_week1_si));
MAE_may_week3_si = mean(abs(y_test_may_week3_si - y_pred_may_week3_si));
% Cálculo del MSE
MSE_march_week5_si = mean((y_test_march_week5_si - y_pred_march_week5_si).^2);
MSE_may_week1_si = mean((y_test_may_week1_si - y_pred_may_week1_si).^2);
MSE_may_week3_si = mean((y_test_may_week3_si - y_pred_may_week3_si).^2);
%figure;
%scatter(y_test_may_week1_si,y_pred_may_week1_si);


%% COMPARACIONES ENERGIA
fichero = "./TimeSeriesData/may_week1_csv/BPSyPPS.txt";
fichero_ataque = "./TimeSeriesData/may_week1_csv/BPSyPPS_ataque.txt";


data1 = readtable(fichero);
data2 = readtable(fichero_ataque);
tiempo1 = data1{:, 1}; % Tiempo en UNIX
tiempo2 = data2{:, 1}; % Tiempo en UNIX
paquetes1 = data1{:, 3}; % Número de paquetes/s
paquetes2 = data2{:, 3}; % Número de paquetes/s

array_ataques = round(paquetes2 -paquetes1);

num_ventanas = length(paquetes1) - 899;
ventana = 15;
size_ventana = ventana * 60;

for i = 1:num_ventanas
    v1 = array_ataques(i:size_ventana+i-1);
    energia_ataque(i) = sum(v1.^2);
end

%energia_ataque = (energia_ataque - min(energia_ataque)) / (max(energia_ataque) - min(energia_ataque));
energia_mezcla = y_test_may_week1_si;
energia_prediccion = y_pred_may_week1_si *(max(energia_ataque) - min(energia_ataque)) + min(energia_ataque);


plot(energia_prediccion);
hold on;
plot(energia_ataque);
hold off;
legend('PRED', 'ATAQUE');
xlabel('Tiempo');
ylabel('ENERGIA');
title('SEMANA 3 MAY');
%% UMBRAL DE DECISIÓN -> CURVA ROC
umbral_real = 0.2;  % Ajustar
y_test_bin = y_test_may_week3_si >= umbral_real;

% Curva ROC
[X, Y, T, AUC] = perfcurve(y_test_bin, y_pred_may_week3_si, 1);
figure;
plot(X, Y, 'LineWidth', 2); 
hold on;


plot([0 1], [0 1], '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5);
xlabel('Tasa de Falsos Positivos');
ylabel('Tasa de Verdaderos Positivos');
title(['Curva ROC MAY W3 (AUC = ' num2str(AUC) ')']);
grid on;
hold off;

%% UMBRAL DE DECISIÓN -> FAR y FRR
umbral_real = 0.20;  % Ajustar
y_test_bin = y_test_may_week3_si >= umbral_real;
umbrales = linspace(0, 1, 10000);  % Rango de umbrales con un paso bajo


FAR = zeros(size(umbrales));
FRR = zeros(size(umbrales));

% Calcular FAR y FRR para cada umbral
for i = 1:length(umbrales)
    umbral = umbrales(i);
    y_pred_bin = y_pred_may_week3_si >= umbral;
    
    FP = sum((y_pred_bin == 1) & (y_test_bin == 0));
    FN = sum((y_pred_bin == 0) & (y_test_bin == 1));
    TN = sum((y_pred_bin == 0) & (y_test_bin == 0));
    TP = sum((y_pred_bin == 1) & (y_test_bin == 1));
    
    FAR(i) = FP / (FP + TN);  % Tasa de Falsos Positivos
    FRR(i) = FN / (FN + TP);  % Tasa de Falsos Negativos
end

% Encontrar el Equal Error Rate (EER)
[~, idx_eer] = min(abs(FAR - FRR));
EER = (FAR(idx_eer) + FRR(idx_eer)) / 2;

% Interpolación para mayor precisión en el EER
if idx_eer > 1 && idx_eer < length(umbrales)
    % Interpolación lineal entre el punto anterior y el siguiente
    x1 = umbrales(idx_eer-1);
    x2 = umbrales(idx_eer);
    y1 = FAR(idx_eer-1) - FRR(idx_eer-1);
    y2 = FAR(idx_eer) - FRR(idx_eer);
    
    % Encontrar el punto donde se cruzan
    % (0 es el cruce entre FAR y FRR)
    EER_x = x1 + (x2 - x1) * (y1 / (y1 - y2));
else
    EER_x = umbrales(idx_eer);
end

% Obtener el valor EER
EER_y = (FAR(idx_eer) + FRR(idx_eer)) / 2;


figure;
plot(umbrales, FAR, 'r-', 'LineWidth', 1.5); hold on;
plot(umbrales, FRR, 'b-', 'LineWidth', 1.5);
plot(EER_x, EER_y, 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');  % Punto EER
legend('FAR', 'FRR', 'EER');
xlabel('Thresold'); %Es lo mismo que umbral
ylabel('Tasa de Error');
title(['MAYW3 - Curvas FAR y FRR con EER = ' num2str(EER_y)]);
grid on;
hold off;

%% ESTADISTICOS
umbral_conv = 0.19708; % valor que sale de probar varios umbrales hasta que se estabiliza
y_pred_bin_temp = y_pred_may_week3_si >= umbral_conv;
y_test_bin_temp = y_test_may_week3_si >= umbral_conv;
FP_temp = sum((y_pred_bin_temp == 1) & (y_test_bin_temp == 0));
FN_temp = sum((y_pred_bin_temp == 0) & (y_test_bin_temp == 1));
TN_temp = sum((y_pred_bin_temp == 0) & (y_test_bin_temp == 0));
TP_temp = sum((y_pred_bin_temp == 1) & (y_test_bin_temp == 1));

fprintf('TP: %d\n', TP_temp);
fprintf('FP: %d\n', FP_temp);
fprintf('TN: %d\n', TN_temp);
fprintf('FN: %d\n', FN_temp);


% Accuracy
accuracy = (TP_temp + TN_temp) / (TP_temp + TN_temp + FP_temp + FN_temp);
% Recall (Sensibilidad)
recall = TP_temp / (TP_temp + FN_temp);
% Precision
precision = TP_temp / (TP_temp + FP_temp);
% F1-Score
f1_score = 2 * (precision * recall) / (precision + recall);

% Mostrar resultados
fprintf('Accuracy: %.4f\n', accuracy);
fprintf('Recall: %.4f\n', recall);
fprintf('F1-Score: %.4f\n', f1_score);

% MATRIZ DE CONFUSION
confusion_matrix = [TN_temp, FP_temp; FN_temp, TP_temp];
% Etiquetas de las clases
labels = {'Negativo', 'Positivo'};
% Crear el heatmap
figure;
heatmap(labels, labels, confusion_matrix, ...
    'Title', 'Matriz de Confusión', ...
    'XLabel', 'Predicción', ...
    'YLabel', 'Real', ...
    'ColorbarVisible', 'on', ...
    'CellLabelFormat', '%d');