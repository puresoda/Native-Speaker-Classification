files = dir('*.wav');
formant = 1;
feat_vec = zeros([1103 1000 170]);
for i = 1:length(files)
    filename = files(i).name;
    [y, Fs] = audioread(filename);
    energy = sum(abs(y).^2);
    average_energy = energy/length(y);

    threshold = .5;
    cutoff_energy = (1+threshold)*average_energy;
    %windowed energy
    overlap_percentage = 50;
    Nw = 1103;
    start = 1;
    stop = start+Nw-1;
    while stop <= length(y)
        windowed_signal = y(start:stop);
        average_window_energy = sum(abs(windowed_signal).^2)/Nw;
        if average_window_energy >= cutoff_energy
             feat_vec(:,formant,i) =windowed_signal.';
             formant = formant + 1;
        end
        start = start + (Nw-1)/(100/overlap_percentage);
        stop = start+Nw-1;

    end
    formant = 1;
end