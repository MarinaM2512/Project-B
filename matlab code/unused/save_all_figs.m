FolderName = "../screenshots/results";   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
figNames = get_all_meas_names("17_04","FILTERED_INIT", 1); 
figNames = cellfun(@(x) strcat(x,".fig"),figNames,'UniformOutput',false);
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = figNames{iFig};
  savefig(FigHandle, fullfile(FolderName, FigName));
end