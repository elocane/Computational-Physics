function MNt=reaction3DbA(n,x,y,z,ts,sim)
%This programm simulates vicious walkers in 3D space. Reaction:
%A+A-->A
%input:     number of particles             n
%           units in x direction            x
%           units in y direction            y
%           units in z direction            z
%           number of timesteps taken       ts
%           number of simulation runs       sim
%output:    development of number of particles: MNt
tic;%start clock
for j=1:sim %go throgh each simulation
    l=zeros(x,y,z);%initializing the lattice
    
    %positioning of the n particles on the lattice randomly:
    M=x*y*z;%M is the total number of squares in space
    ntemp=n;%temporary numberstorage for n
    for s=1:z
        for t=1:y
            for u=1:x
                if rand<=(ntemp/M)%probability is calculated for every
                                  %square individually
                    l(u,t,s)=1;
                    ntemp=ntemp-1;
                end
                M=M-1;
            end
        end
    end
    
    Nt=zeros(1,ts+1);%storage for the number of survival particles with time
    Nt(1)=n;%first entry is always the initial number of particles: n
    
    for k=1:ts %running each simulation from t_1 to t_s (after that 
               %Nt(2)--Nt(ts+1) is filled up with numbers)
            
            %first step: Finding the index of the particles on the lattice
            clear lx;
            clear ly;
            clear lz;
            %in order to get no errors for small systems:
            lx(1)=0;
            lx=[lx(1:0)];
            c=0;%counter for number of survival particles
            for s=1:z
                for t=1:y
                    for u=1:x
                        if l(u,t,s)==1
                            c=c+1;
                %Here you can see a main idea of this program:
                %The Three vectors lx, ly and lz are used as a
                %'second lattice' for storing information about which
                %particles have been picked already
                %Notice that they work, in contrast to the 'main lattice'l,
                %like 'index-vectors'
                %Furthermore in the end of each timestep they do not
                %contain any elements any more
                            lx(c)=u;
                            ly(c)=t;
                            lz(c)=s;
                        end
                    end
                end
            end
            
            while length(lx)>=1 %main moving loop: moves all particles in
                                %delta t once.
                %Picking of a random particle (more precisely: its index 
                %in the indexvectors), which has not been picked
                %before (that is guaranteed by the fact that each particle will
                %be removed out of lx, ly and lz after having been
                %manipulated)
                J=1+floor(length(lx)*rand);
                
                %Picking moving direction randomly. Since there are six
                %directions in space, each of them is picked with
                %probability 1/6
                ok=0;
                while ok==0 %search for new direction until allowed
                            %direction is found
                    dx=0;
                    dy=0;
                    dz=0;
                    R=rand;
                    if R<=1/6
                        dx=-1;%move to the left in x direction
                    elseif R<=2/6 && R>1/6
                        dx=1;%move to the right in x direction
                    elseif R<=3/6 && R>2/6
                        dy=-1;%move to the left in y direction
                    elseif R<=4/6 && R>3/6
                        dy=1;%move to the right in y direction
                    elseif R<=5/6 && R>4/6
                        dz=-1;%move to the left in z direction
                    elseif R<=6/6 && R>5/6
                        dz=1;%move to the right in z direction
                    end
                    %Check if direction does not hurt boundary 
                    if (lz(J)+dz)>=1 && (lz(J)+dz)<=z
                        if (ly(J)+dy)>=1 &&(ly(J)+dy)<=y
                            if (lx(J)+dx)>=1 && (lx(J)+dx)<=x
                                ok=1;%direction is allowed -> quit
                                                             %while loop
                            end
                        end
                    end
                end
                
                %Check whether there will be a reaction
                %--> perform correspondant action
                if l(lx(J)+dx,ly(J)+dy,lz(J)+dz)==0 %if there is no
                                               %particle in the direction
                    l(lx(J)+dx,ly(J)+dy,lz(J)+dz)=1;%move in this direction
                    l(lx(J),ly(J),lz(J))=0;%and erase the old position from
                                           %the lattice
                    lx=[lx(1:(J-1)),lx((J+1):length(lx))];%removal of this
                                           %particle out of lx,ly and lz
                    ly=[ly(1:(J-1)),ly((J+1):length(ly))];
                    lz=[lz(1:(J-1)),lz((J+1):length(lz))];
                else %else: there must be a particle in that direction
                     %->remove bouncing particle from lattice l:
                    l(lx(J),ly(J),lz(J))=0;
                    lx=[lx(1:(J-1)),lx((J+1):length(lx))];%removal of the 
                                                    %particle who bounces
                    ly=[ly(1:(J-1)),ly((J+1):length(ly))];
                    lz=[lz(1:(J-1)),lz((J+1):length(lz))];
                    c=c-1;%decrease counter variable by one
                end
         
            end

        Nt(k+1)=c;%store total number on particles left after delta t
    end
    


    if j==1 %first simulation creates the outputvector MNt
        MNt=Nt;
    else
        MNt=MNt+Nt;%any other simulations add their result to MNt
    end

   
end
MNt=MNt/sim;%to get the average value, everything is then
            %divided by the number of simulations ran
toc;%get time needed for the whole program
end
