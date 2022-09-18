function []= tapa_physio_write2bids(ons_secs, write_bids, save_dir, log_files)
% Converts trigger, cardiac and respiratory data from physio structure into
% a .tsv file according to BIDS format, with meta data in a corresponding json file.


% IN: ons_secs:     onsecs structure
%     write_bids:   parameter describing the stage of the processing pipeline
%                   at which the files are being written
%    save_dir: where the file should be written to
        

% OUT: tsv file(s) caridac, respiratory, trigger
%      json file with meta data

% REFERENCES:
% https://bids-specification.readthedocs.io/en/stable/04-modality-specific
% -files/06-physiological-and-other-continuous-recordings.html

% Author: Johanna Bayer 2022



% after step1
switch write_bids
    case 1 
        tag = "loc1"
        cardiac = ons_secs.c;
        respiratory = ons_secs.r;

        s = struct("StartTime", log_files.relative_start_acquisition , ...
        "SamplingFrequency",log_files.sampling_interval, "Columns", ["cardiac", "respiratory"]); 

        % create JSON file
        JSONFILE_name= sprintf('%s_JSON.json',tag); 
        fid = fopen(fullfile(save_bids_dir,JSONFILE_name),'w'); 
        encodedJSON = jsonencode(s); 
        % write output
        fprintf(fid, encodedJSON); 
        writematrix(cardiac,fullfile(save_dir,'cardiac.txt'),'Delimiter','tab')
        writematrix(respiratory,fullfile(save_dir,'respiratory.txt'),'Delimiter','tab')
       
 
    case 2
        tag = "normalized"
        cardiac = ons_secs.c;
        respiratory = ons_secs.r;

        s = struct("StartTime", log_files.relative_start_acquisition , ...
        "SamplingFrequency",log_files.sampling_interval, "Columns", ["cardiac", "respiratory"]); 

        % create JSON file
        JSONFILE_name= sprintf('%s_%s_JSON.json',tag); 
        fid = fopen(fullfile(save_dir,JSONFILE_name),'w'); 
        encodedJSON = jsonencode(s); 
        % write output
        fprintf(fid, encodedJSON);

        writematrix(cardiac,fullfile(save_dir,'cardiac.txt'),'Delimiter','tab')
        writematrix(respiratory,fullfile(save_dir,'respiratory.txt'),'Delimiter','tab')
   

    case 3
        tag = "trigger"
        % triggerafter step 2
        cardiac = ons_secs.c;
        respiratory = ons_secs.r;
    
        trigger= ons_secs.svolpulse;
    
        % triggers have to be replaced into 1 (trigger) 0 (no trigger)
    
        trigger_binary=zeros(numel(ons_secs.t),1);

        for iVolume = 1:numel(ons_secs.svolpulse)
            row_number = ons_secs.svolpulse(iVolume)==ons_secs.t;
            trigger_binary(row_number)=1;
        end
        
        % prepare structure to write into BIDS
        s = struct("StartTime", log_files.relative_start_acquisition , ...
            "SamplingFrequency",log_files.sampling_interval, "Columns", ["cardiac", "respiratory", "trigger"]); 
        
        % create JSON file
        JSONFILE_name= sprintf('%s_%s_JSON.json',tag); 
        fid=fopen(fullfile(save_dir,JSONFILE_name),'w'); 
        encodedJSON = jsonencode(s); 
        % write output
        fprintf(fid, encodedJSON); 
        
        % write output
        writematrix(cardiac,fullfile(save_dir,'cardiac.txt'),'Delimiter','tab')
        writematrix(respiratory,fullfile(save_dir,'respiratory.txt'),'Delimiter','tab')
        writematrix(trigger_binary,fullfile(save_dir,'trigger_binary.txt'),'Delimiter','tab')

end