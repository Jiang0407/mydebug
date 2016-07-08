%% 检查重叠区域是否存在运动物体 
function [ret,img_edge_ret,img_region_ret]=Check_MovingTarget(new_img0,old_img0,region)
    img_edge_ret=[];
    img_region_ret=[];    
    B=ones(4);     
    new_img=rgb2gray(new_img0).*uint8(region);
    old_img=rgb2gray(old_img0).*uint8(region);    
    img=edge(new_img-old_img);
    img=imdilate(img,B);img=imdilate(img,B);
    img=imerode(img,B);img=imerode(img,B);img=imerode(img,B);
    img=medfilt2(img,[3 3]); img=medfilt2(img,[5 5]); 
    img=imdilate(img,B);    
    if 0
        subplot('Position',[0.02 0.6 0.3 0.3]),imshow(new_img0,[]),title('new img'); 
        subplot('Position',[0.35 0.6 0.3 0.3]),imshow(old_img0,[]),title('old img');
        subplot('Position',[0.68 0.6 0.3 0.3]),imshow(new_img,[]),title('new img * uint8(region)');
        subplot('Position',[0.02 0.1 0.3 0.3]),imshow(old_img,[]),title('old img * uint8(region)');
        subplot('Position',[0.35 0.1 0.3 0.3]),imshow(new_img-old_img,[]),title('new_img - old_img'); 
        subplot('Position',[0.68 0.1 0.3 0.3]),imshow(img,[]),title('result');
    end
    position_w=find(sum(img,1)>0);
    p_w_min=min(position_w);
    p_w_max=max(position_w);
    position_h=find(sum(img,2)>0);
    p_h_min=min(position_h);
    p_h_max=max(position_h);    
    if (p_h_max-p_h_min)*(p_w_max-p_w_min)<200*200
        [m,n]=size(img);
        img_edge=zeros(m,n);
        
        SIZE=100;
        if p_w_min-SIZE<1,p_w_min=1;else p_w_min=p_w_min-SIZE; end
        if p_h_min-SIZE<1,p_h_min=1;else p_h_min=p_h_min-SIZE; end
        if p_w_max+SIZE>n,p_w_max=n;else p_w_max=p_w_max+SIZE; end
        if p_h_max+SIZE>m,p_h_max=m;else p_h_max=p_h_max+SIZE; end
        
        img_edge(p_h_min:p_h_max,p_w_min)=ones(p_h_max-p_h_min+1,1)'*255;
        img_edge(p_h_min:p_h_max,p_w_max)=ones(p_h_max-p_h_min+1,1)'*255;
        img_edge(p_h_min,p_w_min:p_w_max)=ones(p_w_max-p_w_min+1,1)*255;
        img_edge(p_h_max,p_w_min:p_w_max)=ones(p_w_max-p_w_min+1,1)*255;
        img_edge_ret=imgcat(old_img0,img_edge);
        
%         img_edge(p_h_min:p_h_max,p_w_min:p_w_max)=ones(p_h_max-p_h_min+1,p_w_max-p_w_min+1);
%         img_edge=uint8((~uint8(img_edge))*255);
%         old_img0(:,:,1)=old_img0(:,:,1)-img_edge;
%         old_img0(:,:,2)=old_img0(:,:,2)-img_edge;
%         old_img0(:,:,3)=old_img0(:,:,3)-img_edge;
        img_region_ret=old_img0(p_h_min:p_h_max,p_w_min:p_w_max,:);
        ret=1;
    else
        ret=0;
    end 
%      figure(50),imshow(img);
end