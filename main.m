%% Step 1: Generate Input Bits
RUID = 208001821;
rng(RUID);
N = 10000;
bb = randi([0 1], 1, N);
disp('First 10 bits of bb:');
disp(bb(1:10));

%% Step 2: Binary Symmetric Channel (BSC)
J = 10;
p_vals = 2.^-(1:J);
ee = zeros(J, N);
bbg = zeros(J, N);
simulated_errors = zeros(1, J);

for j = 1:J
    p = p_vals(j);
    ee(j,:) = rand(1, N) < p;
    bbg(j,:) = xor(bb, ee(j,:));
    simulated_errors(j) = sum(bbg(j,:) ~= bb);
end

% 2a. Analytical Probability of Error (same as p)
P_error_analytical = p_vals;

% 2b. Expected number of errors
expected_errors_analytical = N * P_error_analytical;

% 2c. Expected number of errors per bit
expected_errors_per_bit = P_error_analytical;

% 2d. Simulated errors per bit
simulated_errors_per_bit = simulated_errors / N;

% 2e. Mean square error
mse_error = mean((simulated_errors - expected_errors_analytical).^2);

%% Step 2 Plots
figure;
semilogx(p_vals, simulated_errors_per_bit, 'o-', 'LineWidth', 1.5); hold on;
semilogx(p_vals, expected_errors_per_bit, 'x--', 'LineWidth', 1.5);
xlabel('Error Probability p');
ylabel('Average Bit Error Rate');
title('BSC Channel - Bit Error Rate vs p');
legend('Simulated', 'Analytical');
grid on;

%% Step 3: Additive White Gaussian Noise (AWGN) Channel
SNRdB = 0:7;
SNR = 10.^(SNRdB / 10);
aa = 2*bb - 1;
simulated_awgn_errors = zeros(1, length(SNR));
be_awgn = zeros(length(SNR), N);

for j = 1:length(SNR)
    sigma = sqrt(1 / (2*SNR(j)));
    noise = sigma * randn(1, N);
    rr = aa + noise;
    be_awgn(j,:) = rr > 0;
    simulated_awgn_errors(j) = sum(be_awgn(j,:) ~= bb);
end

% 3a. Analytical error probability using Q-function
P_awgn_analytical = qfunc(sqrt(2*SNR));

% 3b. Expected number of errors
expected_awgn_errors = N * P_awgn_analytical;
expected_awgn_errors_per_bit = P_awgn_analytical;

% 3c. Simulated errors per bit
simulated_awgn_errors_per_bit = simulated_awgn_errors / N;

%% Step 3 Plots
figure;
semilogy(SNRdB, simulated_awgn_errors_per_bit, 'o-', 'LineWidth', 1.5); hold on;
semilogy(SNRdB, expected_awgn_errors_per_bit, 'x--', 'LineWidth', 1.5);
xlabel('SNR (dB)');
ylabel('Average Bit Error Rate');
title('AWGN Channel - Bit Error Rate vs SNR');
legend('Simulated', 'Analytical');
grid on;
