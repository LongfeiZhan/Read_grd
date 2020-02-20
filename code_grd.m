clear;
clc;

lat = 15.05 : 0.1 : 15.05 + 439*0.1;
lon = 70.05 : 0.1 : 70.05 + 699*0.1;
[mlon,mlat] = meshgrid(lon,lat);  %网格化经纬度
mlat = flipud(mlat);   %纬度上下翻转  重要！


files = dir('小时降水\*.grd');
% presum = zeros(440,700);   %第三维在第3个位置
c = 2;
pre_data = zeros(440*700,2+length(files)); % 先分配数组

for i = 1 : length(files)
    r = 1;
    c = c + 1;
    disp(['正在处理第',num2str(i),'个grd...'])
    fid = fopen(['小时降水\',files(i).name],'r');
    data = fread(fid,inf,'float32');  
    data1 = reshape(data,700,440,2);
    pre = data1(:,:,1);  %第三维 1为降水量 2为gauge numbers
    pre = flipud(pre');  %先转置后上下翻转  重要！
    pre(pre(:,:) == -999) = NaN;
    for j = 1 : 440
        for k = 1 : 700
            pre_data(r,1) = single(mlon(j,k));
            pre_data(r,2) = single(mlat(j,k));
            pre_data(r,c) = single(pre(j,k));
            r = r + 1;
        end
    end
    fclose(fid);
end

pl(:,1:2) = pre_data(:,1:2);  %匹配经纬度
yq(:,1:2) = pre_data(:,1:2);  %匹配经纬度
for i = 1 : size(pre_data,1)
    pl(i,3) = length(find(pre_data(i,3:end)>0)); %修改阈值地方，此处阈值设置为0
    yq(i,3) = mean(pre_data(i,3:end),'omitnan'); %排除缺测后求平均
end

dlmwrite('pl.txt',pl)  %写入txt
dlmwrite('yq.txt',yq)  %写入txt

figure(1)
m1 = griddata(pl(:,1),pl(:,2),pl(:,3),mlon,mlat,'nearest');
contourf(mlon,mlat,m1)
title('频率');
colorbar
figure(2)
m2 = griddata(yq(:,1),yq(:,2),yq(:,3),mlon,mlat,'nearest');
contourf(mlon,mlat,m2)
title('雨强');
colorbar
