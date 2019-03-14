int N=25; // (number of amino acids)
int L=51; // is the lattice size and should be set to 2N+1
int seq[]={1,1,0,1,1,0,1,0,0,1,1,0,1,0,0,1,0,0,0,1,1,0,1,0,1}; // (vector holding the amino acid sequence (1 for H, and 0 for P)
int x[25]; // (x position for the aa sequence)
int y[25]; // (y position for the aa sequence)
int occ[51][51]; // (flag for when a lattice site is occupied by an amino acid, i+1=aa i at pos and 0=no)
int nhh,nhp,npp; //(number of contacts of the different forms)
double T=400;
double beta;// (one over temperature, 1/T)
time_t t; //used for rand() seeding
double E_old,E_new; //energy values for the new and the old configurations
FILE *en; //pointer to file storing energy values
FILE *dist; //pointer to file storing end-to-end distances
FILE *conf; //pointer to file storing the final configuration
