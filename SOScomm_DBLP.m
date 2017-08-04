clear;
clc;
fprintf('this is SOSClus offline!');
lambda = 1;
eta = 1;
MaxIter = 1000;
thr = 0.000001;
choice = 0; %0:SOSClus; 1:SOSComm

load('realworld data/TensorS.mat');
TimeStamp = 25;
N = 3;
K = 20;
modularityQ = cell(1,TimeStamp);
error = cell(1,TimeStamp);
total_time = cell(1,TimeStamp);
iternum=cell(1,TimeStamp);
factorMatrix = cell(1,TimeStamp);
Cluster=cell(1,TimeStamp);

U_per = cell(1,N);
for n=1:N   
    U_per{1,n} = zeros(size(TensorS{1,1},n),K);
end

for t=1:TimeStamp
    input_X = TensorS{1,t};
    U = cell(1,N);
    for n=1:N
        numofobject = size(input_X,n);
        U{1,n}=rand(numofobject,K); 
        numofobject_per = size(U_per{1,n},1);
        if numofobject > numofobject_per
            U_per{1,n}(numofobject_per+1:numofobject,:)=0;
        end
    end    
    iter = 1;
    diff = zeros(1,MaxIter);
    f_curr=0;
    f_pre=1;
    tic
    while 1
        eta = 1/(1+iter);
        for n=1:N
            U{1,n}=UpdateU(U,n,input_X,N,K,eta,lambda,U_per,choice);
        end
        f_curr=fun_L( input_X,U,N,lambda,U_per,choice);
        diff(1,iter) = abs((f_curr-f_pre)/f_pre);
        f_pre=f_curr;
        formatSpec = 'This is %2.0f times iteration. The error is %8.7f.\n';
        fprintf(formatSpec,iter,diff(1,iter));
        if iter>=MaxIter ||diff(1,iter)<thr
            break;
        end
        iter = iter + 1;
    end
    spend_time = toc;
    formatSpec = 'This is %2.0f timestamp \n';
    fprintf(formatSpec,t);
    U=Row_Normalize(U);
    U_per = U;    
    error{1,t}=diff;
    total_time{1,t} = spend_time;
    iternum{1,t} = iter;
    factorMatrix{1,t} = U;
    
    res = U;    
    for n=1:N
        idx = kmeans(res{1,n},K);
        res{1,n}(:,:)=0;
        for i = 1:size(idx,1)
            res{1,n}(i,idx(i))=1;
        end
    end    
    Cluster{1,t}=res;
    modularityQ{1,t}=modularity(input_X,N,K,res);
    
end
save('DBLP_SOSClus_off_reslut.mat','factorMatrix','Cluster','error','total_time','iternum','modularityQ');
