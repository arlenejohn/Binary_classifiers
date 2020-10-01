function pred = ensembling_dec(model1,model2,model3,features)
ped1=predict(model1,features);
ped2=predict(model2,features);
ped3=predict(model3,features);

ped=[ped1 ped2 ped3];
pred=median(ped,2);