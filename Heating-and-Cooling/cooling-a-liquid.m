tic
n=50; %use even numbers only
n2=n*n;

%boundary, starting temperature and temperature of cooling device
boundarytemp=24;
starttemp=4;
cooldevtemp=0;
%last enjoyable drinking temperature as threshold:
enjoy=10;

%setting the inital temperature
u0=starttemp*ones(1,n2);

%setting the boundary conditions
u0(1:n)=boundarytemp;
u0((n+1):n:n2)=boundarytemp;
u0((2*n):n:n2)=boundarytemp;
u0((n2-n+1):n2)=boundarytemp;
u0((n/2-1)*n+n/2)=cooldevtemp;
u0((n/2-1)*n+n/2+1)=cooldevtemp;
u0((n/2)*n+n/2)=cooldevtemp;
u0((n/2)*n+n/2+1)=cooldevtemp;

a=100/n; %step in space, unit: milimeters squared
h=a^2/4; %time step, unit: seconds
alpha=0.14; %thermal diffusivity, unit: is mm squared per second
vi=ones(1,n2-1);
vo=ones(1,n2-n);
A=diag(vo,-n)+diag(vi,-1)-4*eye(n2)+diag(vi,1)+diag(vo,n);

%Putting to zero the rows in A that correspond to boundary fields
vz=zeros(1,n2);
for i=1:n
    A(i,:)=vz;
    A((i-1)*n+1,:)=vz;
    A(i*n,:)=vz;
    A((n2-n)+i,:)=vz;
end
%the same for the cooling device:
A((n/2-1)*n+n/2,:)=vz;
A((n/2-1)*n+n/2+1,:)=vz;
A((n/2)*n+n/2,:)=vz;
A((n/2)*n+n/2+1,:)=vz;

%multiplying by some constants
A=alpha/a^2*A;

%left factor (with inverse operation) - like a part of an implicit euler:
B=inv(eye(n2)-0.5*h*A);

%right factor - like a part of an explicit euler:
C=(eye(n2)+0.5*h*A);

%combine the two factors
D=B*C;

%and go for the trapezoidal rule for several times:
ut=u0;

%initial set of avtemp
avtemp=starttemp;

t=0; %relative time
while avtemp<enjoy
    t=t+1;
    ut=transpose(D*transpose(ut));
    
    avtemp=(sum(ut)-(2*n+2*(n-2))*boundarytemp-4*cooldevtemp)/(n2-(2*n+2*(n-1))-4);

    
    for i=1:n
        for j=1:n
            Q(i,j)=ut((i-1)*n+j);
        end
    end
    
end
toc

Q %temperature distribution matrix
t=t*h/60 %amount of time in minutes that you have for enjoying your drink
