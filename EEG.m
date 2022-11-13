datapath='...\os_ss';
savepath= '...\os_ss';

sub={'sub06'};% input the IDs of parti
len_sub=length(sub);

filename = 'savenrej'; 
full_filename=[filename, '.txt']; 
fid = fopen(full_filename,'w');   


for i=1:len_sub
    
    EEG.etc.eeglabvers = '2019.0'; % this tracks which version of EEGLAB is being used, you may ignore it
    EEG = pop_loadbv([fullfile(datapath,sub{i})], 'run1_1.vhdr');
    EEG.setname = strcat(sub{i},'_1_1');
    EEG = eeg_checkset( EEG );
    EEG = pop_editset(EEG, 'subject', sub{i}, 'condition', 'os', 'group', '2');
    EEG = eeg_checkset( EEG );
    EEG=pop_chanedit(EEG, 'lookup','D:\apps\matlab\toolbox\eeglab2019_0\plugins\dipfit\standard_BESA\standard-10-5-cap385.elp','append',1,'changefield',{2 'labels' 'FCz'},'lookup', ...
    'D:\apps\matlab\toolbox\eeglab2019_0\plugins\dipfit\standard_BESA\standard-10-5-cap385.elp');
    EEG = eeg_checkset( EEG );
    EEG = pop_reref( EEG, [22 54] ,'refloc',struct('labels',{'FCz'},'type',{''},'theta',{0},'radius',{0.12662},'X',{32.9279},'Y',{0},'Z',{78.363},'sph_theta',{0},'sph_phi',{67.208},'sph_radius',{85},'urchan',{2},'ref',{''},'datachan',{0}),'keepref','on');
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfiltnew(EEG, 'locutoff',1);
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfiltnew(EEG, 'hicutoff',30);
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, {'S1291'  'S1292'  'S1293'  'S1294'  'S1295'  'S1296'  'S1297'}, ...
    [-1.5         1.5], 'newname', strcat(sub{i},'_1_1 epochs'), 'epochinfo', 'yes');
    EEG = eeg_checkset( EEG );
    EEG = pop_rmbase( EEG, [-300 0] ,[]);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat(sub{i},'_ss1'),'filepath', fullfile(savepath,'1.before rejected by probality\'));
    EEG = eeg_checkset( EEG );
	
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [EEG,A,B,nrej]= pop_jointprob(EEG,1,[1:31 33:62 64] ,3.5,3.5,0,1,0,[],0);%output nrej
	nrej
	fprintf(fid,'%d\t%f\n',i,nrej); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
    EEG = eeg_checkset( EEG );
    EEG = pop_resample( EEG, 250);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat(sub{i},'_ss1'),'filepath', fullfile(savepath,'2.before ica\'));
    EEG = eeg_checkset( EEG );
    EEG = eeg_checkset( EEG );
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on','pca',63);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat(sub{i},'_ss1'),'filepath', fullfile(savepath,'3.after ica\'));
    EEG = eeg_checkset( EEG );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 fclose(fid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%