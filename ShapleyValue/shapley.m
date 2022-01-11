function shapley(charFunc)
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
aux = [];

all_subsets = fliplr(dec2bin(0:2^n-1)-'0');

for i=1:n
    all_subsets(:,i) = i*all_subsets(:,i);
end

for i=2:2^n
    aux = [aux str2double(sprintf('%d',all_subsets(i, all_subsets(i,:)~=0)))];    
end
aux = [0 sort(aux)];

for i=1:2^n
    subsets(i).players = num2str(aux(i))-'0';
end
subsets(1).players = [];
end
