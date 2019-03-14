function ym=RungeKutta2(y0,h,b)
B1=0;                   %coefficient in the drag force
g=9.81;                 %acceleration due to gravity
C=0.47;                 %drag coefficient for a sphere
rho=1.2;                %density of air
A=0.038;                %frontal area of the ball
B2=0.5*C*rho*A;         %coefficient in the drag force
m=0.43;              %mass of the ball

a=1-b;                  %coefficients in the
m=1/(2*b);                  %Runge-Kutta method

ym=y0;              %initialize the result matrix
yi=y0;              %initialize the temporary result matrix
f1=@(y) y(2);       %first row of the system matrix
f2=@(y) -B1*y(2)/m-B2*y(2)*sqrt(y(2)^2+y(4)^2)/m;   %second row of syst.m.
f3=@(y) y(4);                                       %third row of syst.m.
f4=@(y) -g-B1*y(4)/m-B2*y(4)*sqrt(y(2)^2+y(4)^2)/m; %fourth row of syst.m.

while yi(3)>=0               %keep calculating till ball hits ground
    i=size(ym,2);            %determine number of columns in ym
    ki(1,1)=h*f1(ym(:,i));   %vectors in the RK method
    ki(2,1)=h*f2(ym(:,i));      
    ki(3,1)=h*f3(ym(:,i));          
    ki(4,1)=h*f4(ym(:,i));
   
    yi(1)=ym(1,i)+a*ki(1)+b*h*f1(ym(:,i)+m*ki); %obtain new column
    yi(2)=ym(2,i)+a*ki(2)+b*h*f2(ym(:,i)+m*ki);
    yi(3)=ym(3,i)+a*ki(3)+b*h*f3(ym(:,i)+m*ki);
    yi(4)=ym(4,i)+a*ki(4)+b*h*f4(ym(:,i)+m*ki);
    
    ym(:,i+1)=yi; %update the result matrix with the new column
end
end
