/* Phase 1: anneal a symmetric A (|A| = n even, n-1 odd) to maximise softmin_k R(k),
   R(k) = n-2-A^2-3A (even) or n-1-A^2-A (odd).   usage: phaseA n seed steps beta T0 T1 count outprefix */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <stdint.h>
static uint64_t s0,s1;
static inline uint64_t rnd(void){uint64_t a=s0,b=s1;s0=b;a^=a<<23;s1=a^b^(a>>17)^(b>>26);return s1+b;}
static inline double urand(void){return (rnd()>>11)*(1.0/9007199254740992.0);}
int n,v,P,SA; double cs[512][512]; int inA[512],Al[512],Ao[512],nAl,nAo,posAl[512],posAo[512];
double Ah[512],tmp[512];
static double Rk(double a){ return n%2==0? n-2-a*a-3*a : n-1-a*a-a; }
static double score(double*a,double beta,double*mn){ double m=1e18; for(int k=1;k<=P;k++){double r=Rk(a[k]); if(r<m)m=r;} double s=0; for(int k=1;k<=P;k++) s+=exp(-beta*(Rk(a[k])-m)); *mn=m; return m-log(s)/beta; }
int main(int argc,char**argv){
  n=atoi(argv[1]); uint64_t seed=atoll(argv[2]); long long steps=atoll(argv[3]); double beta=atof(argv[4]),T0=atof(argv[5]),T1=atof(argv[6]); int cnt=atoi(argv[7]); char*pre=argv[8];
  v=2*n-1; P=(v-1)/2; SA= n%2==0? n/2:(n-1)/2;
  s0=seed*0x9E3779B97F4A7C15ULL+11; s1=seed^0xD1B54A32D192ED03ULL; for(int i=0;i<10;i++)rnd();
  for(int k=0;k<=P;k++) for(int h=0;h<=P;h++) cs[k][h]=2*cos(2*M_PI*(double)((long)k*h%v)/v);
  for(int c=0;c<cnt;c++){
    int perm[512]; for(int i=0;i<P;i++)perm[i]=i+1; for(int i=P-1;i>0;i--){int j=rnd()%(i+1),t=perm[i];perm[i]=perm[j];perm[j]=t;}
    memset(inA,0,sizeof inA); nAl=nAo=0; for(int i=0;i<P;i++){int p=perm[i]; if(i<SA){inA[p]=1;posAl[p]=nAl;Al[nAl++]=p;} else {posAo[p]=nAo;Ao[nAo++]=p;}}
    for(int k=1;k<=P;k++){double s=0; for(int i=0;i<nAl;i++) s+=cs[k][Al[i]]; Ah[k]=s;}
    double mn, sc=score(Ah,beta,&mn), best=-1e18; int bestA[512];
    for(long long it=0;it<steps;it++){
      double T=T0*pow(T1/T0,(double)it/steps);
      int ip=rnd()%nAl, iq=rnd()%nAo, p=Al[ip], q=Ao[iq];
      for(int k=1;k<=P;k++) tmp[k]=Ah[k]-cs[k][p]+cs[k][q];
      double mn2, sc2=score(tmp,beta,&mn2);
      if(sc2>=sc || urand()<exp((sc2-sc)/T)){
        memcpy(Ah,tmp,sizeof(double)*(P+1)); sc=sc2; mn=mn2;
        inA[p]=0; inA[q]=1; Al[ip]=q; posAl[q]=ip; Ao[iq]=p; posAo[p]=iq;
        if(mn>best){best=mn; for(int i=0;i<nAl;i++) bestA[i]=Al[i];}
      }
    }
    char fn[256]; sprintf(fn,"%s_%d_%llu_%d.txt",pre,n,(unsigned long long)seed,c); FILE*f=fopen(fn,"w");
    for(int i=0;i<nAl;i++) fprintf(f,"%d %d ",bestA[i],v-bestA[i]); fprintf(f,"\n"); fclose(f);
    printf("%s minR %.3f\n",fn,best); fflush(stdout);
  }
  return 0;
}
