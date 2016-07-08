%% 计算图像中的重叠区域
function region=find_region(edge,flag)
    [m,n]=size(edge);
    region=ones(m,n);
    Max=max(max(edge));
    if flag==1
       
        for i=1:m  
            k=1;
            tmp=[];
            for j=1:n
                if(edge(i,j)==Max)
                    tmp(k)=j;
                    k=k+1;
                end
            end
            mi=min(tmp);
            ma=max(tmp);
            if mi==0 & ma~=0
                mi=1;
            end
            region(i,mi:n)=zeros(1,n-mi+1);
        end
    end
    if flag==2
        k=1;
        for i=1:m 
            tmp=[];
            for j=1:n
                if(edge(i,j)==Max)
                    tmp(k)=j;
                    k=k+1;
                end
            end
            mi=min(tmp);
            ma=max(tmp);
            if mi==0 & ma~=0
                mi=1;
            end
            region(i,mi:ma)=zeros(1,ma-mi+1);
        end
    end
end