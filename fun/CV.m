function [TRAIN,TEST]=CV(DATA,k,n)
% Perfoms k-fold partitionning
% k: number of folds
% n: number of iteration in the loop (1=<n=<k)
% DATA: data to be k-folded

SIZE=round(size(DATA,1)/k);
ind(1)=1;
for i=2:k+1
    ind(i)=ind(i-1)+SIZE;
end
if mod(SIZE,k)~=0
    printf('Warning: the number of folds is not compatible with the number of samples')
end
TEST=DATA(ind(n):ind(n+1)-1,:);
if n==1
    TRAIN=DATA(ind(n+1):ind(end)-1,:);
else
    TRAIN=DATA(ind(1):ind(n)-1,:);
    TRAIN=[TRAIN; DATA(ind(n+1):ind(end)-1,:)];
end
    


end