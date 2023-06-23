%%两臂CCD成像实验
clc
clearvars;
%%读取参考臂数据
FilePath='F:\实验数据\9.12\3';
v=VideoReader([FilePath '\cam0.avi']);%a1参考臂
%N=v.NumberofFrames; 
a1=read(v,[1 1500]);
a1=double(a1);
[x,y,z,t]=size(a1);
clear v;
vv=VideoReader([FilePath '\cam2.avi']);%a2平行光（保偏部分）
a2=read(vv,[1 1500]);
a2=double(a2);
[x2,y2,z2,t2]=size(a2);
clear vv ;
B1=zeros(1,1500);
B2=zeros(1,1500);
B3=zeros(1,1500);
B_obj=zeros(1,1500);
B_bg=zeros(1,1500);
D_obj=0.839;%偏振度
D_bg=0.945;
for i=2:t
    B1(i)=sum(sum(a2(:,:,1,i)));%%平行光桶探测
end
   clear a2 ;
vvv=VideoReader([FilePath '\cam1.avi']);%a3竖直光（退偏部分）
a3=read(vvv,[1 1500]);
a3=double(a3);
[x3,y3,z3,t3]=size(a3);
clear vvv;
for i=2:t
    B2(i)=sum(sum(a3(:,:,1,i)));%%竖直光桶探测
    B3(i)=B1(i)+B2(i);
    B_obj(i)=(B2(i)*(1+D_bg)-B1(i)*(1-D_bg))/(D_bg-D_obj);%%改良算法平行光强
    B_bg(i)=(B1(i)*(1-D_obj)-B2(i)*(1+D_obj))/(D_bg-D_obj);%%改良算法竖直光
end
clear a3;

midx=x/2;%视场中央
midy=y/2;%视场中央



% for i=2:t
%     B1(i)=sum(sum(a2(:,:,1,i)));%%平行光桶探测
%     B2(i)=sum(sum(a3(:,:,1,i)));%%竖直光桶探测
%     B3(i)=B1(i)+B2(i);
% end
I0=0;
I0_1=0;%%竖直光的<IS>*t
I0_obj=0;
I0_bg=0;
I0_total=0;%%保偏退偏总光强
I1=0;%%参考臂叠加
I2=0;%%平行光叠加
I2_1=0;%%竖直光叠加
I2_obj=0;
I2_bg=0;
I2_total=0;%%总光强叠加
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

%%G2=I0/t;%%关联成像二阶相干度
G=I0-(I1*I2)/(t-1);%%平行光减去背景项的二阶关联函数（<IS>-<I><S>）
G_1=I0_1-(I1*I2_1)/(t-1);%%竖直光减去背景项的二阶关联函数
G_obj=I0_obj-(I1*I2_obj)/(t-1);%改良算法平行光去背景项
G_bg=I0_bg-(I1*I2_bg)/(t-1);%改良算法竖直光去背景项
G_total=I0_total-(I1*I2_total)/(t-1);%%总光强减去背景项的二阶关联函数
DGI=I0-I2*I4/I3;%%平行光差分
DGI_1=I0-I2_1*I4/I3;%%竖直光差分
DGI_obj=I0-I2_obj*I4/I3;%改良算法
DGI_bg=I0-I2_bg*I4/I3;
DGI_total=I0-I2_total*I4/I3;%%总光强差分
g2=I_corrmid/I_mid./I1*(t-1);

%B_average=sum(B(1:1000))/10^3/(50*50)

figure;
imagesc(G);
title('平行光减去背景项的二阶关联')
figure;
imagesc(G_1);
title('竖直光减去背景项的二阶关联')
figure;
imagesc(G_obj);
title('改良算法物体二阶关联')
figure;
imagesc(G_bg);
title('改良算法背景二阶关联')

% G_add=G_1+G;
% figure;
% imagesc(G_add);
% title('Figure1、2叠加')
figure;
imagesc(G_total);
title('总光强减去背景项的二阶关联')

% figure;
% imagesc(G2);
% title('关联成像二阶相干度')
figure;
imagesc(DGI);
title('平行光差分关联成像')
figure;
imagesc(DGI_1);
title('竖直光差分关联成像')
figure;
imagesc(DGI_obj);
title('改良物体差分关联成像')
figure;
imagesc(DGI_bg);
title('改良背景差分关联成像')
figure;
imagesc(DGI_total);
title('总光强差分关联成像')
figure;
mesh(g2);
title('g2')
