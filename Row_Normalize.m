function [ U ] = Row_Normalize( U )
%ROW_NORMALIZE Summary of this function goes here
%   Detailed explanation goes here
% normalize the row of the input factor matrix
% Nt is the row number
N = size(U,2);
for n=1:N
    [r,c] = size(U{1,n});
    U{1,n}(U{1,n}<0)=0;
    for i = 1:r
        sumofrow = sum(U{1,n}(i,:));
        if sumofrow == 0
            U{1,n}(i,:)=rand(1,c);
            sumofrow = sum(U{1,n}(i,:));
        end
        U{1,n}(i,:) = U{1,n}(i,:)/sumofrow;
    end
end

end

