function [model2,model3,model4]=gboosting(features, labels)

labels1=labels-0.5;
model2=fitctree(features,labels1,'MaxNumSplits',9);
labels2=labels-0.5-predict(model2,features);
model3=fitctree(features,labels2,'MaxNumSplits',9);
labels3=labels-0.5-predict(model2,features)-predict(model3,features);
model4=fitctree(features,labels3,'MaxNumSplits',9);    

