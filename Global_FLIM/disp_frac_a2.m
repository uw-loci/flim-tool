%Display fractional efficiency 
A2_frac{j} = A2{j}./(A1{j} +A2{j});

figure()
imagesc(A2_frac{j});
colorbar('EastOutside');
title('Fractional Contribution of A2 (short LT)');
suptitle(filenames{j});

