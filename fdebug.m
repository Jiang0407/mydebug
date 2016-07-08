close all
clear all
clc

addpath('../')
load Copy_of_BBXX-0707-4.mat
pathP='F:/桌面杂/0707/Pano/pano';
retpathP='F:/桌面杂/0707/Pano_ret/ret';
retpathR='F:/桌面杂/0707/Pano_right/imgR';
pathL='F:/桌面杂/0707/imageL/imgL';
pathR='F:/桌面杂/0707/imageR/imgR';
[m,n,~]=size(warp_img);
%% 确定重叠区域在原始图像中的位置
sti=uint8(sti_mask(:,:,3));
sti(find(sti==12))=255;
sti=(medfilt2(sti));
img_edge0=edge(sti);
B=[0 1 0; 1 1 1; 0 1 0];
pano_edge=imdilate(img_edge0,B)*255;
pano_region=find_region(pano_edge,1);
pano_region=pano_region+find_region(pano_edge,2);
pano_region=(pano_region*255)/255;
% imshow(pano_region);

%% 确定原始图像中的重叠区域
%  XXX_edge    存放的分别是重叠区域的轮廓
%  XXX_region  存放的分别是重叠区域,其中重叠区域为0，非重叠区域为1；
img_name{1}=strcat(strcat(pathL,num2str(100)),'.bmp');
img_name{2}=strcat(strcat(pathR,num2str(100)),'.bmp');
img=cell(num_img,1);
for i=1:num_img
    img{i}=imread( img_name{i} );
end
[ml,nl,~]=size(img{1});
[mr,nr,~]=size(img{2});
imgL_edge=zeros(ml,nl);
imgR_edge=zeros(mr,nr);

for i=1:m
    for j=1:n
        if img_edge0(i,j)==1
            if sti_mask(i,j,3)==1
                imgL_edge(sti_mask(i,j,1),sti_mask(i,j,2))=1;
            elseif sti_mask(i,j,3)==12
                imgL_edge(ble_mask(i,j,1),ble_mask(i,j,2))=1;
            end
            if sti_mask(i,j,3)==2
                imgR_edge(sti_mask(i,j,1),sti_mask(i,j,2))=1;
            elseif sti_mask(i,j,3)==12
                imgR_edge(ble_mask(i,j,3),ble_mask(i,j,4))=1;
            end
        end
    end
end
imgL_edge=imdilate(imgL_edge,B);
imgR_edge=imdilate(imgR_edge,B);
imgL_region=find_region(imgL_edge,1);
imgR_region=find_region(imgR_edge,2);
if 0
    figure,imshow(imgL_region,[]),title('imgL_region');
    figure,imshow(imgR_region,[]),title('imgR_region');
    figure,imshow(imgcat(img{1},imgL_edge*255),[]),title('imgL_edge');
    figure,imshow(imgcat(img{2},imgR_edge*255),[]),title('imgR_edge');
end
%% 测试全景图中运动检测程序 
%     pano_edge=pano_edge/max(max(pano_edge));
%     img_nameP=strcat(strcat(pathP,num2str(100)),'.bmp');
%     imgP00=imread(img_nameP);
%     for imgN=101:150
%         fprintf( 'imgN =%d \n',imgN);
%         img_nameP=strcat(strcat(pathP,num2str(imgN)),'.bmp');
%         imgP=imread(img_nameP);
%         Check_MovingTarget2(imgP00,imgP,~pano_region);
%         imgP00=imgP;
%     end 
    
%% 测试 原始图像中运动检测程序
    img_name{1}=strcat(strcat(pathL,num2str(100)),'.bmp');
    img_name{2}=strcat(strcat(pathR,num2str(100)),'.bmp');
    imgL00=imread( img_name{1} );
    imgR00=imread( img_name{2} );
    for imgN=183:190
        fprintf( 'imgN =%d \n',imgN);
        img_name{1}=strcat(strcat(pathL,num2str(imgN)),'.bmp');
        img_name{2}=strcat(strcat(pathR,num2str(imgN)),'.bmp');
        img=cell(num_img,1);
        for i=1:num_img
            img{i}=imread( img_name{i} );
        end

%         Check_MovingTarget(imgL00,img{1},~imgL_region);
%         imgL00=img{1};  
         [retR,imgR_with_edge,imgR_with_region] =Check_MovingTarget(imgR00,img{2},~imgR_region);
        
         imgR00=img{2};
         figure,imshow(imgR_with_edge)
    end
%% 开始主循环
kk=1;
last_IMG=[];
StartNum=148;
img_name1=strcat(strcat(pathL,num2str(StartNum-1)),'.bmp');
img_name2=strcat(strcat(pathR,num2str(StartNum-1)),'.bmp'); 
imgL00=imread(img_name1);
imgR00=imread(img_name2); 

for imgN=StartNum:1:232
    fprintf( 'imgN =%d \n ',imgN);
    
    img_name{1}=strcat(strcat(pathL,num2str(imgN)),'.bmp');
    img_name{2}=strcat(strcat(pathR,num2str(imgN)),'.bmp');
    
    img=cell(num_img,1);
    for i=1:num_img
        img{i}=imread( img_name{i} );
    end
    IMG=uint8(zeros(m,n,3));
    tic;
    for i=1:m
        for j=1:n
            switch sti_mask(i,j,3)
                case 1
                    IMG(i,j,:)=img{1}(sti_mask(i,j,1),sti_mask(i,j,2),:);
                case 12
                    IMG(i,j,:)=sti_mask(i,j,1)*img{1}(ble_mask(i,j,1),ble_mask(i,j,2),:)+sti_mask(i,j,2)*img{2}(ble_mask(i,j,3),ble_mask(i,j,4),:);
                    %IMG(i,j,:)=0.5*img{1}(ble_mask(i,j,1),ble_mask(i,j,2),:)+0.5*img{2}(ble_mask(i,j,3),ble_mask(i,j,4),:);
                case 2
                    IMG(i,j,:)=img{2}(sti_mask(i,j,1),sti_mask(i,j,2),:);
            end
        end
    end
    fprintf( 'time = %fs \n ',toc);
    [retL,imgL_with_edge,imgL_with_region] = Check_MovingTarget(imgL00,img{1},~imgL_region);
    [retR,imgR_with_edge,imgR_with_region] = Check_MovingTarget(imgR00,img{2},~imgR_region);
    imgL00=img{1};
    imgR00=img{2};
    if retL==1 && retR==1 && kk>1
        figure(1),imshow(imgL_with_region),title('imgL with region');
        figure(2),imshow(imgR_with_region),title('imgR with region');
        [ret,pano_with_edge,pano_with_region]=Check_MovingTarget2(last_IMG,IMG,~pano_region);
        if(ret==1) 
            figure(3),imshow(imgcat2(pano_with_edge,pano_edge)),title('pano with edge');
            figure(4),imshow(pano_with_region),title('pano with region');
            imwrite(imgR_with_region,strcat(strcat(retpathR,num2str(imgN)),'.bmp'));
            imwrite(pano_with_region,strcat(strcat(retpathP,num2str(imgN)),'.bmp'));   
        end
    end
    last_IMG=IMG;    
%     imwrite(IMG,strcat(strcat(pathP,num2str(imgN)),'.bmp'));    
    kk=kk+1;
    
end