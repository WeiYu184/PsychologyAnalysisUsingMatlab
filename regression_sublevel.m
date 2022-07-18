data=xlsread('sample.xlsx');

participants = unique(data(:,1));
idata = [];
for i = 1:length(participants)
    n = 1;
    for j = 1:length(data)
        if data(j,1) == i
             idata{i,n} = data(j,:);
             n=n+1;
        end
    end
end


b=cellfun('isempty',idata);


indicatorA=[];
indicatorB=[];
indicatorC=[];

for i=1:length(participants)
    count = 0;
    n=length(find(b(i,:)==1));
    count=length(idata)-n; % count numbers of rows for each participant
    X1=zeros(1,count);
    X2=zeros(1,count);
    X3=zeros(1,count);
    Y=zeros(1,count);
   
     
    for j = 1:count
       X1(j)=idata{i,j}(2);
       X2(j)=idata{i,j}(3);
       X3(j)=idata{i,j}(4);
       Y(j)=idata{i,j}(5); % for more complicated model, add more Xn, and customize the regression function
    end
    
    Y=Y';
    X1=X1';
    X2=X2';
    X3=X3';
    X=[ones(length(Y),1),X1,X2,X3];
    [z,bint,rint,stats]=regress(Y,X);
    indicatorA(i)=z(2);
    indicatorB(i)=z(3);
    indicatorC(i)=z(4);
end

indicatorA=indicatorA';
indicatorB=indicatorB';
indicatorC=indicatorC';

output=[indicatorA,indicatorB, indicatorC];

xlswrite('result.xlsx',output);
