/*
 * count_contacts.h
 *
 *  Created on: 04.10.2011
 *      Author: Jonathan Zoller
 */

#ifndef COUNT_CONTACTS_H_
#define COUNT_CONTACTS_H_

int count_contacts(int x[], int y[])
{
  int i, j, k;
  int hh , hp , pp;
  hh=hp=pp=0;

  for(i = 0; i < N; i++)
  {
    for(j = 0; j < 4; j++)
    {
      k = occ[x[i] + (j == 0 ? 1 : (j == 2 ? -1 : 0))] //j==0 -> (x+1,y), j==2 -> (x-1,y)
        [y[i] + (j == 1 ? 1 : (j == 3 ? -1 : 0))] - 1; //j==1 -> (x,y+1), j==3 -> (x,y-1)
      if(k > i + 1)
      {
        if(!seq[i] && !seq[k]) // seq[i]==0 AND seq[k]==0
          (pp)++;
        else if(seq[i] && seq[k]) {
          (hh)++;
          printf("k+1_count=%d\n",k+1);
          printf("i+1_count=%d\n",i+1);
          printf("j_count=%d\n",j);
        }

        else
          (hp)++;
      }
    }
  }
  return hh;
}


#endif /* COUNT_CONTACTS_H_ */
