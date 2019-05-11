% render multi-layer rain
% no haze model

% 1. render most dense rain streaks
streak_root = 'data/dense/'; 
image_root = 'data/BSD300/';
img_file_list = dir([image_root, '*.jpg']); 
num_of_strtype = 11;
num_of_file = length(img_file_list); 

rain_list_stats = fopen('rain.txt', 'w'); 
sparse_list_stats = fopen('sparse.txt', 'w'); 
middle_list_stats = fopen('mid.txt', 'w'); 
dense_list_stats = fopen('dense.txt', 'w'); 
clean_list_stats = fopen('norain.txt', 'w'); 

for fileindex = 1%:num_of_file 
    im = imread([image_root, img_file_list(fileindex).name]); 
    [~, filename, ~] = fileparts(img_file_list(fileindex).name);
    bh = size(im, 1);
    bw = size(im, 2); 

    for str_index = 1%:num_of_strtype
        
        clean_final = double(im); 
        st_final = zeros(bh, bw, 3); 
        %str_file_list = dir([streak_root, sprintf('*-%d.png', str_index)]);
        str_file_list = dir([streak_root, '*.png']);
        
        stage_st_final = zeros(bh,bw,3);
        % dense
        for i = 1:8
            strnum = randi(length(str_file_list));
            st = imread([streak_root, str_file_list(strnum).name]);
            st = st(4:end, :,:);
            st = imresize(st, 4); 
            newst = zeros(size(st));
            bwst = imbinarize(rgb2gray(st));
            mask = bwareafilt(bwst, [0, 1000]);
            
            for c = 1:3
                temp = st(:,:,c);
                %temp(mask==0) = 0;
                temp = temp.*uint8(mask);
                newst(:,:,c) = imgaussfilt(temp, 1);
            end
            
            newst = imresize(newst, [bh, bw]); 
            tr = rand() * 0.2 + 0.25;
            clean_final = clean_final + double(newst) * tr;
            st_final = st_final + double(newst)*tr;
            stage_st_final = stage_st_final + double(newst)*tr;
        end
        
        % write dense streak
        imwrite(uint8(stage_st_final), sprintf('out/str%s-type%d-dense.png', filename, str_index));
        
        % write dense streak file into file list
        fprintf(dense_list_stats, sprintf('out/str%s-type%d-dense.png\n', filename, str_index));
        
        disp('dense'); disp(mean(stage_st_final(:)))
        
        % middle
        stage_st_final = zeros(bh,bw,3);
        for i = 1:8
            strnum = randi(length(str_file_list));
            st = imread([streak_root, str_file_list(strnum).name]);
            st = st(4:end, :,:);
            st = imresize(st, 4);  
            newst = zeros(size(st));
            bwst = imbinarize(rgb2gray(st));
            mask = bwareafilt(bwst, [800, 4000]); 
            
            for c = 1:3
                temp = st(:,:,c);
                %temp(mask==0) = 0;
                temp = temp.*uint8(mask);
                newst(:,:,c) = imgaussfilt(temp, 2);
            end
            
            newst = imresize(newst, 0.5); 
            sh = size(newst, 1); 
            sw = size(newst, 2);
            
            for iter = 1:6
                row = randi(sh - bh);
                col = randi(sw - bw);

                selected = newst(row:row+bh-1, col:col+bw-1, :);
                tr = rand() * 0.15 + 0.20;
                clean_final = clean_final + double(selected) * tr;
                st_final = st_final + double(selected)*tr; 
                stage_st_final = stage_st_final + double(selected)*tr;
            end
            
        end
        
        % middle streak image
        imwrite(uint8(stage_st_final),sprintf('out/str%s-type%d-mid.png', filename, str_index)); 
        % imwrite middle streak file into file list
        fprintf(middle_list_stats, sprintf('out/str%s-type%d-mid.png\n', filename, str_index));
        
        disp('middle'); disp(mean(stage_st_final(:)))
        
        % sparse
        stage_st_final = zeros(bh,bw,3);
        for i = 1:3
            strnum = randi(length(str_file_list));
            st = imread([streak_root, str_file_list(strnum).name]);
            st = st(4:end, :,:);
            st = imresize(st, 4); 
            newst = zeros(size(st));
            bwst = imbinarize(rgb2gray(st));
            mask = bwareafilt(bwst, [2000, 6000]); 
            
            for c = 1:3
                temp = st(:,:,c);
                %temp(mask==0) = 0;
                temp = temp.*uint8(mask);
                %newst(:,:,c) = temp;
                newst(:,:,c) = imgaussfilt(temp, 1);
            end
            
            sh = size(newst, 1); 
            sw = size(newst, 2);
            for iter = 1:6
                row = randi(sh - bh);
                col = randi(sw - bw);

                selected = newst(row:row+bh-1, col:col+bw-1, :);
                tr = rand() * 0.1 + 0.10;
                clean_final = clean_final + double(selected) * tr;
                st_final = st_final + double(selected)*tr; 
                stage_st_final = stage_st_final + double(selected)*tr;
            end

        end
        
        % write rain image
        imwrite(uint8(clean_final), sprintf('out/img%s-type%d-sparse.png',filename, str_index));
        % write sparse rain streak image
        imwrite(uint8(stage_st_final), sprintf('out/str%s-type%d-sparse.png', filename, str_index));
        % write all rain streak image
        imwrite(uint8(st_final), sprintf('out/str%s-type%d-all.png', filename, str_index));
        % write rain image into file list
        fprintf(rain_list_stats, sprintf('out/img%s-type%d-sparse.png\n',filename, str_index));
        % write sparse
        fprintf(sparse_list_stats, sprintf('out/str%s-type%d-sparse.png\n', filename, str_index));
        % write no rain
        fprintf(clean_list_stats, sprintf('BSD300/%s\n', img_file_list(fileindex).name));
        disp('sparse'); disp(mean(stage_st_final(:)));
    end

end

