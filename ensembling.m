function [model1,model2,model3] = ensembling(data,classes)
s = RandStream('mlfg6331_64'); 
y = datasample(s,1:length(data),3*length(data),'Replace',true);
data1=data(y(1:length(data)),:);
classes1=classes(y(1:length(data)),:);
model1= fitctree(data1,classes1);
data1=data(y(length(data)+1:2*length(data)),:);
classes1=classes(y(length(data)+1:2*length(data)),:);
model2= fitctree(data1,classes1);
data1=data(y(2*length(data)+1:3*length(data)),:);
classes1=classes(y(2*length(data)+1:3*length(data)),:);
model3= fitctree(data1,classes1);
    
    
