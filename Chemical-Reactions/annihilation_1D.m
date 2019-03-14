function MNt=reaction1D(n,V,ts,sim)% 1D A+A-->0
tic;
for j=1:sim %number of simulations to run
    l=zeros(1,V);%Initializing the lattice
    
    %Positioning of the n particles on the lattice:
    M=V;
    ntemp=n;
    for i=1:V
        if rand<=(ntemp/M)
            l(i)=1;
            ntemp=ntemp-1;
        end
        M=M-1;
    end

    Nt=zeros(1,ts+1);
    Nt(1)=n;
    
    for k=1:ts %running each simulation from t_1 to t_s
        %after that Nt(2)--Nt(ts+1) is filled with a number
    
            %finding the index of the particles on the lattice
            clear l2;
            z=0;%counter for number of particles left
            for i=1:V
                if l(i)==1
                    z=z+1;
                    l2(z)=i;
                end
            end
            
            while length(l2)>=1
                  %Picking of a random particle, which has not
                  %been picked before
                J=1+floor(length(l2)*rand);
                
                %Choose moving direction
                if rand<0.5
                    d=-1;%move to the left
                else
                    d=1;%move to the right
                end
                %Check if direction hurts boundary
                if (l2(J)+d)<1 || (l2(J)+d)>V
                    %particle would hurt boundary-->change direction
                    d=d*(-1);
                end
                
                %Check --> perform correspondent action
                if l(l2(J)+d)==0 %if there is no particle in the direction
                    %move and put a 2 on the lattice
                    l(l2(J)+d)=1;
                    l(l2(J))=0;
                    l2=[l2(1:(J-1)),l2((J+1):length(l2))];
                    
                else %there is a particle in that direction->remove both
                    l(l2(J)+d)=0;
                    l(l2(J))=0;
                    z=z-2;
                    if d==1 %other particle to the right
                        l2=[l2(1:(J-1)),l2((J+2):length(l2))];
                    else
                        l2=[l2(1:(J-2)),l2((J+1):length(l2))];
                    end
                end
            end

        Nt(k+1)=z;
        
        if z==0
            break;
        end
    end
    


    if j==1 %first simulation
        
        MNt=Nt;
    else
        MNt=MNt+Nt;
    end

   
end
MNt=MNt/sim;
toc;
end
