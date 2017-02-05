function Morphed_mask= BoundryFill(image)
image = uint8(image);

se1=strel('disk',25);
se2=strel('disk',7);

Morphed_mask = imclose(image,se1);
Morphed_mask = imopen(Morphed_mask,se2);
