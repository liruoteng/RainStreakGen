%test

st = zeros(3712,6400); 

%a = imread('data/Streaks_Garg06/65-1.png'); 
for i = [1,11,21,31,41,51,61, 71, 81, 91, 101, 111]
    filename = sprintf('data/dense/scene%05d.png', i); 
    a = imread(filename); 
    %b = imread('data/Sharp_line_streaks/line-streak-6.png'); 
    a = imresize(a, 4); 
    
    bwa = imbinarize(rgb2gray(a));

    dense_mask = bwareafilt(bwa, [0,1000]);


    middle_mask = bwareafilt(bwa, [1000, 5000]); 

    sparse_mask = bwareafilt(bwa, [5000,20000]);

    fa = a(:,:,1);
    fa(dense_mask==0) = 0;
    fa = imgaussfilt(fa,1);
    st = st + double(fa*0.3);

    fa = a(:,:,1);
    %fa = imnoise(fa, 'gaussian', 0, 1);
    fa(middle_mask==0) = 0;
    fa = imgaussfilt(fa,10);
    
    st = st+double(fa*0.2);
    
    fa = a(:,:,1);
    fa(sparse_mask==0) = 0; 
    fa = imgaussfilt(fa,15);
    st = st + double(fa*0.1);

end
st = imresize(st, 0.25); 
figure(2); imshow(uint8(st))
% figure(2); imshow(); title('dense image'); 
% figure(3); imshow(imgaussfilt(fa, 10)); title('middle image'); 
% figure(4);imshow(imgaussfilt(fa, 15)); title('sparse image'); 
% 
% 
