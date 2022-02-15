function Shapley_p = shapleyValue_p_Calculator(charFunc,lambda,partition)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input:
%data = charFunc = v = [v(1), v(2), v(3), v(12), v(13), v(23), ....]
%lambda = [lambda(player1), ..., lambda(playerN)];
%partition = [1, 23, 4] (for example)
%
%Output: Shapley vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[numPlayers, coalitions] = assignCharFunctionToCoalitions(charFunc);
checkInputParametersAreCorrect(numPlayers, lambda, partition);

HD = obtainHarsanyDividends(coalitions, charFunc);
Shapley_u = shapley_u_matrix(numPlayers, coalitions, lambda, partition);
Shapley_p = (Shapley_u*HD)';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [numPlayers, coalitions] = assignCharFunctionToCoalitions(charFunc)

numPlayers = log(length(charFunc) + 1)/log(2);
if(round(numPlayers) ~= numPlayers)
    error('Wrong Characteristic Function');
end

coalitions = generateOrderedSubsets(numPlayers);

%Assign v value to coalitions
coalitions(1).v = 0;
for i=2:2^numPlayers
    coalitions(i).v = charFunc(i-1);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function checkInputParametersAreCorrect(numPlayers, lambda, partition)
if(length(lambda) ~= numPlayers)
    error('Wrong Lambda');
end

v = [];
for i=1:length(partition)
    v = [v num2str(partition(i))-'0'];
end
if(length(v) ~= numPlayers)||sum(v)~=numPlayers*(numPlayers+1)/2
    error('Wrong Partition');
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function HD = obtainHarsanyDividends(coalitions, charFunc)
unanimidad = zeros(length(charFunc));
for fila = 2:length(coalitions)
    for columna = 2:length(coalitions)
        unanimidad(fila-1, columna-1) = ((length(intersect(coalitions(fila).players,coalitions(columna).players)) == length(coalitions(fila).players)) ...
            && length(coalitions(fila).players)<=length(coalitions(columna).players));
    end
end
HD = unanimidad'\charFunc';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Shapley_u = shapley_u_matrix(numPlayers, coalitions, lambda, partition)
Shapley_u = zeros(numPlayers, length(coalitions)-1);

k = obtain_k_vector(coalitions, partition);

for player = 1:numPlayers
    for coalition = 1:length(coalitions)-1        
        current_set = intersect(num2str(partition(k(coalition)))-'0',coalitions(coalition+1).players);
         if ~isempty(find(player == current_set, 1))
             Shapley_u(player, coalition) = lambda(player)/sum(lambda(current_set));
         else
             Shapley_u(player, coalition) = 0;
         end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function k = obtain_k_vector(coalitions, partition)

k = zeros(1,length(coalitions)-1);

for i = 1:length(coalitions)-1
    aux = zeros(1,length(partition));
    for j=1:length(partition)
        if ~isempty(intersect(coalitions(i+1).players,num2str(partition(j))-'0'))
            aux(j) = j;
        end
    end
    k(i) = max(aux);
end

end