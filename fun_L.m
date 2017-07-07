function [ err ] = fun_L( input_X,U,N,lambda,U_pre,choice)
%FUN_L Summary of this function goes here
%   Detailed explanation goes here
% f=norm(input_X-(ktensor(U)))^2;
f=norm(input_X)^2+norm((ktensor(U)))^2-2*innerprod(input_X,ktensor(U));
g=0;
if choice == 0 %%SOSClus obj function
    for n=1:N
        g = g+norm(U{1,n})^2;
    end
else
    for n=1:N
        g = g+norm(U{1,n}-U_pre{1,n})^2;
    end
end
err = 0.5*f-0.5*lambda*g;
end

