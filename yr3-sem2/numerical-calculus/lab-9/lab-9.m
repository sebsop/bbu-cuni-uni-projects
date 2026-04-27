%% Lab Nr. 9: Splines and Least Squares
clear; clc; close all;

%% --- Application 1: Spline vs Lagrange vs Hermite ---
fprintf('--- Application 1: Comparison of Interpolants ---\n');
f1 = @(x) (x + 1) ./ (3*x.^2 + 2*x + 1);
x_nodes = linspace(-2, 4, 7);
y_nodes = f1(x_nodes);
x_plot = linspace(-2, 4, 1000);

% 1. Lagrange (using polyfit/polyval for simplicity here)
p_lagrange = polyfit(x_nodes, y_nodes, length(x_nodes)-1);
y_lagrange = polyval(p_lagrange, x_plot);

% 2. Cubic Spline (de Boor / Not-a-knot)
y_spline = spline(x_nodes, y_nodes, x_plot);

% 3. Hermite (PCHIP is a piecewise Hermite)
y_hermite = pchip(x_nodes, y_nodes, x_plot);

figure('Name', 'App 1: Interpolation Methods');
plot(x_plot, f1(x_plot), 'k', 'LineWidth', 2); hold on;
plot(x_nodes, y_nodes, 'ko', 'MarkerFaceColor', 'y');
plot(x_plot, y_lagrange, 'r--');
plot(x_plot, y_spline, 'b-');
plot(x_plot, y_hermite, 'g:');
legend('True f(x)', 'Nodes', 'Lagrange', 'Cubic Spline', 'PCHIP/Hermite');
title('7-Node Interpolation Comparison'); grid on;


%% --- Application 2: Different Spline Types ---
fprintf('--- Application 2: Spline Variants ---\n');
f2 = @(x) x .* sin(pi * x);
x2 = [-1, -1/2, 0, 1/2, 1, 3/2];
y2 = f2(x2);
x2_plot = linspace(-1, 3/2, 1000);

% a) Obtain Splines
% de Boor (Not-a-knot)
s_deBoor = spline(x2, y2, x2_plot);

% Complete Spline (Requires derivatives at endpoints)
% f'(x) = sin(pi*x) + x*pi*cos(pi*x)
df = @(x) sin(pi*x) + pi*x.*cos(pi*x);
s_complete = spline(x2, [df(-1), y2, df(3/2)], x2_plot);

% Piecewise Hermite
s_pchip = pchip(x2, y2, x2_plot);

figure('Name', 'App 2: Spline Types');
plot(x2_plot, f2(x2_plot), 'k', 'LineWidth', 1.5); hold on;
plot(x2, y2, 'ko');
plot(x2_plot, s_deBoor, 'r-');
plot(x2_plot, s_complete, 'b--');
plot(x2_plot, s_pchip, 'g:');
legend('f(x)', 'Nodes', 'de Boor', 'Complete', 'Hermite (PCHIP)');
title('Cubic Spline Variations'); grid on;


%% --- Application 3: Least Squares Fitting ---
fprintf('\n--- Application 3: Least Squares Fitting ---\n');
x3 = [0.5, 1.5, 2, 3, 3.5, 4.5, 5, 6, 7, 8];
f3 = [5, 5.8, 5.8, 6.8, 6.9, 7.6, 7.8, 8.2, 9.2, 9.9];

% a) Fit a line (degree 1)
p3 = polyfit(x3, f3, 1);
y3_fit = polyval(p3, x3);

% b) Compute Error (Norm of residuals)
err3 = norm(f3 - y3_fit);
fprintf('Least Squares Error (Norm): %.4f\n', err3);

% c) Estimate at x = 4
val4 = polyval(p3, 4);
fprintf('Estimated value at x=4: %.4f\n', val4);

% d) Plot
figure('Name', 'App 3: Least Squares');
scatter(x3, f3, 'filled'); hold on;
plot(x3, y3_fit, 'r-', 'LineWidth', 2);
title('Linear Least Squares Fit'); grid on;


%% --- Application 4: Vapor Pressure ---
fprintf('\n--- Application 4: Water Vapor Pressure ---\n');
T = [0, 10, 20, 30, 40, 60, 80, 100];
P = [0.0061, 0.0123, 0.0234, 0.0424, 0.0738, 0.1992, 0.4736, 1.0133];

% Quadratic fit
p_quad = polyfit(T, P, 2);
err_quad = norm(P - polyval(p_quad, T));

% Cubic fit
p_cubic = polyfit(T, P, 3);
err_cubic = norm(P - polyval(p_cubic, T));

fprintf('Quadratic Error: %.6f\n', err_quad);
fprintf('Cubic Error: %.6f\n', err_cubic);
fprintf('The Cubic approximation is better (lower error).\n');

% b) Approximate at T = 45
P45 = polyval(p_cubic, 45);
fprintf('Pressure at T=45: %.4f bar\n', P45);

figure('Name', 'App 4: Vapor Pressure');
plot(T, P, 'ko', 'MarkerSize', 8); hold on;
T_plot = linspace(0, 100, 100);
plot(T_plot, polyval(p_quad, T_plot), 'b--');
plot(T_plot, polyval(p_cubic, T_plot), 'r-');
legend('Data', 'Quadratic', 'Cubic');
title('Vapor Pressure: Quadratic vs Cubic Least Squares'); grid on;