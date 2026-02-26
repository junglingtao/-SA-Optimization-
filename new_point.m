function newpoint=new_point(point1,T)
% 生成新的点
% ceil向正无穷取整，unifrnd在指定区间生成一个均匀随机数
while (true)
    newpoint(1,1)=point1(1)+T*(rand()-rand());
    newpoint(2,1)=point1(2)+T*(rand()-rand());
    if (-100<=newpoint(1,1)<=100)&&(-100<=newpoint(2,1)<=100)
        break;
    end
end
end