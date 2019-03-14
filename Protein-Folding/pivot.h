
#ifndef PIVOT_H_
#define PIVOT_H_

#include "count_contacts.h"

int pivot(double beta0)
{
  int xf[N], yf[N];
  int occ_old[L][L];
  int i, j, k, symm_op, tmp, ret;
  int nhh2, nhh3;
  double r;


  //Generate new conformation

  k=rand()%(N-1);  // Random point to pivot around
  printf("k=%d\n",k);
  symm_op=rand()%7;    // Type of pivot move (randomly selected)
  printf("symm_op=%d\n",symm_op);

  // Calculate coordinates relative to pivot point
  for(i = k + 1; i < N; i++) // i++ -> i=i+1
  {
    xf[i] = x[i] - x[k];
    yf[i] = y[i] - y[k];
  }

  switch(symm_op)
  {
  case 0:  // Rotate 90 degrees
    for(i = k + 1; i < N; i++)
    {
      tmp = xf[i];
      xf[i] = -yf[i];
      yf[i] = tmp;
    }
    break;
  case 1:  // Rotate -90 degrees
    for(i = k + 1; i < N; i++)
    {
      tmp = xf[i];
      xf[i] = yf[i];
      yf[i] = -tmp;
    }
    break;
  case 2:  // Rotate 180 degrees
    for(i = k + 1; i < N; i++)
    {
      xf[i] = -xf[i];
      yf[i] = -yf[i];
    }
    break;
  case 3:  // Mirror (1,0)
    for(i = k + 1; i < N; i++)
    {
      yf[i] = -yf[i];
    }
    break;
  case 4:  // Mirror (0,1)
    for(i = k + 1; i < N; i++)
    {
      xf[i] = -xf[i];
    }
    break;
  case 5:  // Mirror (1,1)
    for(i = k + 1; i < N; i++)
    {
      tmp = xf[i];
      xf[i] = yf[i];
      yf[i] = tmp;
    }
    break;
  case 6:  // Mirror (1,-1)
    for(i = k + 1; i < N; i++)
    {
      tmp = xf[i];
      xf[i] = -yf[i];
      yf[i] = -tmp;
    }
    break;
  }

  // Move the origin back
  for(i = k + 1; i < N; i++)
  {
    xf[i] += x[k]; // xf[i] = xf[i] + x[k];
    yf[i] += y[k];
  }
  for(i = 0; i <= k; i++)
  {
    xf[i] = x[i];
    yf[i] = y[i];
  }

  nhh2=count_contacts(x,y);//to have the old occ available


  //Store current state energy in a file
  fprintf(en,"%f\t%d\n",1/beta,-nhh2); //the structure goes like this: two columns,
                                                        //first being temperature, and second energy

  //Store current state end-to-end distance in a file
  fprintf(dist,"%f\t%f\n",1/beta,sqrt((x[N-1]-x[0])*(x[N-1]-x[0])+(y[N-1]-y[0])*(y[N-1]-y[0])));
  //the structure goes like this: two columns, first being temperature, and second end-to-end distace


  for (i=0;i<N;i++){
	  double tempo3=x[i];
	  double tempo4=y[i];
  printf("x=%f\n",tempo3);
  printf("y=%f\n",tempo4);
  }


  //save old occ
   for (i=0;i<L;i++) {
 	  for (j=0;j<L;j++) {
 		  occ_old[i][j]=occ[i][j];
 	  }
   }

ret=0;
  // New conformation ready - now check if it's a SAW
  for(i = k + 1; i < N; i++)
    occ[x[i]][y[i]] = 0;

  for(i = k + 1; i < N; i++)
  {
    if(occ[xf[i]][yf[i]] > 0)
    {
      for(j = k + 1; j < i; j++)
        occ[xf[j]][yf[j]] = 0;
      for(j = k + 1; j < N; j++)
        occ[x[j]][y[j]] = j + 1;
      return 0;
    }
    else {
      occ[xf[i]][yf[i]] = i+1;
      if (i==(N-1)) {
    	  ret=1;
      }
    }

  }

  // OK, it's a SAW. Accept or reject it?
  // METROPOLIS
  // METROPOLIS
  // METROPOLIS
  // Code for accepting the new state...
  // - updating the old into new state OR
  // - resetting the old

  if (ret==1) {
	printf("Start von if-Bed in pivot.h -----------------------------=%d\n",ret);

    //printf("nhh=%d\n",nhh);

    //printf("nhh=%d\n",-nhh2);
    E_old=-nhh2;
    printf("E_old=%f\n",E_old);
    nhh3=count_contacts(xf,yf);
    E_new=-nhh3;
    printf("E_new=%f\n",E_new);

    for (i=0;i<N;i++){
  	  double tempo1=xf[i];
  	  double tempo2=yf[i];
    printf("xf=%f\n",tempo1);
    printf("yf=%f\n",tempo2);
    }

    r = rand() / ((double)RAND_MAX + 1);
      printf("r=%f\n",r);
    if (E_new<E_old)
    {
        for (i=0;i<N;i++)
         {
             x[i]=xf[i];
             y[i]=yf[i];
         }
    }
    else
    {
  	  if (r<exp(-(E_new-(E_old))*beta0))
          {
            for (i=0;i<N;i++)
             {
                 x[i]=xf[i];
                 y[i]=yf[i];
             }
          }
  	  else { // new configuration rejected!
     	 for (i=0;i<L;i++) {
     		  for (j=0;j<L;j++) {
     			  occ[i][j]=occ_old[i][j];
     		  }
     	  }
  	  }
    }
    printf("Ende von if-Bed in pivot.h -----------------------------=%d\n",ret);
    }


  return 1;
}






#endif /* PIVOT_H_ */
