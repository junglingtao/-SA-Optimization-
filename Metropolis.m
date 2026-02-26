function [S,F]=Metropolis(S1,S2,T)
% Metropolis准则
% S1:当前解(多元变量)
% S2:新解(多元变量)
% T:当前温度

% S:更新解(多元变量)
% F:更新解的函数值
F1=fun_value(S1);  % 状态S1的函数值
F2=fun_value(S2);  % 状态S2的函数值
delta_f=F2-F1;
if delta_f<0
    S=S2;
    F=F2;
elseif rand()<=exp(-delta_f/T) % 以一定的概率接受
    S=S2;
    F=F2; 
else
    S=S1;
    F=F1;
end
end