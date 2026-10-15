/* Phase 2: anneal B (|B| = n-1) for a fixed A with cost  w*sum max(0,N-c) + mu*sum (N-T)^2.
   c(h) = bnd(h) - N_AA(h); T(h) = c(h) - s(h) (target slack from the LP, file).
   usage: bsa n seed Afile Tfile steps restarts T0 T1 mu pf      */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdint.h>
static uint64_t s0,s1;
static inline uint64_t rnd(void){uint64_t a=s0,b=s1;s0=b;a^=a<<23;s1=a^b^(a>>17)^(b>>26);return s1+b;}
static inline double urand(void){return (rnd()>>11)*(1.0/9007199254740992.0);}
int n,v,P,H[1024],inA[1024],cap[512],N[512],dl[512],mk[512],tch[4096],nt; double Tg[512],mu;
int inB[1024],Bl[1024],Bo[1024],posB[1024];
static inline double cst(int h,int x){int e=x-cap[h]; return (e>0?e:0)+mu*(x-Tg[h])*(x-Tg[h]);}
static inline void addd(int h,int x){ if(!mk[h]){mk[h]=1;tch[nt++]=h;} dl[h]+=x; }
int main(int argc,char**argv){
  n=atoi(argv[1]); uint64_t seed=atoll(argv[2]); long long steps=atoll(argv[5]); int maxr=atoi(argv[6]); double T0=atof(argv[7]),T1=atof(argv[8]); mu=atof(argv[9]); double pf=atof(argv[10]);
  v=2*n-1; P=(v-1)/2; for(int d=1;d<v;d++)H[d]=d<=P?d:v-d;
  s0=seed*0x9E3779B97F4A7C15ULL+13; s1=seed^0xD1B54A32D192ED03ULL; for(int i=0;i<10;i++)rnd();
  FILE*f=fopen(argv[3],"r"); int x; while(fscanf(f,"%d",&x)==1) inA[x%v]=1; fclose(f);
  int bA= n%2==0? n-2:n-2, bN= n%2==0? n+1:n-1;
  for(int h=1;h<=P;h++){int s=0; for(int y=0;y<v;y++) if(inA[y]&&inA[(y+h)%v]) s++; cap[h]=(inA[h]?bA:bN)-s;}
  f=fopen(argv[4],"r"); for(int h=1;h<=P;h++){double s; if(fscanf(f,"%lf",&s)!=1)return 2; Tg[h]=cap[h]-s;} fclose(f);
  for(int r=0;r<maxr;r++){
    int perm[1024]; for(int i=0;i<v;i++)perm[i]=i; for(int i=v-1;i>0;i--){int j=rnd()%(i+1),t=perm[i];perm[i]=perm[j];perm[j]=t;}
    memset(inB,0,sizeof inB); int nb=0,no=0; for(int i=0;i<v;i++){int y=perm[i]; if(i<n-1){inB[y]=1;posB[y]=nb;Bl[nb++]=y;} else {posB[y]=no;Bo[no++]=y;}}
    memset(N,0,sizeof N); for(int h=1;h<=P;h++){int s=0; for(int y=0;y<v;y++) if(inB[y]&&inB[(y+h)%v]) s++; N[h]=s;}
    int ex=0; double C=0; for(int h=1;h<=P;h++){int e=N[h]-cap[h]; ex+=e>0?e:0; C+=cst(h,N[h]);}
    int best=ex; int viol[512];
    for(long long it=0;it<steps;it++){
      double T=T0*pow(T1/T0,(double)it/steps);
      int b,c;
      if(ex>0&&urand()<pf){ int nv=0; for(int h=1;h<=P;h++) if(N[h]>cap[h]) viol[nv++]=h; int h=viol[rnd()%nv];
        int cand[1024],nc=0; for(int k=0;k<n-1;k++){int y=Bl[k]; if(inB[(y+h)%v]||inB[(y-h+v)%v]) cand[nc++]=y;}
        b=cand[rnd()%nc]; c=Bo[rnd()%(v-n+1)]; }
      else { b=Bl[rnd()%(n-1)]; c=Bo[rnd()%(v-n+1)]; }
      nt=0; for(int k=0;k<n-1;k++){int y=Bl[k]; if(y==b)continue; addd(H[(b-y+v)%v],-1); addd(H[(c-y+v)%v],1);}
      double d=0; int de=0;
      for(int k=0;k<nt;k++){int h=tch[k]; if(dl[h]){ d+=cst(h,N[h]+dl[h])-cst(h,N[h]); int e1=N[h]+dl[h]-cap[h], e0=N[h]-cap[h]; de+=(e1>0?e1:0)-(e0>0?e0:0);} }
      if(d<=0||urand()<exp(-d/T)){
        for(int k=0;k<nt;k++){int h=tch[k]; N[h]+=dl[h];}
        int ib=posB[b],ic=posB[c]; inB[b]=0;inB[c]=1;Bl[ib]=c;posB[c]=ib;Bo[ic]=b;posB[b]=ic; ex+=de; C+=d; if(ex<best)best=ex;
      }
      for(int k=0;k<nt;k++){dl[tch[k]]=0;mk[tch[k]]=0;}
      if(ex==0){ char fn[128]; sprintf(fn,"bsol_%d_%llu.txt",n,(unsigned long long)seed); FILE*g=fopen(fn,"w");
        fprintf(g,"n %d v %d\nA",n,v); for(int y=1;y<v;y++) if(inA[y]) fprintf(g," %d",y); fprintf(g,"\nB"); for(int y=0;y<v;y++) if(inB[y]) fprintf(g," %d",y); fprintf(g,"\n"); fclose(g);
        printf("FOUND n %d seed %llu restart %d step %lld\n",n,(unsigned long long)seed,r,it); return 0; }
    }
    printf("restart %d best %d final %d\n",r,best,ex); fflush(stdout);
  }
  return 1;
}
