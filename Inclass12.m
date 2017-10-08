%Inclass 12. 

% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 
file1 = ('011917-wntDose-esi017-RI_f0016.tif');
reader = bfGetReader(file1);

zplane = 1;
chan2 = 2;
time = 30 ;

iplane2 = reader.getIndex (zplane-1, chan2-1, time-1) +1;

img2 = bfGetPlane(reader, iplane2);
img2_sm = imfilter(img2, fspecial('gaussian',10,3)); 
img2_bg = imopen(img2_sm, strel('disk',30)); 
img2_sm_bgsub = imsubtract (img2_sm, img2_bg); 
imshow(img2_sm_bgsub, [0 800]); 
% 2. threshold this image to get a mask that marks the cell nuclei. 
img_bw = img2_sm_bgsub > 50;
imshow(img_bw)
% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)
imclose1 = imclose(img_bw, strel('disk', 5)); 
imshow(imclose1); 

%we can the size of the nucleus is centered around 1500. 
% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other
chan1 = 1; 
iplane1 = reader.getIndex (zplane-1, chan1-1, time-1) +1;
img1 = bfGetPlane(reader, iplane1);

cell_properties1 = regionprops(img_bw, img2_sm_bgsub, 'MeanIntensity', 'Maxintensity', 'Area', 'Centroid');
cell_properties2 = regionprops(img_bw, img1, 'MeanIntensity', 'Maxintensity', 'Area', 'Centroid');

intensities1 = [cell_properties1.MeanIntensity];
intensities2 = [cell_properties2.MeanIntensity];

plot(intensities1, intensities2, 'r.', 'MarkerSize', 18); 