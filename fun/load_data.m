function [data]=load_data(filename)

% Load first numeric data
facialfeatures=load1(filename);

% Load age and create dimension for 'None'
age=load2(filename);
ind=isnan(age);
age(ind)=0;
data=[facialfeatures(:,2:end) double(ind) age];
clear ind

% Load gender and transform male=1 female=0
gender=load3(filename);
ind=zeros(length(gender),1);
ind(strcmp(gender,'male'))=1;
data=[data double(ind)];
clear ind

% Load confidences and put NaN to zero (dimension allready created for
% 'None')
tmp=load4(filename);
tmp(isnan(tmp))=0;
data=[data tmp];
clear tmp

% Load eyes states and transform closed=0 opened=1
[left_eye,right_eye]=load5(filename);
ind=zeros(length(right_eye),1);
ind(strcmp(right_eye,'opened'))=1;
data=[data double(ind)];
clear ind
ind=zeros(length(left_eye),1);
ind(strcmp(left_eye,'opened'))=1;
data=[data double(ind)];
clear ind

% Load lasts numerica data
tmp=load6(filename);
data=[data tmp];
clear tmp