%CREATE TEMPLATES 
%Alphabets
A=imread('d:\Number Plate Detection\Alpha\A.bmp');B=imread('d:\Number Plate Detection\Alpha\B.bmp');C=imread('d:\Number Plate Detection\Alpha\C.bmp');
D=imread('d:\Number Plate Detection\Alpha\D.bmp');E=imread('d:\Number Plate Detection\Alpha\E.bmp');F=imread('d:\Number Plate Detection\Alpha\F.bmp');
G=imread('d:\Number Plate Detection\Alpha\G.bmp');H=imread('d:\Number Plate Detection\Alpha\H.bmp');I=imread('d:\Number Plate Detection\Alpha\I.bmp');
J=imread('d:\Number Plate Detection\Alpha\J.bmp');K=imread('d:\Number Plate Detection\Alpha\K.bmp');L=imread('d:\Number Plate Detection\Alpha\L.bmp');
M=imread('d:\Number Plate Detection\Alpha\M.bmp');N=imread('d:\Number Plate Detection\Alpha\N.bmp');O=imread('d:\Number Plate Detection\Alpha\O.bmp');
P=imread('d:\Number Plate Detection\Alpha\P.bmp');Q=imread('d:\Number Plate Detection\Alpha\Q.bmp');R=imread('d:\Number Plate Detection\Alpha\R.bmp');
S=imread('d:\Number Plate Detection\Alpha\S.bmp');T=imread('d:\Number Plate Detection\Alpha\T.bmp');U=imread('d:\Number Plate Detection\Alpha\U.bmp');
V=imread('d:\Number Plate Detection\Alpha\V.bmp');W=imread('d:\Number Plate Detection\Alpha\W.bmp');X=imread('d:\Number Plate Detection\Alpha\X.bmp');
Y=imread('d:\Number Plate Detection\Alpha\Y.bmp');Z=imread('d:\Number Plate Detection\Alpha\Z.bmp');

%Natural Numbers
one=imread('d:\Number Plate Detection\Alpha\1.bmp');two=imread('d:\Number Plate Detection\Alpha\2.bmp');
three=imread('d:\Number Plate Detection\Alpha\3.bmp');four=imread('d:\Number Plate Detection\Alpha\4.bmp');
five=imread('d:\Number Plate Detection\Alpha\5.bmp'); six=imread('d:\Number Plate Detection\Alpha\6.bmp');
seven=imread('d:\Number Plate Detection\Alpha\7.bmp');eight=imread('d:\Number Plate Detection\Alpha\8.bmp');
nine=imread('d:\Number Plate Detection\Alpha\9.bmp'); zero=imread('d:\Number Plate Detection\Alpha\0.bmp');

%Creating Array for Alphabets
letter=[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z];
%Creating Array for Numbers
number=[one two three four five six seven eight nine zero];

NewTemplates=[letter number];
save ('NewTemplates','NewTemplates')
clear all