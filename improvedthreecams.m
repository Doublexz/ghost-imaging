%%����CCD����ʵ��
clc
clearvars;
%%��ȡ�ο�������
FilePath='F:\ʵ������\9.12\3';
v=VideoReader([FilePath '\cam0.avi']);%a1�ο���
%N=v.NumberofFrames; 
a1=read(v,[1 1500]);
a1=double(a1);
[x,y,z,t]=size(a1);
clear v;
vv=VideoReader([FilePath '\cam2.avi']);%a2ƽ�й⣨��ƫ���֣�
a2=read(vv,[1 1500]);
a2=double(a2);
[x2,y2,z2,t2]=size(a2);
clear vv ;
B1=zeros(1,1500);
B2=zeros(1,1500);
B3=zeros(1,1500);
B_obj=zeros(1,1500);
B_bg=zeros(1,1500);
D_obj=0.839;%ƫ���
D_bg=0.945;
for i=2:t
    B1(i)=sum(sum(a2(:,:,1,i)));%%ƽ�й�Ͱ̽��
end
   clear a2 ;
vvv=VideoReader([FilePath '\cam1.avi']);%a3��ֱ�⣨��ƫ���֣�
a3=read(vvv,[1 1500]);
a3=double(a3);
[x3,y3,z3,t3]=size(a3);
clear vvv;
for i=2:t
    B2(i)=sum(sum(a3(:,:,1,i)));%%��ֱ��Ͱ̽��
    B3(i)=B1(i)+B2(i);
    B_obj(i)=(B2(i)*(1+D_bg)-B1(i)*(1-D_bg))/(D_bg-D_obj);%%�����㷨ƽ�й�ǿ
    B_bg(i)=(B1(i)*(1-D_obj)-B2(i)*(1+D_obj))/(D_bg-D_obj);%%�����㷨��ֱ��
end
clear a3;

midx=x/2;%�ӳ�����
midy=y/2;%�ӳ�����



% for i=2:t
%     B1(i)=sum(sum(a2(:,:,1,i)));%%ƽ�й�Ͱ̽��
%     B2(i)=sum(sum(a3(:,:,1,i)));%%��ֱ��Ͱ̽��
%     B3(i)=B1(i)+B2(i);
% end
I0=0;
I0_1=0;%%��ֱ���<IS>*t
I0_obj=0;
I0_bg=0;
I0_total=0;%%��ƫ��ƫ�ܹ�ǿ
I1=0;%%�ο��۵���
I2=0;%%ƽ�й����
I2_1=0;%%��ֱ�����
I2_obj=0;
I2_bg=0;
I2_total=0;%%�ܹ�ǿ����
I3=0;
I4=0;
I_corrmid=0;
I_mid=0;
for i=2:t
    I0=I0+a1(:,:,1,i)*B1(i);%%<IS>*t
    I0_1=I0_1+a1(:,:,1,i)*B2(i);%%<IS>*t
    I0_obj=I0_obj+a1(:,:,1,i)*B_obj(i);%%<IS>*t
    I0_bg=I0_bg+a1(:,:,1,i)*B_bg(i);%%<IS>*t
    I0_total=I0_total+a1(:,:,1,i)*B3(i);%%<IS>*t
    I1=I1+a1(:,:,1,i);
    I2=I2+B1(i);
    I2_1=I2_1+B2(i);
    I2_obj=I2_obj+B_obj(i);
    I2_bg=I2_bg+B_bg(i);
    I2_total= I2_total+B3(i);
    I3=I3+sum(sum(a1(:,:,1,i))); 
    I4=I4+sum(sum(a1(:,:,1,i)))*a1(:,:,1,i);
    I_corrmid=I_corrmid+a1(midx,midy,1,i)*a1(:,:,1,i);
    I_mid=a1(midx,midy,1,i)+I_mid;
end

%%G2=I0/t;%%�������������ɶ�
G=I0-(I1*I2)/(t-1);%%ƽ�й��ȥ������Ķ��׹���������<IS>-<I><S>��
G_1=I0_1-(I1*I2_1)/(t-1);%%��ֱ���ȥ������Ķ��׹�������
G_obj=I0_obj-(I1*I2_obj)/(t-1);%�����㷨ƽ�й�ȥ������
G_bg=I0_bg-(I1*I2_bg)/(t-1);%�����㷨��ֱ��ȥ������
G_total=I0_total-(I1*I2_total)/(t-1);%%�ܹ�ǿ��ȥ������Ķ��׹�������
DGI=I0-I2*I4/I3;%%ƽ�й���
DGI_1=I0-I2_1*I4/I3;%%��ֱ����
DGI_obj=I0-I2_obj*I4/I3;%�����㷨
DGI_bg=I0-I2_bg*I4/I3;
DGI_total=I0-I2_total*I4/I3;%%�ܹ�ǿ���
g2=I_corrmid/I_mid./I1*(t-1);

%B_average=sum(B(1:1000))/10^3/(50*50)

figure;
imagesc(G);
title('ƽ�й��ȥ������Ķ��׹���')
figure;
imagesc(G_1);
title('��ֱ���ȥ������Ķ��׹���')
figure;
imagesc(G_obj);
title('�����㷨������׹���')
figure;
imagesc(G_bg);
title('�����㷨�������׹���')

% G_add=G_1+G;
% figure;
% imagesc(G_add);
% title('Figure1��2����')
figure;
imagesc(G_total);
title('�ܹ�ǿ��ȥ������Ķ��׹���')

% figure;
% imagesc(G2);
% title('�������������ɶ�')
figure;
imagesc(DGI);
title('ƽ�й��ֹ�������')
figure;
imagesc(DGI_1);
title('��ֱ���ֹ�������')
figure;
imagesc(DGI_obj);
title('���������ֹ�������')
figure;
imagesc(DGI_bg);
title('����������ֹ�������')
figure;
imagesc(DGI_total);
title('�ܹ�ǿ��ֹ�������')
figure;
mesh(g2);
title('g2')
