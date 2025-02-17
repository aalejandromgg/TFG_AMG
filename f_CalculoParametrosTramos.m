function [alpha, beta, gamma, delta,distancias_ks] = f_CalculoParametrosTramos(datos, ventana, metodo,indice_comienzo,indice_final)
    %Funcion que calcula los parametros alpha stables,de todo el array, barriendolo en ventanas de X valores
    % LIBSTABLE_MEX y STABLEINTERP
    % Eleccion de metodo ->
    % 1. STBL: Alpha stable distributions for MATLAB by Mark Veillete -> "ECF"
    % 2. STBL: Alpha stable distributions for MATLAB by Mark Veillete -> "Percentile"
    % 3. Koutrouvelis
    % 4. Modified 2D Maximum likelihood estimation of alpha-stable parameters
    % 5. Maximum likelihood estimation of alpha-stable parameters
    % 6. Fast calculation by Federico Simmross using the estimations
    % 7. Fast calculation by Federico Simmross with MLE, if error METODO 2
    
    k = 1;
    size_ventana = ventana * 60;
    for i = indice_comienzo:indice_final
        fprintf('%d/%d\n', i, indice_final);
        datos_env = datos(i:i + size_ventana - 1);
        % BOOTSTRAP
        array_aleatorio = randi([1,size_ventana],1,1000); % Generar array de 1000 valores aleatorios entre 1 y 900
        bootstrap = zeros(1,1000);
        for i = 1:1000
            bootstrap(i) = datos_env(array_aleatorio(i)); %% Array de 1000 con los valores de cada posicion
        end
        %F.Distribucion empirica -> Bootstrap
        switch metodo
            case 1
                [params] = stblfit(datos_env, 'ecf');
            case 2
                [params] = stblfit(datos_env, 'percentile');
            case 3
                pars_init1 = stable_fit_init(datos_env, 0, false);
                [params] = stable_fit_koutrouvelis(datos_env, pars_init1, 0,[],[],false);
            case 4
                pars_init2 = stable_fit_init(datos_env, 0, false);
                [params] = stable_fit_mle2d(datos_env, pars_init2, 0,[],[],false); 
            case 5
                pars_init3 = stable_fit_init(datos_env, 0, false);
                [params] = stable_fit_mle(datos_env, pars_init3, 0,[],[],false);
            case 6
                % Estimacion gamma
                q1 = prctile(datos_env, 25);
                q3 = prctile(datos_env, 75);
                inf = q1 -1.5*(q3-q1);
                sup = q3 +1.5*(q3-q1);
                datos_env_filtrados = datos_env(datos_env >= inf & datos_env <= sup); % Nos quedamos con los valores de dentro(tipicos)
                gamma_0_4 = std(datos_env_filtrados);
                % Estimacion delta
                % OPCION 1: MODA
                x = linspace(min(datos_env), max(datos_env), 1000);
                [f, xi,bw] = ksdensity(datos_env, x);
                [~, idx] = max(f);% Valor de xi que maximiza la densidad f
                mode_estimate = xi(idx);
                delta_0_4 = mode_estimate;

                datos_env_norm = (datos_env - delta_0_4)/gamma_0_4;

                params_init4 = stablefit_init(datos_env_norm);
                [a,b,c,d]=stablefit(datos_env_norm,params_init4);

                Rand = random('Stable',a,b,gamma_0_4,delta_0_4,[1,1000]);

                alpha(k) = a;
                beta(k) = b;
                gamma(k) = gamma_0_4;
                delta(k) = delta_0_4;               
            case 7
                % Estimacion gamma
                q1 = prctile(datos_env, 25);
                q3 = prctile(datos_env, 75);
                inf = q1 -1.5*(q3-q1);
                sup = q3 +1.5*(q3-q1);
                datos_env_filtrados = datos_env(datos_env >= inf & datos_env <= sup); % Nos quedamos con los valores de dentro(tipicos)
                gamma_0_4 = std(datos_env_filtrados);
                % Estimacion delta
                % OPCION 1: MODA
                x = linspace(min(datos_env), max(datos_env), 1000);
                [f, xi,bw] = ksdensity(datos_env, x);
                [~, idx] = max(f);% Valor de xi que maximiza la densidad f
                mode_estimate = xi(idx);
                delta_0_4 = mode_estimate;

                datos_env_norm = (datos_env - delta_0_4)/gamma_0_4;

                params_init4 = stablefit_init(datos_env_norm);
                [a,b,c,d]=stablefit(datos_env_norm,params_init4);

                try
                    mle_v = mle(datos_env, 'Distribution', 'stable', 'Start', [a b gamma_0_4 delta_0_4]);
                    Rand = random('Stable',mle_v(1),mle_v(2),mle_v(3),mle_v(4),[1,1000]);
                    alpha(k) = mle_v(1);
                    beta(k) = mle_v(2);
                    gamma(k) = mle_v(3);
                    delta(k) = mle_v(4);

                catch ME
                    disp('Error en la estimación con MLE. Ejecutando cálculo alternativo.');
                    pars_init2 = stable_fit_init(datos_env, 0, false);
                    [params] = stable_fit_mle2d(datos_env, pars_init2, 0,[],[],false);
  
                    Rand = random('Stable',params(1),params(2),params(3),params(4),[1,1000]);
                    alpha(k) = params(1);
                    beta(k) = params(2);
                    gamma(k) = params(3);
                    delta(k) = params(4);
                end
        end
        %F.Distribucion hipotetica -> Rand
        if metodo == 3 || metodo == 4 || metodo == 5 || metodo == 1 || metodo == 2
            Rand = random('Stable',params(1),params(2),params(3),params(4),[1,1000]);
            alpha(k) = params(1);
            beta(k) = params(2);
            gamma(k) = params(3);
            delta(k) = params(4);
        end

        [~,~,ks2stat] = kstest2(bootstrap,Rand);
        distancias_ks(k) = ks2stat;
        k = k + 1;
            

       
    end
    alpha = alpha';
    beta = beta';
    gamma = gamma';
    delta = delta';
end