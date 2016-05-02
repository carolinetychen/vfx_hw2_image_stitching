function main()
    read_cache = 0;
    save_cache = 1;
    
    % Load Images
	disp('Loading Images');
    image_serial = 'parrington/';
    directory = ['image/' image_serial];
	output_filename = [image_serial '_stitched.png'];
    files = dir([directory, '*.jpg']);
    img_num = length(files);
    img_info = imfinfo([directory, files(1).name]);
    imgy = img_info.Height;
    imgx = img_info.Width;
    img_array = {};
    
    % Load focal length
    fileID = fopen([directory 'focal_len.txt'], 'r');
    focals = fscanf(fileID, '%f');
    fclose(fileID);
    
    % Features detection
    disp('Features detection');
    for i = 1 : img_num
        ImagePath = [directory, files(i).name];
        img = imread(ImagePath); 
        warpimg{i} = warpFunction(img, focals(i));
        %img_array(:, :, :, i) = warpimg{i};
    end
    
    %match = ransac(desc{1}, pos{1}, desc{2}, pos{2});
    %trans = matchImage(match, pos{1}, pos{2});
    
    %testing
    %img = warpimg; %last one
    %[feature_x, feature_y] = HarrisDetection(img, 5, 1, 0.04, 3);
    %[orient, pos, desc] = SIFTdescriptor(img, feature_x, feature_y);
    %disp(pos);
    
            
    % Features detection
    disp('Features detection');
    for i = 1:img_num
        if read_cache
                load(sprintf('image/%s/mat/fx_%02d.mat', image_serial, i));
                load(sprintf('image/%s/mat/fy_%02d.mat', image_serial, i));
                load(sprintf('image/%s/mat/orient_%02d.mat', image_serial, i));
                load(sprintf('image/%s/mat/pos_%02d.mat', image_serial, i));
                load(sprintf('image/%s/mat/desc_%02d.mat', image_serial, i));
        else
            img = warpimg{i};
            [fx, fy] = HarrisDetection(img, 5, 1, 0.04, 3);   
            % [orient, pos, desc] = SIFTdescriptor(img, fx, fy);
            
            if (save_cache)
                save(sprintf('image/%s/mat/fx_%02d.mat', image_serial, i), 'fx');
                save(sprintf('image/%s/mat/fy_%02d.mat', image_serial, i), 'fy');
                %save(sprintf('image/%s/mat/orient_%02d.mat', image_serial, i), 'orient');
                %save(sprintf('image/%s/mat/pos_%02d.mat', image_serial, i), 'pos');
                %save(sprintf('image/%s/mat/desc_%02d.mat', image_serial, i), 'desc');
            end
        end
        %DrawPoint(img, fx, fy);
        %DrawArrow(img, pos(:, 1), pos(:, 2), orient);
        
        fxs{i} = fx;
        fys{i} = fy;
        %poss{i} = pos;
        %orients{i} = orient;
        %descs{i} = desc;
    end
    
    % Features matching
    disp('Features matching');

    
    % Images matching
    disp('Images matching');

    % Images blending
    disp('Images blending');
    %blendImage(warpimg{1}, warpimg{2}, trans);
    
end