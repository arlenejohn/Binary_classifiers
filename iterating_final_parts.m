%warning('off', MSGID)
clear all
addpath('D:\PhD topics\Desktop\Binary_classification1\Binary_classification1\data')
C1_training=zeros(2,2);
C2_training=zeros(2,2);
C3_training=zeros(2,2);
C4_training=zeros(2,2);
C5_training=zeros(2,2);
C6_training=zeros(2,2);
C7_training=zeros(2,2);
C8_training=zeros(2,2);

C1_testing=zeros(2,2);
C2_testing=zeros(2,2);
C3_testing=zeros(2,2);
C4_testing=zeros(2,2);
C5_testing=zeros(2,2);
C6_testing=zeros(2,2);
C7_testing=zeros(2,2);
C8_testing=zeros(2,2);
C9_testing=zeros(2,2);
C10_testing=zeros(2,2);
C11_testing=zeros(2,2);


ppv_all=zeros(11,10);
accuracy_all=zeros(11,10);

load('training_list6');
indices = crossvalind('Kfold',table_list{1,2},10);
for l=1:10
    test = (indices == l); 
    training = ~test;
    dataTrain=table_list{1,1}(training);
    class_Train=table_list{1,2}(training);

    train_labels=dataTrain;
    train_classes=class_Train;
    features=zeros(length(train_labels),6);
    for i=1:length(train_labels)
        signalname=char(train_labels(i));
        [tm,ecg,fs,siginfo]=rdmat(signalname);
        ecg=(ecg-mean(ecg));
        ecg=ecg(fs:end);
        ecg=resample(ecg,1,4);
        load(strcat(signalname,'qrs'));
        %%%generate features or load features from the features file for
        %%%the corresponding signal
        [ksqi1 ksqi2 ksqi3]=ksqi_calc_parts(ecg,fs);
        [ssqi1 ssqi2 ssqi3]=ssqi_calc_parts(ecg,fs);
        features(i,:)=[ ksqi1 ksqi2 ksqi3 ssqi1 ssqi2 ssqi3];
    end

    mean_all=mean(features);
    std_all=std(features);
    features=(features-mean_all)./std_all;
    mdl1 = fitcknn(features,train_classes,'NSMethod','exhaustive','NumNeighbors',1,'DistanceWeight','squaredinverse');
    ped_class1=predict(mdl1,features);
    [C,~]=confusionmat(train_classes,ped_class1)
    C1_training=C1_training+C;
    
    mdl2= fitctree(features,train_classes);
    ped_class2=predict(mdl2,features);
    [C,~]=confusionmat(train_classes,ped_class2)
    C2_training=C2_training+C;
    
    mdl3= fitcsvm(features,train_classes,'KernelFunction','rbf');
    ped_class3=predict(mdl3,features);
    [C,~]=confusionmat(train_classes,ped_class3)
    C3_training=C3_training+C;
    
    mdl4= fitcnb(features,train_classes);
    ped_class4=predict(mdl4,features);
    [C,~]=confusionmat(train_classes,ped_class4)
    C4_training=C4_training+C;
    
    mdl5= fitcdiscr(features,train_classes);
    ped_class5=predict(mdl5,features);
    [C,~]=confusionmat(train_classes,ped_class5)
    C5_training=C5_training+C;
    
    net = feedforwardnet(4);
    [net,tr] = train(net,features',train_classes');
    ped_class6=net(features');
    ped_class6(ped_class6>0.5)=1;
    ped_class6(ped_class6<=0.5)=0;
    [C,~]=confusionmat(train_classes,ped_class6')
    C6_training=C6_training+C;
    
    % ensembling with trees
    [model1,model2,model3] = ensembling(features,train_classes);
    ped_class7=ensembling_dec(model1,model2,model3,features);
    [C,~]=confusionmat(train_classes,ped_class7);
    C7_training=C7_training+C;
    
    % gradient boosting with trees
    [modelg2,modelg3,modelg4]=gboosting(features, train_classes);
    ped_class8=ensembling_dec(modelg2,modelg3,modelg4,features);
    [C,~]=confusionmat(train_classes,ped_class8)
    C8_training=C8_training+C;
    
    



%%%%%%testing


    dataTest=table_list{1,1}(test);
    class_Test=table_list{1,2}(test);

    testlabels=dataTest;
    test_classes=class_Test;

    features=zeros(length(testlabels),6);
    for i=1:length(testlabels)
        signalname=char(testlabels(i));
        [tm,ecg,fs,siginfo]=rdmat(signalname);
        ecg=(ecg-mean(ecg));
        ecg=ecg(fs:end);
        ecg=resample(ecg,1,4);
        load(strcat(signalname,'qrs'));
        [ksqi1 ksqi2 ksqi3]=ksqi_calc_parts(ecg,fs);
        [ssqi1 ssqi2 ssqi3]=ssqi_calc_parts(ecg,fs);

        features(i,:)=[ksqi1 ksqi2 ksqi3 ssqi1 ssqi2 ssqi3];
    end
    
    features=(features-mean_all)./std_all;
    ped_class1=predict(mdl1,features);
    
    [C1,~]=confusionmat(test_classes,ped_class1)
    
    accuracy_all(1,l)=(C1(1,1)+C1(2,2))/(C1(1,1)+C1(2,2)+C1(2,1)+C1(1,2));
    ppv_all(1,l)=C1(1,1)/(C1(1,1)+C1(2,1));
    C1_testing=C1_testing+C1;
    
    ped_class2=predict(mdl2,features);
    [C2,~]=confusionmat(test_classes,ped_class2)
    accuracy_all(2,l)=(C2(1,1)+C2(2,2))/(C2(1,1)+C2(2,2)+C2(2,1)+C2(1,2));
    ppv_all(2,l)=C2(1,1)/(C2(1,1)+C2(2,1));
    C2_testing=C2_testing+C2;
    
    ped_class3=predict(mdl3,features);
    [C3,~]=confusionmat(test_classes,ped_class3)
    accuracy_all(3,l)=(C3(1,1)+C3(2,2))/(C3(1,1)+C3(2,2)+C3(2,1)+C3(1,2));
    ppv_all(3,l)=C3(1,1)/(C3(1,1)+C3(2,1));
    C3_testing=C3_testing+C3;
    
    ped_class4=predict(mdl4,features);
    [C4,~]=confusionmat(test_classes,ped_class4)
    accuracy_all(4,l)=(C4(1,1)+C4(2,2))/(C4(1,1)+C4(2,2)+C4(2,1)+C4(1,2));
    ppv_all(4,l)=C4(1,1)/(C4(1,1)+C4(2,1));
    C4_testing=C4_testing+C4;
    
    ped_class5=predict(mdl5,features);
    [C5,~]=confusionmat(test_classes,ped_class5)
    accuracy_all(5,l)=(C5(1,1)+C5(2,2))/(C5(1,1)+C5(2,2)+C5(2,1)+C5(1,2));
    ppv_all(5,l)=C5(1,1)/(C5(1,1)+C5(2,1));
    C5_testing=C5_testing+C5;
    
    ped_class6=net(features');
    ped_class6(ped_class6>0.5)=1;
    ped_class6(ped_class6<=0.5)=0;
    ped_class6=ped_class6';
    [C6,~]=confusionmat(test_classes,ped_class6)
    accuracy_all(6,l)=(C6(1,1)+C6(2,2))/(C6(1,1)+C6(2,2)+C6(2,1)+C6(1,2));
    ppv_all(6,l)=C6(1,1)/(C6(1,1)+C6(2,1));
    C6_testing=C6_testing+C6;
    
    ped_class7=ensembling_dec(model1,model2,model3,features);
    [C7,~]=confusionmat(test_classes,ped_class7)
    accuracy_all(7,l)=(C7(1,1)+C7(2,2))/(C7(1,1)+C7(2,2)+C7(2,1)+C7(1,2));
    ppv_all(7,l)=C7(1,1)/(C7(1,1)+C7(2,1));
    C7_testing=C7_testing+C7;
   
    
    ped_class8=gboosting_predict(modelg2, modelg3, modelg4, features);
    [C8,~]=confusionmat(test_classes,ped_class8)
    accuracy_all(8,l)=(C8(1,1)+C8(2,2))/(C8(1,1)+C8(2,2)+C8(2,1)+C8(1,2));
    ppv_all(8,l)=C8(1,1)/(C8(1,1)+C8(2,1));
    C8_testing=C8_testing+C8;
    
    %%% Fusion of NB, LDA, DT
    ped_class9=zeros(length(ped_class5),1);
    for i=1:length(ped_class5)
        if ped_class2(i)==1
            if ped_class4(i)==0
                if ped_class5(i)==1
                    ped_class9(i)=0;
                else
                    ped_class9(i)=1;
                end
            else
                ped_class9(i)=1;
            end
        end
    end
    [C9,~]=confusionmat(test_classes,ped_class9)
    accuracy_all(9,l)=(C9(1,1)+C9(2,2))/(C9(1,1)+C9(2,2)+C9(2,1)+C9(1,2));
    ppv_all(9,l)=C9(1,1)/(C9(1,1)+C9(2,1));
    C9_testing=C9_testing+C9;
    
    %%% Fusion of NB, LDA
    ped_class10=zeros(length(ped_class5),1);
    for i=1:length(ped_class5)
        if ped_class4(i)==0
            ped_class10(i)=0;
        else
            if ped_class5(i)==1
                 ped_class10(i)=1;
            else
                ped_class10(i)=0;
            end
        end
    end
    [C10,~]=confusionmat(test_classes,ped_class10)
    accuracy_all(10,l)=(C10(1,1)+C10(2,2))/(C10(1,1)+C10(2,2)+C10(2,1)+C10(1,2));
    ppv_all(10,l)=C10(1,1)/(C10(1,1)+C10(2,1));
    C10_testing=C10_testing+C10;
    

    tot_pred=[ped_class1 ped_class2 ped_class3 ped_class4 ped_class5 ped_class7];
    ped_class11=sum(tot_pred,2)/6;
    ped_class11(ped_class11>0.5)=1;
    ped_class11(ped_class11<0.5)=0;
    ped_class11(ped_class11==0.5)=(ped_class1(ped_class6==0.5)+ped_class3(ped_class6==0.5)+ped_class7(ped_class6==0.5))/3;
    ped_class11(ped_class11>0.5)=1;
    ped_class11(ped_class11<0.5)=0;
    [C11,~]=confusionmat(test_classes,ped_class11);
    accuracy_all(11,l)=(C11(1,1)+C11(2,2))/(C11(1,1)+C11(2,2)+C11(2,1)+C11(1,2));
    ppv_all(11,l)=C11(1,1)/(C11(1,1)+C11(2,1));
    C11_testing=C11_testing+C11;

    
end


