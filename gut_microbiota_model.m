function run_gut_microbiota_model()
    % Simulation time setup
    t_start = 365;      % 12 months (in days)
    t_end = 1095;       % 36 months (in days)
    tspan = [t_start, t_end];
    
    % Initial conditions [X1, X2, X3, X4, X5, X6, M] at t = 12
    y0 = [0.16; 0.11; 0.07; 0.56; 0.07; 0.04; 0.001]; 
    
    % Model parameters
    params.r = [1.0; 1.0; 1.0; 0.8; 0.6; 0.6];       % Growth rates per day
    params.theta_m = [0.9; 0.5; 0.7; 0.3; 0.2; 0.2]; % Milk affinity
    params.theta_s = [0.1; 0.4; 0.3; 0.6; 0.5; 0.8];   % Solid/host-glycan affinity
    params.f = [0.01; 0.03; 0.05; 0.03; 0.02; 0.02];% Environmental supply rates
    params.mu = [50; 50; 50; 200; 200; 200];        % Immune clearance rates
    params.w = [1; 0; 0; 0; 0; 0];                  % Immune stimulation weights
    params.gamma = 0.0001;                          % Immune production coefficient
    params.delta = 0.01;                            % Immune decay rate
    params.omega = 0.014;                           % Weaning rate per day
    
    % Cross-feeding matrix chi (chi_ij: cross-feeding benefits to species i from
    % species j
    
    params.chi = [ 0.00, 0.00, 0.50, 0.25, 0.00, 0.00;
                   0.25, 0.00, 1.00, 0.25, 0.00, 0.00;
                   0.00, 0.00, 0.00, 0.00, 0.00, 0.00;
                   0.25, 0.25, 0.50, 0.00, 0.00, 0.00;
                   0.50, 0.50, 0.50, 0.25, 0.00, 0.00;
                   0.50, 0.50, 0.50, 0.25, 0.00, 0.00];
    
    
    % Competition matrix A 
    % Species order: B_i (infantis), B_b (breve), B_r (bifidum), B_a
    % (Bacteroides), F (Faecalibacterium), R (Roseburia)
    
    params.A = [ 1.00, 1.00, 0.50, 0.50, 0.25, 0.25;   % B_i
                 1.00, 1.00, 0.50, 0.50, 0.25, 0.25;   % B_b
                 0.50, 0.50, 1.00, 1.00, 0.25, 0.25;   % B_r
                 0.50, 0.50, 1.00, 1.00, 0.25, 0.50;   % B_a
                 0.25, 0.25, 0.25, 0.25, 1.00, 0.50;   % F
                 0.25, 0.25, 0.25, 0.50, 0.50, 1.00]; % R

    
    % ODE Solver Options (using stiff solver ode15s)
    options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
    
    % -------------------------------------------------------------------
    % Solve Scenario 1: Cessation at 12 months (h = 365 days)
    % -------------------------------------------------------------------
    params.h = 365;
    [t_cess, y_cess] = ode15s(@(t, y) microbiota_ode(t, y, params), tspan, y0, options);
    
    % -------------------------------------------------------------------
    % Solve Scenario 2: Continued Breastfeeding to 36 months (h = 1095 days)
    % -------------------------------------------------------------------
    params.h = 1095;
    [t_cont, y_cont] = ode15s(@(t, y) microbiota_ode(t, y, params), tspan, y0, options);
    
    % Convert time from days to age in months
    t_cess_mo = t_cess / 30.4167;
    t_cont_mo = t_cont / 30.4167;
    
    % Define color palette 
    colors = [0.20 0.50 0.72;   % X1: B. infantis (blue)
              0.30 0.69 0.29;   % X2: B. breve (green)
              0.22 0.79 0.85;   % X3: B. bifidum (cyan)
              0.84 0.28 0.28;   % X4: Bacteroides (red)
              0.61 0.44 0.72;   % X5: Faecalibacterium (purple)
              0.55 0.34 0.29];  % X6: Roseburia group (brown)
          
    taxa_labels = {'B. infantis', 'B. breve', 'B. bifidum', ...
                   'Bacteroides', 'Faecalibacterium', 'Roseburia group'};
    % ===================================================================
    % FIGURE 1: Log-scale Species Trajectories
    % ===================================================================
    figure('Name', 'Figure 1 - Species Trajectories', 'Position', [50, 400, 1100, 420]);
    
    subplot(1, 2, 1);
    for i = 1:6
        semilogy(t_cess_mo, y_cess(:, i), 'LineWidth', 2, 'Color', colors(i, :));
        hold on;
    end
    grid on; ylim([1e-4, 2]); xlim([12, 36]);
    title('Cessation at 12 months (h = 365 d)');
    xlabel('Age (months)'); ylabel('Density (non-dim., /K)');
    legend(taxa_labels, 'Location', 'southwest');
    
    subplot(1, 2, 2);
    for i = 1:6
        semilogy(t_cont_mo, y_cont(:, i), 'LineWidth', 2, 'Color', colors(i, :));
        hold on;
    end
    grid on; ylim([1e-4, 2]); xlim([12, 36]);
    title('Continued breastfeeding to 36 months (h = 1095 d)');
    xlabel('Age (months)'); ylabel('Density (non-dim., /K)');
    % ===================================================================
    % FIGURE 2: Community Composition as Relative Abundance
    % ===================================================================
    % Calculate relative abundances (normalizing by sum of species)
    rel_cess = y_cess(:, 1:6) ./ sum(y_cess(:, 1:6), 2);
    rel_cont = y_cont(:, 1:6) ./ sum(y_cont(:, 1:6), 2);
    
    figure('Name', 'Figure 2 - Relative Abundance', 'Position', [50, 200, 1100, 420]);
    
    subplot(1, 2, 1);
    h_area1 = area(t_cess_mo, rel_cess);
    for i = 1:6
        h_area1(i).FaceColor = colors(i, :);
    end
    xlim([12, 36]); ylim([0, 1]); grid on;
    title('Cessation at 12 months (h = 365 d)');
    xlabel('Age (months)'); ylabel('Relative abundance');
    legend(taxa_labels, 'Location', 'eastoutside');
    
    subplot(1, 2, 2);
    h_area2 = area(t_cont_mo, rel_cont);
    for i = 1:6
        h_area2(i).FaceColor = colors(i, :);
    end
    xlim([12, 36]); ylim([0, 1]); grid on;
    title('Continued breastfeeding to 36 months (h = 1095 d)');
    xlabel('Age (months)'); ylabel('Relative abundance');
    % ===================================================================
    % FIGURE 3: Mechanism Panels (Guild Totals, Immune Factor M, Diet Z)
    % ===================================================================
    % Compute Guild Totals
    bifido_cess = sum(y_cess(:, 1:3), 2);
    adult_cess  = sum(y_cess(:, 4:6), 2);
    
    bifido_cont = sum(y_cont(:, 1:3), 2);
    adult_cont  = sum(y_cont(:, 4:6), 2);
    
    % Compute Milk Fraction Z(t)
    Z_cess = 1 ./ (1 + exp(params.omega * (t_cess - 365)));
    Z_cont = 1 ./ (1 + exp(params.omega * (t_cont - 1095)));
    
    figure('Name', 'Figure 3 - Mechanism Panels', 'Position', [50, 50, 1200, 350]);
    
    % Panel 1: Guild totals
    subplot(1, 3, 1);
    plot(t_cess_mo, bifido_cess, 'r-', 'LineWidth', 2); hold on;
    plot(t_cess_mo, adult_cess,  'Color', [0.9 0.6 0.6], 'LineWidth', 2);
    plot(t_cont_mo, bifido_cont, 'b--', 'LineWidth', 2);
    plot(t_cont_mo, adult_cont,  'Color', [0.6 0.8 0.9], 'LineWidth', 2, 'LineStyle', '--');
    grid on; xlim([12, 36]);
    title('Guild totals: Bifido. vs adult-like');
    xlabel('Age (months)'); ylabel('Total density');
    legend({'Cessation: Bifidobacteria', 'Cessation: Adult-like', ...
            'Continued: Bifidobacteria', 'Continued: Adult-like'}, 'Location', 'best');
        
    % Panel 2: Immune factor M(t)
    subplot(1, 3, 2);
    plot(t_cess_mo, y_cess(:, 7), 'r-', 'LineWidth', 2); hold on;
    plot(t_cont_mo, y_cont(:, 7), 'b--', 'LineWidth', 2);
    grid on; xlim([12, 36]);
    title('Immune factor M');
    xlabel('Age (months)'); ylabel('M(t)');
    legend({'Cessation at 12 months', 'Continued breastfeeding'}, 'Location', 'best');
    
    % Panel 3: Milk fraction Z(t)
    subplot(1, 3, 3);
    plot(t_cess_mo, Z_cess, 'r-', 'LineWidth', 2); hold on;
    plot(t_cont_mo, Z_cont, 'b--', 'LineWidth', 2);
    grid on; xlim([12, 36]); ylim([0, 1.05]);
    title('Milk fraction of diet Z(t)');
    xlabel('Age (months)'); ylabel('Z(t)');
    legend({'Cessation at 12 months', 'Continued breastfeeding'}, 'Location', 'best');
end
% =======================================================================
% ODE System Definition
% =======================================================================
function dydt = microbiota_ode(t, y, p)
    X = y(1:6);
    M = y(7);
    
    % 1. Milk proportion in diet Z(t)
    Z = 1 / (1 + exp(p.omega * (t - p.h)));
    
    % 2. Effective Resource Space S_i(t)
    S = p.theta_m * Z + p.theta_s * (1 - Z) + p.chi * X;
    
    % 3. System competition sum_j(a_ij * X_j)
    competition = p.A * X;
    
    % 4. Species derivatives dX_i/dt
    dXdt = p.r .* X .* (S - competition) + p.f - p.mu .* M .* X;
    
    % 5. Immune compartment derivative dM/dt
    dMdt = p.gamma * sum(p.w .* X) - p.delta * M;
    
    dydt = [dXdt; dMdt];
end
