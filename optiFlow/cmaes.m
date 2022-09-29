function [xmin,ymin]=cmaes(nVar, iniVal, BC, sigma, stopfitness, stopeval, normalPara, ObjFun)   % (mu/mu_w, lambda)-CMA-ES
% --------------------  Initialization --------------------------------
% User defined input parameters (need to be edited)
N = nVar;
xmean = iniVal;

% Strategy parameter setting: Selection
lambda = 4+floor(3*log(N));  % population size, offspring number
mu = lambda/2;               % number of parents/points for recombination
weights = log(mu+1/2)-log(1:mu)'; % muXone array for weighted recombination
mu = floor(mu);
weights = weights/sum(weights);     % normalize recombination weights array
mueff=sum(weights)^2/sum(weights.^2); % variance-effectiveness of sum w_i x_i
disp('Population size:');
disp(lambda);

% Strategy parameter setting: Adaptation
cc = (4+mueff/N) / (N+4 + 2*mueff/N);  % time constant for cumulation for C
cs = (mueff+2) / (N+mueff+5);  % t-const for cumulation for sigma control
c1 = 2 / ((N+1.3)^2+mueff);    % learning rate for rank-one update of C
cmu = min(1-c1, 2 * (mueff-2+1/mueff) / ((N+2)^2+mueff));  % and for rank-mu update
damps = 1 + 2*max(0, sqrt((mueff-1)/(N+1))-1) + cs; % damping for sigma
% usually close to 1
% Initialize dynamic (internal) strategy parameters and constants
pc = zeros(N,1); ps = zeros(N,1);   % evolution paths for C and sigma
B = eye(N,N);                       % B defines the coordinate system
D = ones(N,1);                      % diagonal D defines the scaling
C = B * diag(D.^2) * B';            % covariance matrix C
invsqrtC = B * diag(D.^-1) * B';    % C^-1/2
eigeneval = 0;                      % track update of B and D
chiN=N^0.5*(1-1/(4*N)+1/(21*N^2));  % expectation of
% figure(1);
%   ||N(0,I)|| == norm(randn(N,1))
% -------------------- Generation Loop --------------------------------
counteval = 1;  % the next 40 lines contain the 20 lines of interesting code
genCount = 1;
while counteval < stopeval
    % Generate and evaluate lambda offspring
    for k=1:lambda
        arx(:,k) = xmean + sigma * B * (D .* randn(N,1)); % m + sig * Normal(0,C)
%         arfitness(k) = rosenbrock(arx(:,k)); % objective function call
        % set BC
        for ii=1: 1: nVar
            if arx(ii,k)*normalPara(ii) < BC(ii,1)
                arx(ii,k) = BC(ii,1)/normalPara(ii);
            end
            if arx(ii,k)*normalPara(ii) > BC(ii,2)
                arx(ii,k) = BC(ii,2)/normalPara(ii);
            end
        end

        arfitness(k) = feval(ObjFun, arx(:,k).*normalPara, counteval); % objective function call
        writematrix([arx(:,k)', arfitness(k)], './dataOutput/dataMatrixOutput.xlsx', 'WriteMode', 'append');
        counteval = counteval+1;
        disp('Currently finished calculation:');
        disp(counteval);
    end
    % Sort by fitness and compute weighted mean into xmean
    [arfitness, arindex] = sort(arfitness); % minimization
%     scatter3(arx(1,arindex(1)),arx(2,arindex(1)),arfitness(1));
%     hold on
    xold = xmean;
    xmean = arx(:,arindex(1:mu))*weights;   % recombination, new mean value
    xmin(genCount,:) = arx(:, arindex(1)); % Return best point of each iteration.
    ymin(genCount) = arfitness(1); % Return best point value of each iteration.
    disp(xmin(genCount,:));
    disp(ymin(genCount));
    genCount = genCount + 1;
    % Cumulation: Update evolution paths
    ps = (1-cs)*ps ...
        + sqrt(cs*(2-cs)*mueff) * invsqrtC * (xmean-xold) / sigma;
    hsig = norm(ps)/sqrt(1-(1-cs)^(2*counteval/lambda))/chiN < 1.4 + 2/(N+1);
    pc = (1-cc)*pc ...
        + hsig * sqrt(cc*(2-cc)*mueff) * (xmean-xold) / sigma;

    % Adapt covariance matrix C
    artmp = (1/sigma) * (arx(:,arindex(1:mu))-repmat(xold,1,mu));
    C = (1-c1-cmu) * C ...                  % regard old matrix
        + c1 * (pc*pc' ...                 % plus rank one update
        + (1-hsig) * cc*(2-cc) * C) ... % minor correction if hsig==0
        + cmu * artmp * diag(weights) * artmp'; % plus rank mu update

    % Adapt step size sigma
    sigma = sigma * exp((cs/damps)*(norm(ps)/chiN - 1));

    % Decomposition of C into B*diag(D.^2)*B' (diagonalization)
    if counteval - eigeneval > lambda/(c1+cmu)/N/10  % to achieve O(N^2)
        eigeneval = counteval;
        C = triu(C) + triu(C,1)'; % enforce symmetry
        [B,D] = eig(C);           % eigen decomposition, B==normalized eigenvectors
        D = sqrt(diag(D));        % D is a vector of standard deviations now
        invsqrtC = B * diag(D.^-1) * B';
    end

    % Break, if fitness is good enough or condition exceeds 1e14, better termination methods are advisable
    if arfitness(1) <= stopfitness || max(D) > 1e7 * min(D)
        break;
    end

end % while, end generation loop


% Notice that xmean is expected to be even
% better.
end