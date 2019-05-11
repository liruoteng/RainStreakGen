function rim = rotate_and_crop(im, deg)

h = size(im, 1); 
w = size(im, 2); 

rot_img = imrotate(im, deg, 'bicubic'); 

nh = size(rot_img, 1); 
nw = size(rot_img, 2); 

rim = rot_img(uint16(w*sind(abs(deg))):nh-uint16(round(w*sind(abs(deg)))), ...
    uint16(round(h*sind(abs(deg)))):nw-uint16(h*sind(abs(deg))),:);

