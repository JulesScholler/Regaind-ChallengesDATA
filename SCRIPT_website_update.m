% Load the SVM
load('SVM_model.mat', 'SVM_model')

% Assemble the data
data_test = [meta_test basic_qual_test sharpness_test ...
    compositional_test sym_test circ_test spectral_saliency_test ...
    discol_test glcm_test lvldet_test order_test blur_test];

% Predict scores
predict_test = predict(SVM_model,data_test);

% Assemble Export data
data_csv = [(10001:13000)' predict_test];

% Print the header
filename = ['test-' datestr(now,'yyyy-mm-dd-HH-MM-SS') '.csv'];
fID = fopen(filename, 'w');
fprintf(fID, 'ID;TARGET\n');
fclose(fID);

% Print the data
dlmwrite(filename,data_csv,'delimiter',';','-append')

