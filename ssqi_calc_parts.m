function [ssqi1 ssqi2 ssqi3]=ssqi_calc_parts(signal,sampling_rate)
%%%%function to calculate kurtosis sqi
%%%signal - single channel ecgsignal
%%%%sampling_rate - sampling frequency of the ecg signal
Fs=sampling_rate;
if ~isrow(signal)
   signal=signal';
end
Ecgsignal=signal;
num=round(length(Ecgsignal)/3);
% sig=[fliplr(signal(1:round(Fs/2))) signal fliplr(signal((length(signal)-round(Fs/2)):length(signal)))];
% ksqi=zeros(length(sig),1);
% for i=round(1.5*Fs):round(1.5*Fs):length(sig)-round(1.5*Fs)
%     curve=sig(i-round(1.5*Fs)+1:i+round(1.5*Fs));
%     for t=i-round(1.5*Fs)+1:i+round(1.5*Fs)
%         ksqi(t)=kurtosis(curve);
%     end
% end
% %ksqi=ksqi./max(ksqi);
% ksqi=ksqi(round((length(ksqi)-length(signal))/2+1):round((length(ksqi)+length(signal))/2));
% ksqi=zeros(1,length(Ecgsignal));
% window_size=Fs;
% Ecgsignal2=[fliplr(Ecgsignal(1:round(window_size/2))) Ecgsignal fliplr(Ecgsignal((length(Ecgsignal)-round(window_size/2)):length(Ecgsignal)))];
% k=1;
% while k<=length(Ecgsignal2)
%     window=[Ecgsignal2(max(1,k-round(window_size/2)+1):k-1) Ecgsignal2(k) Ecgsignal2(k+1:min(k+round(window_size/2)-1,length(Ecgsignal2)))];
%     if k-round(window_size/2)<1
%         window=[zeros(1,round(window_size/2)-k) window];
%     end
%     if k+round(window_size/2)>=length(Ecgsignal2)
%         window=[window zeros(1,(window_size-length(window)))];
%     end
%     ksqi(k)=skewness(window);
%     k=k+1;
% end
ssqi1=skewness(Ecgsignal(1:num));
ssqi2=skewness(Ecgsignal(num+1:num+num));
ssqi3=skewness(Ecgsignal(num+num+1:end));