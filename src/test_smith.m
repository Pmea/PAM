%acc_cost=f_smith_waterman('salut', 'salsut', -3,-4);
%acc_cost=f_smith_waterman('FATCATY', 'CATFAST', -3,-4); %

acc_cost =f_smith_waterman( 'AGCACACA','ACACACTA', -1,-4);  %english wiki
imagesc(acc_cost);