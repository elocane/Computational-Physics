#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "defin.h"
#include "pivot.h"
#include "count_contacts.h"

int main()
{
    int i,j,p,q;
    double epsilon;

    en=fopen("energies.dat","w");
    dist=fopen("distances.dat","w");

    time(&t);
    srand((unsigned int)t);  //seed the random number generator

    for(i=0; i<L; i++)
    {
        for(j=0; j<L; j++){
            occ[i][j]=0;
        }
    }
    for(i = 0; i < N; i++)
    {
    x[i] = N+i;
    y[i] = N+1;
    occ[N+i][N+1]=i+1;
    }

    //print initial occ matrix
	  for(i=L-1; i>=0; i--)
	   {
	     for (j=0; j<L; j++) {
	       printf("%d", occ[j][i]);
	     }
	     printf("\n");
	   }


    beta=1/T;
    epsilon=0.001;
    while (beta<37) {
    	p=pivot(beta); //later maybe while (p!=1)
    	printf("Das Ereignis: Der Rückgabewert von pivot ist=%d\n",p);
    	if (p==1) {
    		  for(i=L-1; i>=0; i--)
    		   {
    		     for (j=0; j<L; j++) {
    		       printf("%d", occ[j][i]);
    		     }
    		     printf("\n");
    		   }

    	}
    	printf("beta%f\n",beta);
    	beta=beta/(1-epsilon);
    }

	fclose(en);
    fclose(dist);


    //storing the final configuration in a data file
    conf=fopen("configuration.dat","w");
    for (i=0;i<N;i++)
    {
        fprintf(conf,"%d\t%d\n",x[i],y[i]); //two columns, first with x coordinates, second with y coordinates
    }
    fclose(conf);


    return 0;
}

