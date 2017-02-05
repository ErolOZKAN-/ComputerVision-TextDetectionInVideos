function boxes= myMethod(rgbImage,darkBackgroundLightText)
%% SETUP
run C:\vlfeat-0.9.20\toolbox\vl_setup.m
grayImage = uint8(rgb2gray(rgbImage));
MinDiversity = 0.9; % This value lies between 0 and 1
MaxVariation = 0.1; % This value lies between 0 and 1
Delta = 10;
%% Extract MSER features
[r,f] = vl_mser(grayImage,'MinDiversity',MinDiversity,'MaxVariation',MaxVariation,'Delta',Delta) ;
mserRegions = zeros(size(grayImage));
for x=r'
    s = vl_erfill(grayImage,x);
    mserRegions(s) = mserRegions(s)+1;
end
MSER_binary = mserRegions >= 1;
figure; imshow(MSER_binary); title('MSER BINARY IMAGE');
%% Extract Canny Edge features
Canny_binary = edge(grayImage,'Canny');
figure; imshow(Canny_binary); title('CANNY BINARY IMAGE');
%% Combine the two features together
Canny_MSER_binary = Canny_binary & MSER_binary;
figure; imshow(Canny_MSER_binary); title('COMBINED CANNY AND MSER');
%% Grow edge along gradient
[jimo,Gradient_Direction] = imgradient(grayImage);
Growth_Direction=round((Gradient_Direction + 180) / 360 * 8); 
Growth_Direction(Growth_Direction == 0) = 8;

if darkBackgroundLightText % when we have dark text and light background, reverse growth direction
    Growth_Direction = mod(Growth_Direction + 3, 8) + 1;
end

% Bulid growing structure template
% Diagonal template
NW_Template = [1,1,1,1,1,0,0;1,1,1,1,1,0,0;1,1,1,1,1,0,0;...
    1,1,1,1,0,0,0;1,1,1,0,0,0,0;zeros(2,7)];

% Horizontal and Vertical template
N_Template = [0,1,1,1,1,1,0;0,1,1,1,1,1,0;0,1,1,1,1,1,0;...
    0,1,1,1,1,1,0;zeros(3,7)];

N = strel(N_Template);
W = strel(rot90(N_Template,1));
S = strel(rot90(N_Template,2));
E = strel(rot90(N_Template,3));
NW = strel(NW_Template);
SW = strel(rot90(NW_Template,1));
SE = strel(rot90(NW_Template,2));
NE = strel(rot90(NW_Template,3));

Strels = [NE,N,NW,W,SW,S,SE,E];

Gradient_binary = false(size(Canny_MSER_binary));
% Let's grow edges
for i = 1:numel(Strels)
    Temp_Direction = false(size(Canny_MSER_binary));
    Temp_Direction(Canny_MSER_binary == true & Growth_Direction == i ) = true;
    Temp_Direction = imdilate(Temp_Direction,Strels(i));
    Gradient_binary = Gradient_binary | Temp_Direction;
end
Gra_grow_binary = ~Gradient_binary & MSER_binary;

figure; imshow(Gra_grow_binary); title('GROWED EDGES');
%% We first find connected components
%Here in our image we reject very large or very small objects
%reject very large or very small Aspect Ratio
%reject objects with lots of holes
Connected_comp = bwconncomp(Gra_grow_binary); % Find connected components
Con_Com_small = 10; % Connected Component smallest region threshold
Con_Com_large = 2000; % Connected Component largest region threshold
Con_Com_AR = 5; % Connected Component Aspect Ratio threshold
Con_Com_EulerNumber = -3; % Connected Component Euler Number threshold
Connected_data = regionprops(Connected_comp,'Area','EulerNumber','Image');
Masked_binary = Gra_grow_binary;
%% Rule 1, reject very large or very small objects
Masked_binary(vertcat(Connected_comp.PixelIdxList{[Connected_data.Area] < Con_Com_small | [Connected_data.Area] > Con_Com_large})) = 0;
figure; imshow(Masked_binary); title('IMAGE AFTER REMOVING VERY LARGE OR VERY SMALL OBJECTS');
figure; imshow(Gra_grow_binary-Masked_binary); title('DIFFERENCE AFTER REMOVING VERY LARGE OR VERY SMALL OBJECTS');
oldImage = Masked_binary;
%% Rule 2, reject very large or very small Aspect Ratio
C = {Connected_data(:).Image};
AspectRatio = cellfun(@(x)max(size(x))./min(size(x)),C);
Masked_binary(vertcat(Connected_comp.PixelIdxList{AspectRatio >= Con_Com_AR})) = 0;
figure; imshow(Masked_binary); title('IMAGE AFTER REMOVING VERY LARGE OR VERY SMALL ASPECT RATIO');
figure; imshow(oldImage-Masked_binary); title('DIFFERENCE AFTER REMOVING VERY LARGE OR VERY SMALL ASPECT RATIO');
oldImage = Masked_binary;
%% Rule 3, reject objects with lots of holes
Masked_binary(vertcat(Connected_comp.PixelIdxList{[Connected_data.EulerNumber] <= Con_Com_EulerNumber})) = 0;
figure; imshow(Masked_binary); title('IMAGE AFTER REMOVING OBJECT WITH LOTS OF HOLES');
figure; imshow(oldImage-Masked_binary); title('DIFFERENCE AFTER REMOVING OBJECT WITH LOTS OF HOLES');
%%
stdm_thre=0.35;
Distance_image = bwdist(~Masked_binary);

% The following algorithm follows the paper
Distance_image = round(Distance_image);

% Define 8-connected neighbors
connect = [1 0;-1 0;1 1;0 1;-1 1;1 -1;0 -1;-1 -1]';
padded_distance_image = padarray(Distance_image,[1,1]);
D_ind = find(padded_distance_image ~= 0);
sz=size(padded_distance_image);

% Compare current pixel with its neighbors
neighbor_ind = repmat(D_ind,[1,8]);
[x,y] = ind2sub(sz,neighbor_ind);
x = bsxfun(@plus,x,connect(1,:));
y = bsxfun(@plus,y,connect(2,:));
neighbor_ind = sub2ind(sz,x,y);
LookUp = bsxfun(@lt,padded_distance_image(neighbor_ind),padded_distance_image(D_ind));

% Propagate local maximum stroke values to neighbors recursively
MaxStroke = max(max(padded_distance_image));
for Stroke = MaxStroke:-1:1
    neighbor_ind_temp = neighbor_ind(padded_distance_image(D_ind) == Stroke,:);
    LookUp_temp = LookUp(padded_distance_image(D_ind) == Stroke,:);
    NeighborIndex = neighbor_ind_temp(LookUp_temp);
    while ~isempty(NeighborIndex)
        padded_distance_image(NeighborIndex) = Stroke;       
        [~,ia,~] = intersect(D_ind,NeighborIndex);
        neighbor_ind_temp = neighbor_ind(ia,:);
        LookUp_temp = LookUp(ia,:);
        NeighborIndex = neighbor_ind_temp(LookUp_temp);
    end
end

% Remove pad to restore original image size
Width_image = padded_distance_image(2:end-1,2:end-1);

% figure; imshow(Width_image);
% caxis([0 max(max(Width_image))]); axis image, colormap('jet'), colorbar;
Connected_comp = bwconncomp(Masked_binary);
Width_masked_binary = Masked_binary;
for i = 1:Connected_comp.NumObjects
    strokewidths = Width_image(Connected_comp.PixelIdxList{i});
    % Compute normalized stroke width variation and compare to common value
    if std(strokewidths)/mean(strokewidths) > stdm_thre
        Width_masked_binary(Connected_comp.PixelIdxList{i}) = 0; % Remove from text candidates
    end
end
figure, imshow(Width_masked_binary);
%%
se1=strel('disk',25);
se2=strel('disk',7);

Morphed_mask = imclose(Width_masked_binary,se1);
Morphed_mask = imopen(Morphed_mask,se2);

figure, imshow(Morphed_mask,[]);
%%
T_area=str2num('2000');
Connected_comp = bwconncomp(Morphed_mask);
Connected_data = regionprops(Connected_comp,'BoundingBox','Area');
boxes = round(vertcat(Connected_data(vertcat(Connected_data.Area) > T_area).BoundingBox));


