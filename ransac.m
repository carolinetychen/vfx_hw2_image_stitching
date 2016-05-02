function match = ransac(img1, des1, pos1, img2, des2, pos2)	
	% RANSAC parameters
	n = 3;
	p = 0.5;
	P = 0.9999;
	k = ceil(log(1 - P) / log(1 - p ^ n));
	threshold = 10;
    
    DrawPoint(img1, pos1(:, 2), pos1(:, 1));
    DrawPoint(img2, pos2(:, 2), pos2(:, 1));

	% Find matched features
	match_des = [];
    
	for i = 1 : size(des1, 1)
		min1 = [inf 0];
		min2 = [inf 0];

		% Calculate Euclidean distance between every two feature vectors
		for j = 1 : size(des2, 1)
			dist = sqrt(sum((des1(i, :) - des2(j, :)) .^ 2));
			% Find 2 closest features
            if (dist < min1(1))
                min2 = min1;
				min1 = [dist j];
            elseif (dist < min2(1))
				min2 = [dist j];
            end
        end
        % accept if distance ratio < 0.8
        if ((min1(1) / min2(1)) < 0.8)
            match_des = [match_des; [i min1(2)]];
        end
    end
    
    DrawPoint(img1, pos1(match_des(:, 1), 2), pos1(match_des(:, 1), 1));
    DrawPoint(img2, pos2(match_des(:, 2), 2), pos2(match_des(:, 2), 1));
    
    disp(match_des);
    N = size(match_des, 1);
    disp('match_des size');
    disp(N);
    
    match = [];
    if N <= n
    	match = match_des;
    	return;
    end

	% Run k times
	for times = 1 : k
		% Draw n samples randomly
		rdm = randperm(N);
		sample_index = rdm(1:n);
	    other_index = rdm(n + 1: N);

	    match_sample = match_des(sample_index, :);
	    match_other = match_des(other_index, :);
	    pos1_sample = pos1(match_sample(:, 1), :);
	    pos2_sample = pos2(match_sample(:, 2), :);
	    pos1_other = pos1(match_other(:, 1), :);
	    pos2_other = pos2(match_other(:, 2), :);

		% Fit parameter theta with these n samples
		match_tmp = match_sample;
        pos_dis = 0;
		for i = 1 : n
			pos_dis  = pos_dis + sqrt(sum(pos1_sample(i, :) - pos2_sample(i, :) .^ 2));
		end
		theta = pos_dis / n;
	    
		% For each other N - n points:
		for i = 1 : (N - n)
			% Calculate its distance to the fitted model
			d = sqrt(sum(pos1_other(i, :) - pos2_other(i, :) .^ 2)) - theta;

			% Count the number of inlier points c
			if d < threshold
				match_tmp = [match_tmp; match_other(i, :)];
			end
		end

		if size(match_tmp, 1) > size(match, 1)
			match = match_tmp;
		end
    end
	% output theta with the largest number c
end