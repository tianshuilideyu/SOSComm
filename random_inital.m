% random method for initial guess of factor matrices and core tensor

% clear;
% clc;
% Experiment real world data
% load('.\realworld data\DBLP_tensor.mat');
% [T,K,N,M,input_X,U]=initial_para( 3,4,DBLP_size,DBLP_subs,DBLP_vals );
% realworldornot = 1;

% Experiment A
% load('.\synthetic data\Syn_dataset\syn1.mat');
% load('.\synthetic data\Syn_dataset\syn2.mat');
% load('.\synthetic data\Syn_dataset\syn3.mat');
% load('.\synthetic data\Syn_dataset\syn4.mat');
%  realworldornot = 0;
%  [T,K,I,M,input_X,U]=initial_para( T,K,Tensor_size,Tensor_subs,Tensor_vals );

%TEST

load('.\synthetic data\Syn_dataset\synthetic_data_test.mat');
 realworldornot = 0;
 [N,K,I,M,input_X,U]=initial_para( N,K,Tensor_size,Tensor_subs,Tensor_vals );


tic
for n= 1:N
    U{1,n} = rand(I(n),K);
%     for i = 1:N(t)
%         sumofrow = sum(U{1,t}(i,:));
%         if sumofrow == 0
%             U{1,t}(i,:) = rand(1,K);
%             sumofrow = sum(U{1,t}(i,:));
%         end
% %          U{1,t}(i,:) = U{1,t}(i,:)/sumofrow;        
%     end
end

fprintf('Factor matrices initialization is done \n\n');
% save('initial_U.mat','U','input_X','M','N');

spend_time = toc;
if realworldornot == 1    
    load('.\realworld data\DBLP_ground_truth.mat');
    U_groundtruth={author_ground(:,3:6),conf_ground(:,3:6)};
end

save('initial_U.mat','U','input_X','M','N','K','T','spend_time','U_groundtruth','realworldornot');

