/* Weighted local search (breakout / clause weighting) for the cross set B of a two-block circulant
   book Ramsey graph on Z_v x {0,1}, v = 2n-1, with the within-block set A fixed.
   Constraint h (1..P): N_BB(h) <= cap(h) = bnd(h) - N_AA(h).  Cost = sum_h w[h] * max(0, N(h) - cap(h)).
   Each step: rank members b by the weighted gain of removing them and non-members c by the weighted
   cost of adding them, evaluate the K x K best pairs exactly, take the best non-tabu swap if it does not
   increase the weighted cost; otherwise raise the weights of the violated constraints by 1 (breakout).
   Weights decay to 1 with probability rho per weight increase step.
   usage: bwls n seed Afile seconds K tenure rho [restart_steps]   -> FOUND line and bsol_n_seed.txt */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>
static uint64_t s0,s1;
static inline uint64_t rnd(void){uint64_t a=s0,b=s1;s0=b;a^=a<<23;s1=a^b^(a>>17)^(b>>26);return s1+b;}
static inline double urand(void){return (rnd()>>11)*(1.0/9007199254740992.0);}
#define MV 1024
int n,v,P,H[MV],inA[MV],cap[MV/2],N[MV/2],w[MV/2],inB[MV],Bl[MV],Bo[MV],posB[MV],nb,no;
long long tabu[MV];
static inline int ex1(int h,int x){int e=x-cap[h];return e>0?e:0;}
/* exact weighted delta and unweighted excess delta of swapping b (in B) for c (not in B) */
static int dl[MV/2],tch[2*MV],mk[MV/2];
static void delta(int b,int c,long long*dw,int*de){
  int nt=0;
  for(int k=0;k<nb;k++){int y=Bl[k]; if(y==b)continue; int h=H[(b-y+v)%v]; if(!mk[h]){mk[h]=1;tch[nt++]=h;} dl[h]--;
    h=H[(c-y+v)%v]; if(!mk[h]){mk[h]=1;tch[nt++]=h;} dl[h]++;}
  long long W=0; int E=0;
  for(int k=0;k<nt;k++){int h=tch[k]; if(dl[h]){int a=ex1(h,N[h]+dl[h])-ex1(h,N[h]); W+=(long long)w[h]*a; E+=a;} dl[h]=0; mk[h]=0;}
  *dw=W; *de=E;
}
static void apply(int b,int c){
  for(int k=0;k<nb;k++){int y=Bl[k]; if(y==b)continue; N[H[(b-y+v)%v]]--; N[H[(c-y+v)%v]]++;}
  int ib=posB[b],ic=posB[c]; inB[b]=0;inB[c]=1;Bl[ib]=c;posB[c]=ib;Bo[ic]=b;posB[b]=ic;
}
int main(int argc,char**argv){
  if(argc<8){fprintf(stderr,"usage: bwls n seed Afile seconds K tenure rho [restart_steps]\n");return 2;}
  n=atoi(argv[1]); uint64_t seed=atoll(argv[2]); double secs=atof(argv[4]); int K=atoi(argv[5]); int ten=atoi(argv[6]); double rho=atof(argv[7]);
  long long rs= argc>8? atoll(argv[8]) : 0;
  v=2*n-1; P=(v-1)/2; for(int d=1;d<v;d++)H[d]=d<=P?d:v-d;
  s0=seed*0x9E3779B97F4A7C15ULL+17; s1=seed^0xD1B54A32D192ED03ULL; for(int i=0;i<10;i++)rnd();
  FILE*f=fopen(argv[3],"r"); int x; while(fscanf(f,"%d",&x)==1) inA[x%v]=1; fclose(f);
  int bA=n-2, bN= n%2==0? n+1:n-1, kb=n-1;
  for(int h=1;h<=P;h++){int s=0; for(int y=0;y<v;y++) if(inA[y]&&inA[(y+h)%v]) s++; cap[h]=(inA[h]?bA:bN)-s;}
  clock_t t0=clock(); long long step=0; int restart=0, bestall=1<<30;
  for(;;restart++){
    int perm[MV]; for(int i=0;i<v;i++)perm[i]=i; for(int i=v-1;i>0;i--){int j=rnd()%(i+1),t=perm[i];perm[i]=perm[j];perm[j]=t;}
    memset(inB,0,sizeof inB); nb=no=0; for(int i=0;i<v;i++){int y=perm[i]; if(i<kb){inB[y]=1;posB[y]=nb;Bl[nb++]=y;} else {posB[y]=no;Bo[no++]=y;}}
    memset(N,0,sizeof N); for(int h=1;h<=P;h++){int s=0; for(int y=0;y<v;y++) if(inB[y]&&inB[(y+h)%v]) s++; N[h]=s;}
    for(int h=1;h<=P;h++) w[h]=1;
    for(int i=0;i<v;i++) tabu[i]=-1;
    int ex=0; for(int h=1;h<=P;h++) ex+=ex1(h,N[h]);
    int best=ex; long long rstep=0;
    while(1){
      if(ex==0){
        char fn[128]; sprintf(fn,"bsol_%d_%llu.txt",n,(unsigned long long)seed); FILE*g=fopen(fn,"w");
        fprintf(g,"n %d v %d\nA",n,v); for(int y=1;y<v;y++) if(inA[y]) fprintf(g," %d",y); fprintf(g,"\nB"); for(int y=0;y<v;y++) if(inB[y]) fprintf(g," %d",y); fprintf(g,"\n"); fclose(g);
        printf("FOUND n %d seed %llu restart %d step %lld secs %.1f\n",n,(unsigned long long)seed,restart,step,(double)(clock()-t0)/CLOCKS_PER_SEC); return 0; }
      if((step&1023)==0 && (double)(clock()-t0)/CLOCKS_PER_SEC>secs){ printf("restart %d best %d final %d\nTIMEOUT steps %lld best %d\n",restart,best,ex,step,bestall<best?bestall:best); return 1; }
      if(rs && rstep>=rs) break;
      step++; rstep++;
      /* marginal weighted costs */
      static long long gm[MV/2],gp[MV/2];
      for(int h=1;h<=P;h++){ gm[h]=(long long)w[h]*(ex1(h,N[h]-1)-ex1(h,N[h])); gp[h]=(long long)w[h]*(ex1(h,N[h]+1)-ex1(h,N[h])); }
      /* score of removing b and of adding c (first order) */
      static long long sb[MV],sc[MV]; int ib_[MV],ic_[MV];
      for(int k=0;k<nb;k++){int b=Bl[k]; long long s=0; for(int j=0;j<nb;j++){int y=Bl[j]; if(y!=b) s+=gm[H[(b-y+v)%v]];} sb[k]=s;}
      for(int k=0;k<no;k++){int c=Bo[k]; long long s=0; for(int j=0;j<nb;j++) s+=gp[H[(c-Bl[j]+v)%v]]; sc[k]=s;}
      /* choose K best non-tabu b and c, random tie-break */
      int kb_=0,kc_=0;
      for(int k=0;k<nb;k++) if(tabu[Bl[k]]<step) ib_[kb_++]=k;
      for(int k=0;k<no;k++) if(tabu[Bo[k]]<step) ic_[kc_++]=k;
      for(int i=kb_-1;i>0;i--){int j=rnd()%(i+1),t=ib_[i];ib_[i]=ib_[j];ib_[j]=t;}
      for(int i=kc_-1;i>0;i--){int j=rnd()%(i+1),t=ic_[i];ic_[i]=ic_[j];ic_[j]=t;}
      int KB=K<kb_?K:kb_, KC=K<kc_?K:kc_;
      for(int a=0;a<KB;a++){int m=a; for(int i=a+1;i<kb_;i++) if(sb[ib_[i]]<sb[ib_[m]]) m=i; int t=ib_[a];ib_[a]=ib_[m];ib_[m]=t;}
      for(int a=0;a<KC;a++){int m=a; for(int i=a+1;i<kc_;i++) if(sc[ic_[i]]<sc[ic_[m]]) m=i; int t=ic_[a];ic_[a]=ic_[m];ic_[m]=t;}
      long long bw=1LL<<60; int bb=-1,bc=-1,bde=0, cnt=0;
      for(int a=0;a<KB;a++) for(int c2=0;c2<KC;c2++){ int b=Bl[ib_[a]], c=Bo[ic_[c2]]; long long dw; int de; delta(b,c,&dw,&de);
        if(dw<bw){bw=dw;bb=b;bc=c;bde=de;cnt=1;} else if(dw==bw){ cnt++; if(rnd()%cnt==0){bb=b;bc=c;bde=de;} } }
      if(bb>=0 && bw<=0){
        apply(bb,bc); ex+=bde; tabu[bb]=step+ten; tabu[bc]=step+ten;
        if(ex<best) best=ex;
      } else {
        for(int h=1;h<=P;h++) if(N[h]>cap[h]) w[h]++;
        if(urand()<rho) for(int h=1;h<=P;h++) if(w[h]>1) w[h]--;
      }
    }
    if(best<bestall) bestall=best;
    printf("restart %d best %d final %d\n",restart,best,ex); fflush(stdout);
  }
}
