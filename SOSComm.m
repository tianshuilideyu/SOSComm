clear;
clc;

% lambda = 1;
lambda = 100;%0.1,0.2,0.3,0.4,0.5,0.6,0.8,1.0,1.5,2.0,4.0,6.0,8.0,10,20,40,60,80,100;
eta = 1;
MaxIter = 10000;
thr = 0.000001;
choice = 1; %0:SOSClus; 1:SOSComm


% load('synthetic data/Syn_dataset/Syn1.mat');
% load('synthetic data/Syn_dataset/Syn2.mat');
% load('synthetic data/Syn_dataset/Syn3.mat');
load('synthetic data/Syn_dataset/Syn4.mat');

TimeStamp = size(network_ground,2);
AC_avg = cell(1,TimeStamp);
NMI_avg = cell(1,TimeStamp);
error = cell(1,TimeStamp);
total_time = cell(1,TimeStamp);
iternum=cell(1,TimeStamp);
factorMatrix = cell(1,TimeStamp);
Cluster=cell(1,TimeStamp);
Res_size = cell(1,TimeStamp);

U_per = cell(1,N);
for n=1:N   
    U_per{1,n} = zeros(synthetic_network{1,1}{1,1}(1,n),K);
end

for t=1:TimeStamp
    input_X = sptensor(synthetic_network{1,t}{1,2},synthetic_network{1,t}{1,3},synthetic_network{1,t}{1,1});
    U = cell(1,N);
    for n=1:N
        numofobject = synthetic_network{1,t}{1,1}(1,n);
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
    
    
    ac = zeros(1,N);    
    NMI = zeros(1,N);
    clus = cell(1,N);
    U_size = zeros(1,N);
    for n=1:N
        if t>1
           [~, ~, ic] = unique( network_ground{1,t}{1,n},'rows');
           id = find(ic==1);
           if sum(network_ground{1,t}{1,n}(id(1),:))==0
               network_ground{1,t}{1,n}(id,:)=[];
               res{1,n}(id,:)=[];
           end
        end
        U_size(1,n) =  size(res{1,n},1);
        [clus{1,n},~]=Accuracy_and_NMI_r( res{1,n},network_ground{1,t}{1,n});
        [K_clus_res,~] = ClusterResultOperator_r(clus{1,n});
        [K_grou_tru,~] = ClusterResultOperator_r(network_ground{1,t}{1,n});
        [ac(1,n),~,~]=AccMeasure(K_grou_tru,K_clus_res);
        NMI(1,n) = Normalized_mutual_information(K_clus_res,K_grou_tru);        
    end
    Res_size{1,t}=U_size;
    aver_ac=sum(ac.*U_size)/sum(U_size);
    aver_nmi=sum(NMI.*U_size)/sum(U_size);
    AC_avg{1,t} = aver_ac;
    NMI_avg{1,t} = aver_nmi;
end
save('Syn_reslut.mat','factorMatrix','Cluster','error','total_time','iternum','AC_avg','NMI_avg','Res_size');
