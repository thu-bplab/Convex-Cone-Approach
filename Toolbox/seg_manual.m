function seg_domain=seg_manual(pa_img,domain_num)
disp('stop when click on the same point');

J=ones(size(pa_img,1),1)*(1:size(pa_img,2));
I=(1:size(pa_img,1)).'*ones(1,size(pa_img,2));
[x,y]=ginput(1);
count=1;
coor=[x;y];
hold on;
plot(x,y,'r.');
title(strcat('segment domain ',num2str(domain_num),': point NO.',num2str(count)));
hold on

while true
    count=count+1;
    [x,y]=ginput(1);
    if(norm([x;y]-coor(:,end))==0)
        break;
    end    
    coor=[coor [x;y]];
    hold on;
    plot(x,y,'r.');
    hold on
    title(strcat('segment domain ',num2str(domain_num),': point NO.',num2str(count)));    
end

coor=[coor coor(:,1)];
hold on;plot(coor(1,:),coor(2,:),'r-');hold off;
seg_domain=inpolygon(J,I,coor(1,:),coor(2,:));

