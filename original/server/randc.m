%RandStream.setDefaultStream ...
%     (RandStream('mt19937ar','seed',sum(100*clock)));
%v=rand(1);
startup 
filename='./upload/test.jpg';
img=imread(filename);
[v,c]=coin_counter(img);
fid = fopen('./output/result1.txt','w');

fprintf(fid,'%1.4f',v);
fclose(fid);
