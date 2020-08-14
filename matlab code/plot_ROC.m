function plot_ROC (TPR_vec, FPR_vec, TNR_vec, PPV_vec, t2_vec,th1_vec,th2_vec,th3_vec)
figure;
s = scatter(FPR_vec,TPR_vec);
s.DataTipTemplate.DataTipRows(1).Label = 'FPR';
s.DataTipTemplate.DataTipRows(2).Label = 'TPR'; 
s.DataTipTemplate.DataTipRows(3) = dataTipTextRow('th1',th1_vec);
s.DataTipTemplate.DataTipRows(4) = dataTipTextRow('th2',th2_vec);
s.DataTipTemplate.DataTipRows(5) = dataTipTextRow('time th',t2_vec);
s.DataTipTemplate.DataTipRows(6) = dataTipTextRow('th3',th3_vec);
s.DataTipTemplate.DataTipRows(7) = dataTipTextRow('TNR',TNR_vec);
s.DataTipTemplate.DataTipRows(8) = dataTipTextRow('PPV',PPV_vec);
title("ROC scatter");
xlabel("FPR");
ylabel("TPR");