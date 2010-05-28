%Display fret efficiency images

% FRET Efficiency 
efficiency_im{j} = 1 - Tau2{j}./Tau1{j};

figure()
colormap('hot');
imagesc(efficiency_im{j});
colorbar('EastOutside');
title('FRET EFFICIENCY');
suptitle(filenames{j});

