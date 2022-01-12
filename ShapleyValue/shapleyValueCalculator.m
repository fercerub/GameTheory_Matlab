function shapleyValueCalculator(charFunc)
clc;
tic;
[numPlayers, coalitions] = assignCharFunctionToCoalitions(charFunc);
shapleyVector = zeros(1, numPlayers);

factor = zeros(1, length(coalitions));
contribution = zeros(1, length(coalitions));

for player=1:numPlayers
    factor(:) = 0;
    contribution(:) = 0;
    for coalitionIndex=1:length(coalitions)
        if(playerBelongsToCoalition(coalitions(coalitionIndex), player))           
            S = length(coalitions(coalitionIndex).players);           
            factor(coalitionIndex) = factorial(numPlayers-S)*factorial(S - 1)/factorial(numPlayers);
            contribution(coalitionIndex) = calculateContribution(coalitions, coalitionIndex, player);                    
        end
    end
    shapleyVector(player) = factor*contribution';
end
 
disp('Shapley Vector');
disp(shapleyVector);
toc;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function response = playerBelongsToCoalition (coalition, player)

response = (~isempty(find(player == coalition.players, 1)));

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function contribution = calculateContribution (coalitions, coalitionIndex, player)

coalitionWithoutPlayer = coalitions(coalitionIndex).players(coalitions(coalitionIndex).players~=player);

for i=1:length(coalitions)
  if(isequal(sort(coalitions(i).players), sort(coalitionWithoutPlayer)))
    contribution = coalitions(coalitionIndex).v - coalitions(i).v;
    return;
  end
end
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
