/* Iterated local search for the slack-volume score G(A) (see phaseG.c).
   Local search: best-improving pair swap (one pair {p,-p} out of A, one in).
   Perturbation: r random swaps.  Acceptance: new local optimum if G >= current - tol.
   usage: phaseH n seed seconds r tol outfile */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
static uint64_t s0,s1;
static inline uint64_t rnd(void){uint64_t a=s0,b=s1;s0=b;a^=a<<23;s1=a^b^(a>>17)^(b>>26);return s1+b;}
static inline double urand(void){return (rnd()>>11)*(1.0/9007199254740992.0);}
int n,v,P,SA,S; double cs[1024][512],Ah[512],tmp[512],mu,sig;
int Al[512],Ao[512],nAl,nAo;
static inline double Rk(double a){ return n%2==0? n-2-a*a-3*a : n-1-a*a-a; }
static inline double lphi(double z){ return log(0.5*erfc(-z/sqrt(2.0))); }
static double score(const double*a){ double s=0; for(int k=1;k<=P;k++) s+=lphi((Rk(a[k])+mu)/sig); return s; }
static void doswap(int ip,int iq){ int p=Al[ip],q=Ao[iq]; for(int k=1;k<=P;k++) Ah[k]+=cs[k][q]-cs[k][p]; Al[ip]=q; Ao[iq]=p; }
static double localsearch(double sc){
  for(;;){
    double best=sc; int bi=-1,bj=-1;
    for(int i=0;i<nAl;i++) for(int j=0;j<nAo;j++){
      int p=Al[i],q=Ao[j]; for(int k=1;k<=P;k++) tmp[k]=Ah[k]-cs[k][p]+cs[k][q];
      double s=score(tmp); if(s>best+1e-12){best=s;bi=i;bj=j;}
    }
    if(bi<0) return sc;
    doswap(bi,bj); sc=best;
  }
}
int main(int argc,char**argv){
  if(argc<7){fprintf(stderr,"usage: phaseH n seed seconds r tol outfile\n");return 2;}
  n=atoi(argv[1]); uint64_t seed=atoll(argv[2]); double secs=atof(argv[3]); int r=atoi(argv[4]); double tol=atof(argv[5]);
  v=2*n-1; P=(v-1)/2; SA= n%2==0? n/2:(n-1)/2; S= n%2==0? (n-4)/2:(n-1)/2; mu=(double)S/P; sig=sqrt(2.0*S);
  s0=seed*0x9E3779B97F4A7C15ULL+29; s1=seed^0xD1B54A32D192ED03ULL; for(int i=0;i<10;i++)rnd();
  for(int k=0;k<=P;k++) for(int h=0;h<=P;h++) cs[k][h]=2*cos(2*M_PI*(double)((long)k*h%v)/v);
  int perm[512]; for(int i=0;i<P;i++)perm[i]=i+1; for(int i=P-1;i>0;i--){int j=rnd()%(i+1),t=perm[i];perm[i]=perm[j];perm[j]=t;}
  nAl=nAo=0; for(int i=0;i<P;i++){ if(i<SA) Al[nAl++]=perm[i]; else Ao[nAo++]=perm[i]; }
  for(int k=1;k<=P;k++){double s=0; for(int i=0;i<nAl;i++) s+=cs[k][Al[i]]; Ah[k]=s;}
  double sc=localsearch(score(Ah)), best=sc; int bestA[512]; memcpy(bestA,Al,sizeof(int)*nAl);
  int curA[512],curO[512]; double curAh[512];
  clock_t t0=clock(); long it=0;
  while((double)(clock()-t0)/CLOCKS_PER_SEC<secs){
    memcpy(curA,Al,sizeof(int)*nAl); memcpy(curO,Ao,sizeof(int)*nAo); memcpy(curAh,Ah,sizeof(double)*(P+1));
    for(int t=0;t<r;t++) doswap(rnd()%nAl,rnd()%nAo);
    double s2=localsearch(score(Ah)); it++;
    if(s2>best){best=s2; memcpy(bestA,Al,sizeof(int)*nAl);}
    if(s2>=sc-tol) sc=s2; else { memcpy(Al,curA,sizeof(int)*nAl); memcpy(Ao,curO,sizeof(int)*nAo); memcpy(Ah,curAh,sizeof(double)*(P+1)); }
  }
  FILE*f=fopen(argv[6],"w"); for(int i=0;i<nAl;i++) fprintf(f,"%d %d ",bestA[i],v-bestA[i]); fprintf(f,"\n"); fclose(f);
  printf("%s G %.3f iters %ld\n",argv[6],best,it); return 0;
}
