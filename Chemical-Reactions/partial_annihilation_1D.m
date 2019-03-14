function MNt=reaction1DbA(n,V,ts,sim)
%This programm simulates vicious walkers in 1D space. Reaction:
%A+A-->A
%input:     number of particles             n
%           size=length of lattice          V
%           number of timesteps taken       ts
%           number of simulation runs       sim
%output:    development of number of particles: MNt
tic;%start clock
for j=1:sim %go throgh each simulation
    l=zeros(1,V);%initializing the lattice
    
    %positioning of the n particles on the lattice randomly
    M=V;%M represents the total number of squares left
    ntemp=n;%temporary storage of the number of particles left
    for i=1:V
        if rand<=(ntemp/M)%probability is calculated for every
                          %square individually
            l(i)=1;
            ntemp=ntemp-1;
        end
        M=M-1;
    end

    Nt=zeros(1,ts+1);%storage for the number of survival particles with time
    Nt(1)=n;%first entry is always the initial number of particles: n
    
    for k=1:ts %running each simulation from t_1 to t_s (after that 
               %Nt(2)--Nt(ts+1) is filled up with numbers)
    
            %finding the index of the particles on the lattice
            clear l2;
            z=0;%counter for number of survival particles
            for i=1:V
                if l(i)==1
                    z=z+1;
                    l2(z)=i;
                end
            end
            
            while length(l2)>=1%main moving loop: moves all particles in
                               %delta t once.
                %Picking of a random particle (more precisely: its index 
                %in the indexvector l2), which has not been picked
                %before (that is guaranteed by the fact that each particle will
                %be removed out of l2 after having been
                %manipulated)
                J=1+floor(length(l2)*rand);
                
                %Choose moving direction
                if rand<0.5
                    d=-1;%move to the left
                else
                    d=1;%move to the right
                end
                %Check if direction hurts boundary (falls ja *(-1)
                if (l2(J)+d)<1 || (l2(J)+d)>V
                    %particle would hurt boundary-->pick opposite direction
                    d=d*(-1);
                end
                
                %Check whether there will be a reaction
                %--> perform correspondant action
                if l(l2(J)+d)==0 %if there is no particle in the direction
                    l(l2(J)+d)=1;%move in this direction
                    l(l2(J))=0;%and erase the old position from the lattice
                    l2=[l2(1:(J-1)),l2((J+1):length(l2))];
                    
                else %there is a particle in that direction->remove bouncing particle
                    l(l2(J))=0;
                    l2=[l2(1:(J-1)),l2((J+1):length(l2))];%remove bouncing
                                                      %particle out of l2
                    z=z-1;%decrease counter variable by one
                end
            end

        Nt(k+1)=z;%store total number on particles left after delta t
        
        if z==0%any further calculations are not necassary for that simulation
            break;
        end
    end
    


    if j==1%first simulation creates the outputvector MNt
        MNt=Nt;
    else
        MNt=MNt+Nt;%any other simulations add their result to MNt
    end

   
end
MNt=MNt/sim;%to get the average value, everything is then
            %divided by the number of simulations ran
toc;%get time needed for the whole program
end
