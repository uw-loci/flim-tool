%HISTOGRAM DISPLAY IN SUBPLOTS
figure()
title(filename);
subplot(321);hist(tau1vals{j}, 1000); title('tau1 distribution');
subplot(322);hist(tau2vals{j},1000);title('tau2 distribution');
subplot(323);hist(a1vals{j}, 1000); title('a1 distribution');
subplot(324);hist(a2vals{j},1000);title('a2 distribution');
subplot(325);hist(chivals{j},1000); title('Chi Squared distribution');
subplot(326);hist(intvals{j},1000);title('Intensity distribution');
suptitle(filename);