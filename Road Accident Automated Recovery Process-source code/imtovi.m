workingDir = 'D:\Accident check';
mkdir(workingDir)
mkdir(workingDir,'images')
shuttleVideo = VideoReader('D:\accident detection machine learning\ca.mp4');
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
