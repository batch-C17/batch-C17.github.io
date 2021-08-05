foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
        'NumTrainingFrames', 50);
    V=VideoReader('visiontraffic.avi');
    videoReader = vision.VideoFileReader('visiontraffic.avi');
    for i = 1:150
        frame = step(videoReader); % read the next video frame
        foreground = step(foregroundDetector, frame);
       end
       imwrite(frame,'D:\referenceimage.jpg','jpg');
       videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
       videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
       se = strel('square', 3); % morphological filter for noise removal
       referenceimage=imread('D:\referenceimage.jpg'); 
       X=zeros(2,121);
       Y=zeros(2,121);
       Z=zeros;
       while ~isDone(videoReader)
           frame = step(videoReader); % read the next video frame
           % Detect the foreground in the current video frame
           foreground = step(foregroundDetector, frame);
           % Use morphological opening to remove noise in the foreground
           filteredForeground = imopen(foreground, se);
           %-----------------------SPEED ---------------------------%
           frame2=((im2double(frame))-(im2double(referenceimage)));
           frame1=im2bw(frame2,0.1); 
           [Labelimage]=bwlabeln(frame1); 
           stats=regionprops(Labelimage,'basic');
           BB=stats.BoundingBox;
           i=2; %fblasst for
           X(i)=BB(1);
           Y(i)=BB(2);
           Dist=((X(i)-X(i-1))^2+(Y(i)-Y(i-1))^2)^(1/2);
           Z(i)=Dist;
           M=median(Z);
           %disp(M);
           %clc;
           %disp('speed=')
           Speed=((M)*(120/8))/(4);
           %disp(Speed);
           %SPEED = M ???????????
           i = i + 1;
           SE = strel('disk',6); 
           frame3=imclose(frame1,SE); 
           step(videoReader); 
           pause(0.05);
              %if(i==121) end; ??
        %-----------------------SPEED ---------------------------%
        % Detect the connected components with the specified minimum area, and
        % compute their bounding boxes
        blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', true, 'CentroidOutputPort', true, ...
        'MinimumBlobArea', 150);
        %bbox = step(blobAnalysis, filteredForeground);
        [areas, centroids, bbox] = step(blobAnalysis, filteredForeground);
        % Draw bounding boxes around the detected cars
        result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');
        % Display the number of cars found in the video frame
        %ICI
        %disp(centroids); //show...
        %disp(size(centroids));//show....
        numCars = size(bbox, 1); %cars ...
        numCars_str = ['car number:', num2str(size(bbox, 1))];
        speed_str = [num2str(Speed),'KM/h'];
        result = insertText(result,[10,10],numCars_str, 'BoxOpacity', 1, ...
            'FontSize', 14);
        for i=1:size(bbox, 1)
        result = insertText(result,[centroids(i,1),centroids(i,2)], speed_str, 'BoxOpacity', 1, ...
            'FontSize', 20);
           end;
           step(videoPlayer, result);  % display the results
       end;
       release(videoReader); % close the video file