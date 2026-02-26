clc;clear;
%% 模拟退火求解最优种植方案
clc;clear
T0=1000; % 初始温度
Tf=1e-3; % 终止温度
iter=80;  % 各温度下的迭代次数
a=0.999; % 降温速率
% 计算退火次数
x = double(log(Tf / T0) / log(a));
Time = ceil(x);  % 向上取整
% 选取初始点0,0
point1=zeros(2,1);
% 状态函数值储存向量初始化
obj=zeros(Time,1);
f_start=fun_value(point1); % 求初始函数值
count=0; % 记录迭代次数
% 记录x和y两个变量的迭代过程
track=zeros(2,Time);
while T0>Tf
    count=count+1;
    list_value=zeros(3,iter); % 存储for循环中的迭代记录
    for i=1:iter  % 外加一层for循环使得在每个温度T下，向尽可能最优的方向移动，避免概率的偶然性
        point2=new_point(point1,T0); % 获取更新点
        % Metropolis法则判断是否接受新解
        [pointxy,F]=Metropolis(point1,point2,T0);
        list_value(1,i)=pointxy(1);list_value(2,i)=pointxy(2);list_value(3,i)=F;
    end
    [F,ind]=min(list_value(3,:)); % 找到迭代iter次的最优退火方向
    minx=list_value(1,ind);miny=list_value(2,ind);
    if count==1 || F<obj(count-1)
            % 更新状态
            obj(count)=F; % 若当前状态的函数值比上一次状态的函数值更小，则追加记录
            point1(1)=minx;point1(2)=miny;
            fprintf("第%d次迭代: f为%.5d\n",[count,obj(count)]);
        else
            % 不更新状态
            obj(count)=obj(count-1);
            fprintf("第%d次迭代: f为%.5d\n",[count,obj(count)]);
    end
    track(:,count)=point1; % 记录point的变化
    T0=T0*a; % 退火一次
end
%% 选择较好解
Best = importdata("情况1(1).mat");
% 耕地面积和农作物编号
Data1 = importdata("附件1.xlsx");
Area = Data1.data.Sheet1; % 面积
Crop = Data1.data.Sheet2; % 农作物
for year = 2:size(Best,1)
    plant = Best(year,:);
    Plan = [];
    % 初始化季节矩阵
    Season1 = zeros(size(Area,1),size(Crop,1));
    Season2 = zeros(size(Area,1),size(Crop,1));
    for i = 1:size(Area,1)
        plan = plant{1,i};
        % 单季度
        if size(plan,2) == 1
            land = plan.land;
            season = plan.season;
            crop = plan.crop;
            Season1(i,crop) = Area(i);
            Plan = [Plan;[crop,land,season,Area(i)]];
            % 双季度
        else
            for j = 1:2
               crop = plan(j).crop;
               land = plan(j).land;
               season = plan(j).season;
                if j==1
                    for k = crop
                        Season1(i,k) = Area(i)/length(crop); % 引入比例0.5
                        Plan = [Plan;[k,land,season,Area(i)/length(crop)]];
                    end
                else
                    for k = crop
                        Season2(i,k) = Area(i)/length(crop); % 引入比例0.5
                        Plan = [Plan;[k,land,season,Area(i)/length(crop)]];
                    end
                end
            end
        end
    end
    Answer(year-1).Season1 = Season1;  % 求出季节1的解
    Answer(year-1).Season2 = Season2;  % 求出季节2的解
    Answer(year-1).Plan = Plan; % 保存种植方案
end
figure
plot(1:count,obj','LineWidth',3)
xlabel('迭代次数','FontSize',18)
ylabel('适应度函数值','FontSize',18)
%% 最优种植方案写入excel
sheet=["2024","2025","2026","2027","2028","2029","2030"];
for i=1:7
    first=Answer(i).Season1;
    second=Answer(i).Season2;
    second=second(27:end,:);
    filename1 = 'result1_1.xlsx';
    % 指定要写入的起始单元格位置
    Range1 = ['C2',':','AQ55'];
    Range2 = ['C56',':','AQ83'];
    % 将矩阵写入 Excel 文件的特定位置
    xlswrite(filename1,first, sheet(i), Range1);
    xlswrite(filename1,second, sheet(i), Range2);
end
% 29199874.5元
%% 种植方案可视化
df=readtable('result1_1.xlsx','Sheet','2028','VariableNamingRule','preserve');
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
