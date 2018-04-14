% Tyler Phillips
% phillity@umail.iu.edu
% February 12, 2018

%load('all_data_labels.mat')
%load('Y_dependent.mat')
%load('File_test.mat')
%% Bio-Inspired Feature Extraction

% G. Guo, Guowang Mu, Y. Fu and T. S. Huang, 
% "Human age estimation using bio-inspired features," 
% 2009 IEEE Conference on Computer Vision and Pattern Recognition, Miami, FL, 2009, pp. 112-119.

% http://ieeexplore.ieee.org/document/5206681/
%%'
%%
load('age estimation/File_train.mat')
load('age estimation/File_test.mat')

%%  mainn!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% load('Y_train_data.mat')

%%
disp('hello')
size = 100;
rotation = 8;
band = 4;
component = 25;
for m = 1:8
     
    size_str = num2str(size);
    base_train = 'data/trainAll/train_';
    base_test = 'data/test_';
    train_base_path = strcat(base_train,size_str);
    train_base_path1 = strcat(train_base_path,'/');
    test_base_path = strcat(base_test,size_str);
    test_base_path1 = strcat(test_base_path,'/');
    File_train = dir(train_base_path1);
    File_test = dir(test_base_path1);
    
    disp('done paths.')
    % Created matrix of dependent variables (1st column : age, 2nd column: gender (female:1,male:0))
    Y_train_Age_gender = zeros(length(File_train)-2,2);
    for k=1:length(File_train)-2
        FileNames = File_train(k+2).name ;
        Y_train_Age_gender(k,1) = str2num(FileNames(7:8));
        Y_train_Age_gender(k,2) = str2num(FileNames(2));
    end
    for i = 1:500
        disp('Done dependent variable.')
    end
    %Independent data
    n = length(File_train)-2;

    Y_return = bif(strcat(train_base_path1,File_train(3).name), band, rotation);
    col = length(Y_return');
    
    %z contains [row: data point/image, column: BIF features]
    z = zeros(n,col);
    z(1,1:col) = Y_return';
    for i = 4:n+2
        % code to call bif for each image iteratively
        Y_return = bif(strcat(train_base_path1,File_train(i).name), band, rotation);
        col = length(Y_return');
        % concate each Y_return row wise in z
        z(i-2,1:col) = Y_return';
        % give this matrix z to PLS!!!
    end
    [XL,YL,XS,YS,BETA] = plsregress(z,Y_train_Age_gender,component);

    disp('Done independent variable.');
    %Prediction
    pred = zeros(length(File_test)-2,2);
    for i = 1:length(File_test)-2

        % code to call bif for each image iterativly
        Y_test = bif(strcat(test_base_path1,File_test(i+2).name), band, rotation);
        
        %predict age
        coeff1 = BETA(2:end,1);
        wTx1 = Y_test.*coeff1;
        wTxC1 = sum(wTx1) + BETA(1,1);
        pred(i,1) = wTxC1;
        
        %predict gender
        coeff2 = BETA(2:end,2);
        wTx2 = Y_test.*coeff2;
        wTxC2 = sum(wTx2) + BETA(1,2);
        if(wTxC2 < 0.5)
            pred(i,2) = 0;        
        else
            pred(i,2) = 1;
        end
        %[row,col] = size(Y_test');
        % concate each Y_return row wise in z
        %z_test(i,1:col) = Y_test';
        % give this matrix z to PLS!!!
    end
    disp('Done prediction.')
    %checking accuracy of omn 61 test images

    % getting age of testing images
    Y_test_Age = zeros(length(File_test)-2,1);
    for k=1:length(File_test)-2 
       FileAge = File_test(k+2).name;
       Y_test_Age(k,1) = str2num(FileAge(7:8));
    end
    
    % getting gender of testing images
    Y_test_gender = zeros(length(File_test)-2,1);
    for k=1:length(File_test)-2 
       FileGender = File_test(k+2).name;
       Y_test_gender(k,1) = str2num(FileGender(2));
    end
    
    disp('Done test dependent variable.')
    %%% MAE of our model

    disp('Done MAE.')
    MAE = (sum(abs(pred(1:end,1) - Y_test_Age)))/(length(File_test)-2);
    
   
    
    %confusion matrix for gender variable
    wrong = 0;
    for i=1:length(File_test)-2
        if(Y_test_gender(i,1) ~= pred(i,2))
            wrong = wrong + 1;
        end
    end
    
    gender_accuracy = 1 - (wrong/(length(File_test)-2));
    
    
    
    
    %saving
    store = 'z';
    store = strcat(store, size_str);
    store = strcat(store, '.mat')
    save(store,'z')
    
    prediction = 'pred';
    prediction = strcat(prediction, size_str);
    prediction = strcat(prediction, '.mat');
    save(prediction,'pred');
    
    accuracy = 'acc';
    accuracy = strcat(accuracy, size_str);
    accuracy = strcat(accuracy, '.mat');
    save(accuracy,'MAE');
   
    g_accuracy = 'gacc';
    g_accuracy = strcat(g_accuracy, size_str);
    g_accuracy = strcat(g_accuracy, '.mat');
    save(g_accuracy,'gender_accuracy');
    
    disp('Done saving.')
    
    size = size + 25;
    break;
end
    
    
    
    
    
    




% AgeMale = zeros(length(Files_male),2)
% for k=1:length(Files_male) 
%    FileNames = Files_male(k).name ;
%    AgeMale(k,1) = str2num(FileNames(7:8))
%    AgeMale(k,2) = 0
% end
%%

%READ THE FOLLOWING 

%our code will look like this

% n is no of images

%%

%%
%[XL,YL,XS,YS,BETA] = plsregress(z,Y_train_Age_gender(1:end,1),20);


%%

%% checking for one image

%Y_test = bif(strcat(base_path1,Files(218).name), 2, 3);
%% 



Y_train_Age_gender = zeros(length(File_train)-2,2);
for k=1:length(File_train)-2
    FileNames = File_train(k+2).name ;
    Y_train_Age_gender(k,1) = str2num(FileNames(7:8));
    Y_train_Age_gender(k,2) = str2num(FileNames(2));
end
%%

size_str = num2str(100);
base_train = 'data/trainAll/train_';
base_test = 'data/test_';
train_base_path = strcat(base_train,size_str);
train_base_path1 = strcat(train_base_path,'/');
test_base_path = strcat(base_test,size_str);
test_base_path1 = strcat(test_base_path,'/');
File_train = dir(train_base_path1);
File_test = dir(test_base_path1);
%%

[XL,YL,XS,YS,BETA] = plsregress(z,Y_train_Age_gender,25);
%%
pred = zeros(length(File_test)-2,2);
for i = 1:length(File_test)-2

    % code to call bif for each image iterativly
    Y_test = bif(strcat(test_base_path1,File_test(i+2).name), 8, 12);
    disp('hello')
    %predict age
    coeff1 = BETA(2:end,1);
    wTx1 = Y_test.*coeff1;
    wTxC1 = sum(wTx1) + BETA(1,1);
    pred(i,1) = wTxC1;

    %predict gender
    coeff2 = BETA(2:end,2);
    wTx2 = Y_test.*coeff2;
    wTxC2 = sum(wTx2) + BETA(1,2);
    if(wTxC2 < 0.5)
        pred(i,2) = 0;        
    else
        pred(i,2) = 1;
    end
    %[row,col] = size(Y_test');
    % concate each Y_return row wise in z
    %z_test(i,1:col) = Y_test';
    % give this matrix z to PLS!!!
end
disp('Done prediction.')