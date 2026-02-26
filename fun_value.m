function value=fun_value(point)
% value为函数状态值
% point为多元变量
value=((point(1)+2*point(2)-0.77)^10+(2*point(1)+point(2)-5)^1.5+(2*point(1)+point(2)-5)^0.2 ...
    +(2*point(1)+point(2)+5)^0.5-(3*point(1)^2+2*point(2)^4+1)^0.1)*0.00000001;
end