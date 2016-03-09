clear;
clc;
%a = 1:64;
%vec2mat(a, 16)

%c1 = 2;
%c = c1:16:64

startA = eye(16);

aa1 = ones(1, 4);
Oa = zeros(1, 4);
Ob = zeros(1, 16);
A1 = kron(startA, aa1);

O3 = zeros(1, 3);
ab3 = [1 O3 1 O3 1 O3 1];

ac1 = [1 zeros(1,15)];
ac2 = [ac1 ac1 ac1 1];

ad = [1 0 0 0 1 zeros(1, 11) 1 0 0 0 1];
Oda = zeros(4, 8);
Odb = zeros(4, 16);

A2sub = zeros(4, 16);
A4sub = A2sub;
for i = 1:4
    A2sub(i, i:(12+i)) = ab3;
    A4sub(i, i:(20+i)) = ad;
end
starta = eye(4);
A2 = kron(starta, A2sub);

A4 = [A4sub zeros(4,40);
    zeros(4, 8) A4sub zeros(4, 32);
    zeros(4, 32) A4sub zeros(4, 8);
    zeros(4, 40) A4sub];

A3 = zeros(16,64);
for i = 1:16
    A3(i, i:(48+i)) = ac2;
end
A5 = zeros(4, 64);
A5(1, 17) = 1;
A5(2, 27) = 1;
A5(3, 52) = 1;
A5(4, 62) = 1;

A = [A1; A2; A3; A4; A5];
b = ones(68, 1);
c = -ones(64, 1);

Astandard = [A; -A];
bstandard = [b; -b];
cstandard = c;

%This should be correct
dualA = -Astandard';
[m, n] =  size(dualA);
dualAslack = [dualA eye(64)];
dualb = -cstandard; %Här är det viktigt att dualb >= 0 för alla element
%Annars hade det inte varit okej att införa slack-variabler som vi har
%gjort

if (min(dualb)<0)
    error('dualb har element < 0')
end
dualc = -[bstandard; zeros(64,1)]; %Så att vi maximerar i stället för minimerar



basicvars = (n+1):(n+m);
size(dualAslack);
size(dualb);
size(dualc);
[tableau,basicvars,steps]=simp(dualAslack,dualb,dualc,basicvars);
[tableau,xb,basic,feasible,optimal]=checkbasic1(dualAslack,dualb,dualc,basicvars);
disp('WIN')

%ac1 = [1 0 0 0 Oa Oa Oa]
%ac2 = [ac1 ac1 ac1 1]


%A3 = [ac2 0 0 0 Oa Oa Oa]