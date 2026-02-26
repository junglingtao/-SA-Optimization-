clc;clear
%% 数据导入
data1_1=readtable("附件1.xlsx","Sheet","Sheet1","VariableNamingRule","preserve");
data1_1=data1_1(:,1:3);
data1_2=readtable("附件1.xlsx","Sheet","Sheet2","VariableNamingRule","preserve");
data1_2=data1_2(1:41,1:3);

data2_1=readtable("附件2.xlsx","Sheet","Sheet1","VariableNamingRule","preserve");
data2_2=readtable("附件2.xlsx","Sheet","Sheet2","VariableNamingRule","preserve");
data2_2=data2_2(1:107,2:8);
% 对销售单价求均值
sales_price=data2_2(:,"销售单价/(元/斤)");
mean_price=zeros(107,1);
for i=1:107
    a=table2cell(sales_price(i,1));
    ls=split(string(a{1}),"-");
    mean_price(i)=(double(ls(1))+double(ls(2)))/2;
end
data2_2=data2_2(:,1:6);data2_2.mean_price=mean_price;
clear sales_price;clear ls;clear a;clear mean_price;clear i
%% 数据初步可视化
% 6个平旱地、14个梯田、6个山坡地、8个水浇地
% 16个普通大棚、4个智慧大棚
subplot(1,2,1)
bar([6,14,6,8,16,4])
set(gca, 'xticklabels', {'平旱地', '梯田', '山坡地', '水浇地', ...
    '普通大棚', '智慧大棚'},'Fontsize', 12);
text(1, 6+0.4, num2str(6), 'HorizontalAlignment', 'center','FontSize',15);
text(2, 14+0.4, num2str(14), 'HorizontalAlignment', 'center','FontSize',15);
text(3, 6+0.4, num2str(6), 'HorizontalAlignment', 'center','FontSize',15);
text(4, 8+0.4, num2str(8), 'HorizontalAlignment', 'center','FontSize',15);
text(5, 16+0.4, num2str(16), 'HorizontalAlignment', 'center','FontSize',15);
text(6, 4+0.3, num2str(4), 'HorizontalAlignment', 'center','FontSize',15);
ylabel('耕地数目','FontSize',18)
title('耕地类型')

subplot(1,2,2)
% 6个粮食(豆类)、11个粮食、3个蔬菜(豆类)、18个蔬菜、4个食用菌
bar([6,11,3,18,4])
set(gca, 'xticklabels', {'粮食(豆类)', '粮食', '蔬菜(豆类)', '蔬菜', ...
    '食用菌'},'Fontsize', 12);
text(1, 6+0.3, num2str(6), 'HorizontalAlignment', 'center','FontSize',15);
text(2, 11+0.3, num2str(11), 'HorizontalAlignment', 'center','FontSize',15);
text(3, 3+0.3, num2str(3), 'HorizontalAlignment', 'center','FontSize',15);
text(4, 18+0.3, num2str(18), 'HorizontalAlignment', 'center','FontSize',15);
text(5, 4+0.3, num2str(4), 'HorizontalAlignment', 'center','FontSize',15);
ylabel('粮食作物数目','FontSize',18)
title('农作物种类')
%% 统计每亩盈利较大的作物和耕地组合
P=table2array(data2_2(:,"亩产量/斤")); % 每亩的产量
C=table2array(data2_2(:,"种植成本/(元/亩)")); % 每亩的成本
S=table2array(data2_2(:,"mean_price")); % 每斤的售价
profit=P.*S-C; % 每亩盈利
% 取出盈利排名前5的与排名后5的
[prof,idx]=sort(profit);
max_pf=prof(end-4:end);
max_idx=idx(end-4:end);
min_pf=prof(1:5);
min_idx=idx(1:5);
max_data=data2_2(max_idx,2:3);
min_data=data2_2(min_idx,2:3);
max_data.pf=max_pf;
min_data.pf=min_pf;
for i=1:5
    zhmax(i,1)=string(max_data{i,1})+"+"+string(max_data{i,2});
    zhmin(i,1)=string(min_data{i,1})+"+"+string(min_data{i,2});
end
subplot(1,2,1)
barh([90000,101500,109550,150000,284500],'b')
set(gca, 'yticklabels', {zhmax(1), zhmax(2), zhmax(3), zhmax(4), ...
    zhmax(5)},'Fontsize', 16);
title('每亩地盈利排名前5的组合','FontSize',18)
subplot(1,2,2)
barh([770,835,900,1312.5,1400],'y')
set(gca, 'yticklabels', {zhmin(1), zhmin(2), zhmin(3), zhmin(4), ...
    zhmin(5)},'Fontsize', 16);
title('每亩地盈利排名后5的组合','FontSize',18)
%% 附件2信息合并
data2=join(data2_1,data1_1,"Keys","种植地块");
data2=data2(:,1:end-1);
data2=join(data2,data2_2,"Keys",["作物编号","作物名称","地块类型"]);
writetable(data2, 'merge_fujian2.xlsx', 'Sheet', 'Sheet1');

