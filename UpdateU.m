function [ Un ] = UpdateU( U,n,input_X,N,K,eta,lambda,U_pre,choice)
%UPDATEU Summary of this function goes here
%   Detailed explanation goes here

    Gamma=ones(K,K);
    for i = 1:N
        if i~=n
            Gamma = Gamma.*(U{1,i}'*U{1,i});
        end
    end
    I = eye(K,K);
    if choice == 0
        Un=eta*mttkrp(input_X,U,n)*inv((Gamma+lambda*I))+(1-eta)*U{1,n}; %%SOSClus
    end
    if choice == 1
        Un=eta*(mttkrp(input_X,U,n)+lambda*U_pre{1,n})*inv((Gamma+lambda*I))+(1-eta)*U{1,n};  %%SOSComm
    end
end

