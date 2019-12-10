files = dir('*.mat');

feat_vec=zeros([170 4 2000]);
for i = 1:170
    load(files(i).name);
    filename = files(i).name;
    disp(filename)
    
    use_data = zeros([1 1 30000]);
    use_data(1,1,1:length(remove_nan(sF1)))= ...
        permute(remove_nan(sF1),[3,2,1]);
    feat_vec(i,1,:) = use_data(1,1,1:10:20000);
    
    use_data = zeros([1 1 30000]);
    use_data(1,1,1:length(remove_nan(sF2))) = ...
        permute(remove_nan(sF2),[3,2,1]);
    feat_vec(i,2,:) = use_data(1,1,1:10:20000);
    
    use_data = zeros([1 1 30000]);
    use_data(1,1,1:length(remove_nan(sF3))) = ...
        permute(remove_nan(sF3),[3,2,1]);
    feat_vec(i,3,:) = use_data(1,1,1:10:20000);
    
    use_data = zeros([1 1 30000]);
    use_data(1,1,1:length(remove_nan(sF4))) = ...
        permute(remove_nan(sF4),[3,2,1]);
    feat_vec(i,4,:) = use_data(1,1,1:10:20000);
end
feat_vec = permute(feat_vec,[3 2 1]); %turns sig,feat,t into t,feat,sig
%To save the variable from console, type 'save feat_vec_rnn.mat feat_vec'
%otherwise uncomment line 31
%save('feat_vec_rnn.test','feat_vec');

function output = remove_nan(input)
output=input(~isnan(input));
end
