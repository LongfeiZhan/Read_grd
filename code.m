clear;
clc;

lat = 15.05 : 0.1 : 15.05 + 439*0.1;
lon = 70.05 : 0.1 : 70.05 + 699*0.1;
[mlon,mlat] = meshgrid(lon,lat);  %���񻯾�γ��
% mlat = flipud(mlat);
mlon = fliplr(mlon); 

files = dir('Сʱ��ˮ\*.grd');
% presum = zeros(1,440,700);  % ����ά�ڵ�1��λ��
presum = zeros(440,700);   %����ά�ڵ�3��λ��
c = 2;
pre_data = zeros(440*700,2+length(files)); % �ȷ�������

for i = 1 : length(files)
    r = 1;
    c = c + 1;
    disp(['���ڴ����',num2str(i),'��grd...'])
    fid = fopen(['Сʱ��ˮ\',files(i).name],'r');
    data = fread(fid,inf,'float32');
    data1 = reshape(data,440,700,2);
    %     pre = data1(1,:,:); %1Ϊ��ˮ�� 2Ϊgauge numbers
    pre = data1(:,:);
    %     pre(pre(1,:,:) == -999) = NaN;
    pre(pre(:,:) == -999) = NaN;
    %     presum = pre + presum;
    for j = 1 : 440
        for k = 1 : 700
            pre_data(r,1) = single(mlon(j,k));
            pre_data(r,2) = single(mlat(j,k));
    %  pre_data(r,c) = single(pre(1,j,k));
            pre_data(r,c) = single(pre(j,k));
            r = r + 1;
        end
    end
    fclose(fid);
end

pl(:,1:2) = pre_data(:,1:2);
yq(:,1:2) = pre_data(:,1:2);
for i = 1 : size(pre_data,1)
    pl(i,3) = length(find(pre_data(i,3:end)>0)); %�޸���ֵ�ط����˴���ֵ����Ϊ0
    yq(i,3) = mean(pre_data(i,3:end),'omitnan'); %�ų�ȱ�����ƽ��
end

dlmwrite('pl.txt',pl)
dlmwrite('yq.txt',yq)

figure(1)
m1 = griddata(pl(:,1),pl(:,2),pl(:,3),mlon,mlat,'nearest');
contourf(mlon,mlat,m1)
colorbar
figure(2)
m2 = griddata(yq(:,1),yq(:,2),yq(:,3),mlon,mlat,'nearest');
contourf(mlon,mlat,m2)
colorbar

% r = 1;
% for i = 1 : 440
%     i
%     for j = 1 : 700
%         pre1(i,j) = presum(1,i,j);
%         if isnan(pre1(i,j))
%             continue
%         else
%             p(r,1) = mlon(i,j);
%             p(r,2) = mlat(i,j);
%             p(r,3) = pre1(i,j);
%             r = r + 1;
%         end
%     end
% end
%
% m = griddata(pre_data(:,1),pre_data(:,2),pre_data(:,3),mlon,mlat,'nearest');




