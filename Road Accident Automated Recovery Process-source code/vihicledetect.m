 % Object for reading video file.
filename = 'C:\video\ca.mp4';
hVidReader = vision.VideoFileReader(filename, 'ImageColorSpace', 'RGB',...
                              'VideoOutputDataType', 'single');
  hOpticalFlow = vision.OpticalFlow('OutputValue', 'Horizontal and vertical components in complex form', 'ReferenceFrameDelay', 3);
hMean1 = vision.Mean;
hMean2 = vision.Mean('RunningMean', true);
hMedianFilt = vision.MedianFilter;
hclose = vision.MorphologicalClose('Neighborhood', strel('line',5,45));
%Create a System object to detect foreground using gaussian mixture models.
hfdet = vision.ForegroundDetector(...
        'NumTrainingFrames', 5, ...     % only 5 because of short video
        'InitialVariance', (30/255)^2); % initial standard deviation of 30/255
hblob = vision.BlobAnalysis(...
    'CentroidOutputPort', false, 'AreaOutputPort', true, ...
    'BoundingBoxOutputPort', true, 'OutputDataType', 'double', ...
    'MinimumBlobArea', 250, 'MaximumBlobArea', 3600, 'MaximumCount', 80);
herode = vision.MorphologicalErode('Neighborhood', strel('square',2));
hshapeins1 = vision.ShapeInserter('BorderColor', 'Custom', ...
                                  'CustomBorderColor', [0 1 0]);
hshapeins2 = vision.ShapeInserter( 'Shape','Lines', ...
                                   'BorderColor', 'Custom', ...
                                   'CustomBorderColor', [255 255 0]);
   htextins = vision.TextInserter('Text', '%4d', 'Location',  [1 1], ...
                               'Color', [1 1 1], 'FontSize', 12);
     sz = get(0,'ScreenSize');
pos = [20 sz(4)-300 200 200];
hVideo1 = vision.VideoPlayer('Name','Original Video','Position',pos);
pos(1) = pos(1)+220; % move the next viewer to the right
hVideo2 = vision.VideoPlayer('Name','Motion Vector','Position',pos);
pos(1) = pos(1)+220;
hVideo3 = vision.VideoPlayer('Name','Thresholded Video','Position',pos);
pos(1) = pos(1)+220;
hVideo4 = vision.VideoPlayer('Name','accident','Position',pos);
% Initialize variables used in plotting motion vectors.
lineRow   =  22;
firstTime = true;
motionVecGain  = 20;
borderOffset   = 5;
decimFactorRow = 5;
decimFactorCol = 5;
while ~isDone(hVidReader)  % Stop when end of file is reached
    frame  = step(hVidReader);  % Read input video frame
    grayFrame = rgb2gray(frame);
    ofVectors = step(hOpticalFlow, grayFrame);   % Estimate optical flow
    % The optical flow vectors are stored as complex numbers. Compute their
    % magnitude squared which will later be used for thresholding.
    y1 = ofVectors .* conj(ofVectors);
    % Compute the velocity threshold from the matrix of complex velocities.
    vel_th = 0.5 * step(hMean2, step(hMean1, y1));
    % Threshold the image and then filter it to remove speckle noise.
    segmentedObjects = step(hMedianFilt, y1 >= vel_th);
    % Thin-out the parts of the road and fill holes in the blobs.
    segmentedObjects = step(hclose, step(herode, segmentedObjects));
    % Estimate the area and bounding box of the blobs.
    [area, bbox] = step(hblob, segmentedObjects);
    % Select boxes inside ROI (below white line).
    Idx = bbox(:,1) > lineRow;
    % Based on blob sizes, filter out objects which can not be cars.
    % When the ratio between the area of the blob and the area of the
    % bounding box is above 0.4 (40%), classify it as a car.
    ratio = zeros(length(Idx), 1);
    ratio(Idx) = single(area(Idx,1))./single(bbox(Idx,3).*bbox(Idx,4));
    ratiob = ratio > 0.4;
    count = int32(sum(ratiob));    % Number of cars
    bbox(~ratiob, :) = int32(-1);
    % Draw bounding boxes around the tracked cars.
    y2 = step(hshapeins1, frame, bbox);
    % Display the number of cars tracked and a white line showing the ROI.
    y2(22:23,:,:)   = 1;   % The white line.
    y2(1:15,1:30,:) = 0;   % Background for displaying count
    result = step(htextins, y2, count);
    % Generate coordinates for plotting motion vectors.
    if firstTime
      [R C] = size(ofVectors);            % Height and width in pixels
      RV = borderOffset:decimFactorRow:(R-borderOffset);
      CV = borderOffset:decimFactorCol:(C-borderOffset);
      [Y X] = meshgrid(CV,RV);
      firstTime = false;
    end
    % Calculate and draw the motion vectors.
    tmp = ofVectors(RV,CV) .* motionVecGain;
    lines = [Y(:), X(:), Y(:) + real(tmp(:)), X(:) + imag(tmp(:))];
    motionVectors = step(hshapeins2, frame, lines);
    % Display the results
    step(hVideo1, frame);            % Original video
    step(hVideo2, motionVectors);    % Video with motion vectors
    step(hVideo3, segmentedObjects); % Thresholded video
    step(hVideo4, result);           % Video with bounding boxes
end




foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
'NumTrainingFrames', 50);
    V=VideoReader('C:\video\ca.mp4');
    videoReader = vision.VideoFileReader('C:\video\ca.mp4');
    for i = 1:150
        frame = step(videoReader); % read the next video frame
        foreground = step(foregroundDetector, frame);
       end
      % imwrite(frame,'C:\referenceimage.jpg','jpg');
     imwrite(frame,'C:\Users\Venka\Desktop\refer\referenceimage.jpg','jpg');
       videoPlayer = vision.VideoPlayer('Name', 'Detected Cars speed and wieght of accident ');
       videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
       se = strel('square', 3); % morphological filter for noise removal
      % referenceimage=imread('C:\referenceimage.jpg'); 
      referenceimage=imread('C:\Users\Venka\Desktop\refer\referenceimage.jpg'); 
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
       
       
       
       
      workingDir = 'C:\Accident check';
mkdir(workingDir)
mkdir(workingDir,'images')
shuttleVideo = VideoReader('C:\video\ca.mp4');
ii = 1;

while hasFrame(shuttleVideo)
   img = readFrame(shuttleVideo);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = fullfile(workingDir,'images',filename);
   imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
   ii = ii+1;
end
imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';
outputVideo = VideoWriter(fullfile(workingDir,'accident.avi'));
outputVideo.FrameRate = shuttleVideo.FrameRate;
open(outputVideo)
for ii = 1:length(imageNames)
   img = imread(fullfile(workingDir,'images',imageNames{ii}));
   writeVideo(outputVideo,img)
end
close(outputVideo)
shuttleAvi = VideoReader(fullfile(workingDir,'accident.avi'));
ii = 1;
while hasFrame(shuttleAvi)
   mov(ii) = im2frame(readFrame(shuttleAvi));
   ii = ii+1;
end
figure
imshow(mov(1).cdata, 'Border', 'tight')
movie(mov,1,shuttleAvi.FrameRate)
myaddress = 'haritest69@gmail.com';
mypassword = 'Hari123456';
setpref('Internet','E_mail',myaddress);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',myaddress);
setpref('Internet','SMTP_Password',mypassword);
props = java.lang.System.getProperties;
%% i
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class','javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
sendmail('ashwini.achu0310@gmail.com','accident detection system','recover your patient ','C:\Accident check\images\570.jpg')