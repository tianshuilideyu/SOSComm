function [ T,K,N,M,input_X,U ] = initial_para( T,K,Tensor_size,Tensor_subs,Tensor_vals )
%INITAL Summary of this function goes here
%   Detailed explanation goes here
% initial parameters
N=Tensor_size;
M = Tensor_subs;% sparse represent of the tensor
input_X = sptensor(M, Tensor_vals,N);
% input_X = tensor(input_X);
clear Tensor_size;
clear Tensor_subs;
clear Tensor_vals;
U={};
for i=1:T
    ui = zeros(N(i),K);
    U{1,i}= ui;
    clear ui;
end


end

