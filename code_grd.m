clear;
clc;

lat = 15.05 : 0.1 : 15.05 + 439*0.1;
lon = 70.05 : 0.1 : 70.05 + 699*0.1;
[mlon,mlat] = meshgrid(lon,lat);  %���񻯾�γ��
mlat = flipud(mlat);   %γ�����·�ת  ��Ҫ��


files = dir('Сʱ��ˮ\*.grd');
% presum = zeros(440,700);   %����ά�ڵ�3��λ��
c = 2;
pre_data = zeros(440*700,2+length(files)); % �ȷ�������

for i = 1 : length(files)
    r = 1;
    c = c + 1;
    disp(['���ڴ����',num2str(i),'��grd...'])
    fid = fopen(['Сʱ��ˮ\',files(i).name],'r');
    data = fread(fid,inf,'float32');  
    data1 = reshape(data,700,440,2);
    pre = data1(:,:,1);  %����ά 1Ϊ��ˮ�� 2Ϊgauge numbers
    pre = flipud(pre');  %��ת�ú����·�ת  ��Ҫ��
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

pl(:,1:2) = pre_data(:,1:2);  %ƥ�侭γ��
yq(:,1:2) = pre_data(:,1:2);  %ƥ�侭γ��
for i = 1 : size(pre_data,1)
    pl(i,3) = length(find(pre_data(i,3:end)>0)); %�޸���ֵ�ط����˴���ֵ����Ϊ0
    yq(i,3) = mean(pre_data(i,3:end),'omitnan'); %�ų�ȱ�����ƽ��
end

dlmwrite('pl.txt',pl)  %д��txt
dlmwrite('yq.txt',yq)  %д��txt

figure(1)
m1 = griddata(pl(:,1),pl(:,2),pl(:,3),mlon,mlat,'nearest');
contourf(mlon,mlat,m1)
title('Ƶ��');
colorbar
figure(2)
m2 = griddata(yq(:,1),yq(:,2),yq(:,3),mlon,mlat,'nearest');
contourf(mlon,mlat,m2)
title('��ǿ');
colorbar
