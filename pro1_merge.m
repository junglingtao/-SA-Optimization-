clc;clear
data1=readtable("附件1.xlsx","Sheet","Sheet2","VariableNamingRule","preserve");
data1=data1(1:41,2);
% 2023年农作物种植情况
data2=readtable('merge_fujian2.xlsx','VariableNamingRule','preserve');
only=unique(table2array(data2(:,3))); % 2023年产出作物种数
% 求2023年每种作物的销售量
for i=1:41
    name=string(data1{i,1}); % 遍历姓名
    ls(i,1)=sum(table2array(data2(data2{:,4}==name,11)));
end
data1.sum_sale=ls;
% 2023年盈利5931343.25元
all_pf_2023=sum(table2array(data2(:,10)).*table2array(data2(:,11))- ...
    table2array(data2(:,7)).*table2array(data2(:,9)));
%% 求解未来7年的最优种植方案
Rj=readtable("merge_fujian2.xlsx","Sheet","Rj","VariableNamingRule","preserve");
x = optimvar('x',54,41,7,2);
R=table2array(Rj(:,2:3));

43265328.1-6258105-6886453-6429875-5035209.1-6285609-6920358


