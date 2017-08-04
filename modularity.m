function [ Q ] = modularity( input_X,N,K,Cluster )
%MODULARITY Summary of this function goes here
%   Detailed explanation goes here

W = zeros(K,K);

num_edges = 0;
nonzeros = input_X.subs;
numnnz = size(nonzeros,1);
for n=1:N
   A = sptenmat(input_X,n);
   num_edges = num_edges + nnz(A);
end
for i=1:K
    i
    for j=1:K
        j
        tem=0;
        for t= 1:numnnz
            obj = nonzeros(t,:);
            for n1 = 1:N-1
                for n2=n1+1:N
                    isedge = Cluster{1,n1}(obj(1,n1),i)*Cluster{1,n2}(obj(1,n2),j);
                    if isedge == 1
                        tem = tem+1;
                    end
                end
            end
        end
        W(i,j) = tem/num_edges;
    end
end


Q = trace(W)-sum(sum(W^2));

end

