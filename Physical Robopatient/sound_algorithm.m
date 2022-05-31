% display 2D human face based on the palpation force and the position
% only datapoints 1, 25 and 50 are considered as more data points will
% slow down the program. Therefore, the 2D human face updates at every 100ms.



%flag_test = 0;
%generate pain sounds



for h= 1:1:200
vocal_pain(h) = y_pain(round(x(h,1))+ 1)*total_force_after_calibration(h,1);
if (flag_test == 0)
if (h >=30)
if (vocal_pain(h-10)-vocal_pain(h-20))>0 && (vocal_pain(h)-vocal_pain(h-10))< 0 && (vocal_pain(h) < vocal_pain(h-10))
flag_test = 1;
end
end
end
end



if (flag_test == 1)
if max(vocal_pain) > 20 && max(vocal_pain) <= 50
sound(s_1/10, Fs_1*0.7);
flag_test = 2;
end

if max(vocal_pain) > 50 && max(vocal_pain) <= 80
sound(s_1/5, Fs_1*1.0);
flag_test = 2;
end
if max(vocal_pain) > 80
sound(s_1, Fs_1*1.4);
flag_test = 2;

end
wait time (0.05 second);
end