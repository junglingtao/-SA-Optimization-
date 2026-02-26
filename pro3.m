clc;clear
% 2023年农作物种植情况
data2=readtable('merge_fujian2.xlsx','VariableNamingRule','preserve');
data2=table2array(data2(:,9:11));
[R, P] = corr(data2, 'Type', 'Spearman');
imagesc(R);
colorbar;
axis square;
%% 2023年农作物种植情况
df=readtable('result1_1.xlsx','Sheet','2027','VariableNamingRule','preserve');
Area_matrix=table2array(df(1:82,3:43));
bin_matrix=zeros(82,41);
for i=1:82
    for j=1:41
        temp=Area_matrix(i,j);
        if temp>0
            bin_matrix(i,j)=1;
        else
            bin_matrix(i,j)=0;
        end
    end
end
figure(1)
% 使用imagesc函数可视化矩阵
heatmap(bin_matrix);
% 设置颜色图为黑白两种颜色
colormap([1 1 1; 0 0 0]);
% 显示颜色条
colorbar;
% 隐藏x轴和y轴的标签
ax = gca;  % 获取当前轴对象
ax.XDisplayLabels = nan(size(ax.XDisplayData));
ax.YDisplayLabels = nan(size(ax.YDisplayData));
xlabel('农作物编号')
ylabel('种植耕地编号')
%% 拟合关系
data=readtable('merge_fujian2.xlsx','VariableNamingRule','preserve');
data=table2array(data(:,9:11));
x1=data(:,1);x2=data(:,2);x3=data(:,3);
X1=[ones(size(x3)),x3,x2,x2.^2];
stepwise(X1(:,2:end),x1);

X2=[ones(size(x3)),x3,x3.^2,x3.^3,x1,x1.^2,x1.^3];
stepwise(X2(:,2:end),x2);

