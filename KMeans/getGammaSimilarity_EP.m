function [S,assig, gamma2] = getGammaSimilarity (gamma1, gamma2)

% Gamma is a matrix (time points by states), with the probabilities for each state 
% to be active at each time point. I might need to use distance metrics for
% k means. Should it be normalized? Or just use binarized probabilities?
% e.g. 7200 x 5 double, 10 subs, 5 states

% Computes a measure of similarity between two sets of state time courses.
% These can have different number of states, but they must have the same
% number of time points. 
% If gamma2 is a cell, then it aggregates the similarity measures across
% elements of gamma2 
% S: similarity, measured as the sum of joint probabilities under the
%       optimal state alignment
% assig: optimal state aligmnent for gamma2 (uses munkres' algorithm)
% gamma2: the second set of state time courses reordered to match gamma1
%
% Author: Diego Vidaurre, University of Oxford (2017)

% EP: gamma as the default output from HMMMAR is not a cell
if iscell(gamma2), N = length(gamma2); 
else, N = 1; 
end

[T, K] = size(gamma1);

% gamma is timepoints x k states: one probabilistic timecourse for each
% state.

gamma1_0 = gamma1; 

% EP: initialize matrix
% EP: OK, so I think that by "reorder" they mean relabel states...
M = zeros(K,K); % cost

% for each element in timeseries 1:
for j = 1:N
    
    % look at the corresponding element in timeseries 2
    if iscell(gamma2), g = gamma2{j};
    else g = gamma2;
    end
    
    % note the number of states
    K2 = size(g,2);
    
    % if gamma2 has more states than gamma1:
    if K < K2
        gamma1 = [gamma1_0 zeros(T,K2-K)]; % add extra columns for extra states
        K = K2;
    % if gamma1 has more states than gamma2:
    elseif K>K2
        g = [g zeros(T,K-K2)]; % add extra columns for extra states
    end
    
    % for each pair of states between runs:
    for k1 = 1:K
        for k2 = 1:K
            % EP: min(gamma1(:,k1), g(:,k2)) gives you the lowest probability
            % timecourse - at each timepoint it selects the lower
            % probability state k1 or k2.
            % If there's not a lot of overlap, this will include a lot of
            % zeros (one state is off when the other is on).
            % If there's more overlap, it will be further from zero.
            % Subtract that probability from # of timepoints, and normalize by
            % number of timepoints and number of runs (usually N =
            % 1) to estimate inverse probability, which is like probability of overlap.
            % Why add to M(k1,k2)?
            % M(k1,k2) ~ higher for more overlap
            % M(k1,k2) ~ lower for less overlap
            % Why not just do correlation?
            M(k1,k2) = M(k1,k2) + (T - sum(min(gamma1(:,k1), g(:,k2)))) / T / N;
        end
    end
    
end

% EP: so I think this relabels the states based on the best fitting
% alignment
% EP: why do it this way and not based on spatial similarity of states?

[assig,cost] = munkres(M);
S = K - cost;

% if there's a 3rd argument, reassign gamma2 with new state labels
if nargout > 2
    gamma2 = gamma2(:,assig);
end

end