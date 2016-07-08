%% 运动区域标记
function ret=imgcat(img,edge)
    edge=uint8(edge);
    img(:,:,1)=img(:,:,1)+edge;
    img(:,:,2)=img(:,:,2)-edge;
    img(:,:,2)=img(:,:,2)-edge;
    ret=img;
end