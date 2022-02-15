function v = permutationGame(C)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input: C
%Cost matrix. The element C(i, j) = c represents the cost c for player i
%when using machine j.
%
%Output: Characteristic function
%Represents the savings of each coalition. 
%The elements of this vector are arranged in the following way:
% [ "Subsets of 1 player" "Subsets of 2 players" ... "Subset of n players"]
% The elements of the subsets of k players are arranged in lexicografic
% order.
% Example: 4 players
% [1 2 3 4   12 13 14 23 24 34  123 124 134 234  1234] 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[filas, columnas] = size(C);
if filas ~= columnas
    error('Wrong matrix');
end

v = zeros(1, 2^filas-1);

subsets = generateOrderedSubsets(filas);

for index_coalition = 2:length(subsets)    
    v(index_coalition-1) = calculate_savings(C, subsets(index_coalition));
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savings = calculate_savings(C, subset)

original_cost = sum(C(sub2ind(size(C),subset.players,subset.players)));

permutation_set = perms(subset.players);
num_permutations = factorial(length(subset.players));
min_cost = zeros(1, num_permutations);

for i=1:num_permutations
    min_cost(i) = sum(C(sub2ind(size(C),subset.players,permutation_set(i,:))));
end

savings = original_cost - min(min_cost);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function subsets = generateOrderedSubsets(n)
subsets = [];
decimalExpression = [];

allSubsets = fliplr(dec2bin(0:2^n-1)-'0');

for i=1:n
    allSubsets(:,i) = i*allSubsets(:,i);
end

for i=2:2^n
    decimalExpression = [decimalExpression str2double(sprintf('%d',allSubsets(i, allSubsets(i,:)~=0)))];    
end
decimalExpression = [0 sort(decimalExpression)];

for i=1:2^n
    subsets(i).players = num2str(decimalExpression(i))-'0';
end
subsets(1).players = [];
end
