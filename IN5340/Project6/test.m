[x,fs] = audioread("../notch1-a.wav");
M = 32;
d = [x(M+1:end);zeros(M,1)];

[A,E] = lms(x,d,0.25,5);