//variable definition
a = 1;

//complex variable definition
a=2+%i;
b = -5 -3*%i;

//boolean expression
disp(a == 1)

//vector definition
v= [1 2 3 4 5]
//or
v=1:5

//matrix definition
A = [2 2 4
     0 0 0
     5 9 -1]
     
B = zeros(A); //create a matrix B with A's dimension.

b = 5;

A = [a+b %pi 3 //matrix created of already defined variables
    b^2 0 atan(a)
    5 sin(b) -1]
    
B = zeros(A); //matrix of zeros with A's dimension
//output: B = [0 0 0; 0 0 0; 0 0 0]

B = zeros(2,3); //create a matriz B with dimension 2x3
//output: B = [0 0 0; 0 0 0]

C = ones(2,3); //create a matrix C with ones, dimension 2x3
//output: B = [1 1 1; 1 1 1]

D = diag(1:5); // create a diagonal matrix with the main diagonal element 1:5
//output: B = [1 0 0 0 0; 0 2 0 0 0; 0 0 3 0 0; 0 0 0 4 0; 0 0 0 0 5]

A = diag(ones(1,3)); // identity matrix
//output: B = [1 0 0; 0 0 1; 0 0 1]

//sum of 2 matrix
B = A + A

C = B+1; // sum one to all elements of B

//dot multiplication
C=A*B

//multiplication element by element
C=A.*B

// row and column extraction
row = A(2,:);
column = A(:,2);
lastrow = A($,:);

t= trace(A) //trace of a matrix

p = rank(A)// rank of a matrix -> number of rows/columns independents

//Transpose os A
B = A'

//inverse of B
InvB = inv(B) 

// determinant of A
d = det(A)

v=[0 -1]
p1=poly(v,'x')
p2=poly([1 2 1], 'z', 'coeff')
p1=poly(v,'s')
p2=poly([5 2 1], 's', 'coeff')
f=p1/p2
a=coeff(p2)
p=roots(p1)
[v,d]=spec(A)

//Functions:

//define a function

deff('[y]=teste(x)','if x<0 then y=-(x^2),else y=sin(x),end')

//f(0.5*pi)

y=teste(0.5*%pi)

//with vector

deff('[y]=h(x)','n=length(x);for i=1:n, if x(i)<0 then y(i)=2, else y(i)=1+(x(i)-1)^2, end,end');

//plot between -4 and 4

x=-4:0.5:4;

y=h(x);

//Plot

plot2d(x,y)

//create new windown

set("current_figure",1)

//Plot with mark

plot2d(x,y,-3)

set("current_figure",2)

//mark size

xset("mark size",4)
plot2d(x,y,-3)

Função Teste

function [y]=teste(x)
y=x+x^2+sin(x*2*%pi);
endfunction
  
teste(0.5*%pi) = 3.6078962
Segunda função teste

deff('[y]=test0(x)','y=x+x^2+sin(x*2*%pi)')
deff('[y]=test1(x)','y=-x+x^2+x^3')
deff('[y]=test2(x)','y=sqrt(x)')
x=-2:0.5:3;
a=1;
b=0;
t1=(a==1);
t2=(b>0.5);
if and([t1 t2]) then
 y=test0(x);
 elseif or([t1 t2]) then
 y=test1(x);
 else
 y=test2(x);
end,
plot2d(x,y,-3)
set("current_figure",1)
xset('mark size', 2)
plot2d(x,y,-3)
set("current_figure",2)
xset('mark size', 4)
plot2d(x,y,-3)
set("current_figure",3)
xset('mark size', 5)
plot2d(x,y,-3)