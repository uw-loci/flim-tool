%Display A1 images

figure()
imagesc(A1{j});
colorbar('EastOutside');
title('A1');
suptitle(filenames{j});

