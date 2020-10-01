function [labels_fin]=gboosting_predict(model2,model3,model4,features)

labels_pre=0.5+predict(model2,features)+predict(model3,features)+predict(model4,features);

labels_fin(labels_pre>0.5)=1;
labels_fin(labels_pre<=0.5)=0;
