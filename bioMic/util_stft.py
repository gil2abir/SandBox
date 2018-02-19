import numpy as np
import math

def util_stft(data, fs, fft_size, overlap):
    # sig = util_stft(data, fs, fft_size, overlap)
    # Input:
    # data = a numpy array containing the signal to be processed
    # fs = a scalar which is the sampling frequency of the data
    # fft_size = number of samples in the fast fourier transform (pow(2)). Keep in mind the time-freq bin resolution
    #            tradeoff.
    # overlap = percentage of overlap window (Keep in mind spectral leakage. window-dependant)
    # Output:
    # sig = 2-D numpy array of the STFT results. with values ranging from -40 to our maximum value.  axes.shape[0] axis
    #       of the array represent frequency bins, and the axes.shape[1] represents the segment number that was
    #       processed to get the frequency data.
    fft_size = np.int32(math.floor(fft_size))
    hop_size = np.int32(np.floor(fft_size * (1 - overlap)))
    pad_end_size = fft_size  # the last segment can overlap the end of the data array by no more than one window size
    total_segments = np.int32(np.ceil(len(data) / np.float32(hop_size)))
    t_max = len(data) / np.float32(fs)

    window = np.hanning(fft_size)  # our half cosine window (this win will keep energy levels equal between time and
    #                                freq' domains
    inner_pad = np.zeros(fft_size)  # the zeros which will be used to double each segment size

    proc = np.concatenate((data, np.zeros(pad_end_size)))  # the data to process
    result = np.empty((total_segments, fft_size), dtype=np.float32)  # buffer to hold the result

    for i in xrange(total_segments):  # for each segment
        current_hop = hop_size * i  # figure out the current segment offset
        segment = proc[current_hop:current_hop + fft_size]  # get the current segment
        windowed = segment * window  # multiply by the half cosine function (window)
        padded = np.append(windowed, inner_pad)  # padd with 0s to double the length of the data
        spectrum = np.fft.fft(padded) / fft_size  # take the Fourier Transform and scale by the number of samples
        #                                           to constrain parsival theory
        autopower = np.abs(spectrum * np.conj(spectrum))  # find the autopower spectrum (suppress lower energy
        #                                                   components and emphasize higher energy frequencies.
        result[i, :] = autopower[:fft_size]  # append to the results array

    result = 20 * np.log10(result)  # scale to db #TODO - add user defined scale method (melscaled for speech \ db \
    #                                              TODO   dbV \ etc')
    result = np.clip(result, -40, 200)  # clip the spectogram. Assume that below -40db lives only gradient noise and
    #                                     numerical errors

    return result
