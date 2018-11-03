function dispgrayimage(z);
ngr = 16;
maxz = abs(max(z(:)));
if (maxz > 0),
   z = 16*z/maxz;
end;
image(z);colormap(gray(ngr));
axis('image');axis off;
