

#define CODEGENERATOR_VERSION    "1.1"
#define ACCELERATOR_VERSION      "1.1"

#define SIMULINK_NAME	"Chou_shi"	

#include <math.h>
#include <string.h>

#include "simstruc.h"



#define SINE_WAVE    1
#define SQUARE_WAVE  2
#define SAW_WAVE     3
#define RANDOM_WAVE  4
#ifndef M_PI
#define	M_PI	3.14159265358979323846
#endif
#ifndef SEED0
#define SEED0	1144108930
#endif

#define LOW_SEED   1          
#define HIGH_SEED  2147483646 
#define START_SEED 1144108930 


static double urand(seed)
	unsigned int *seed;
{
	unsigned int hi, lo;
	long test;

#define IA 16807	
#define IM 2147483647	
#define IQ 127773	
#define IR 2836	
#define S  4.656612875245797e-10	

	hi = *seed / IQ;
	lo = *seed % IQ;
	test = IA * lo - IR * hi;

	*seed = ((test < 0) ? (unsigned int)(test + IM) : (unsigned int)test);

	return ((double) (*seed * S));

#undef IA
#undef IM
#undef IQ
#undef IR
#undef S
}


static double nrand(seed)
	unsigned int *seed;
{
	double sr, si, t;

	do {
		sr = 2.0 * urand(seed) - 1.0;
		si = 2.0 * urand(seed) - 1.0;
		t = sr * sr + si * si;
	} while (t > 1.0);

	return (sr * sqrt((-2.*log(t)) / t));
}


static double sig_gen_output(signalType, peak, freq, nextOutput, time)
	double signalType;
	double peak;
	double freq;
	double nextOutput;
	double time;
{
	switch ((int) signalType) {
		default:

		
		case SINE_WAVE:
			return peak * sin(freq * time);

		
		case SQUARE_WAVE:
			if (time * freq >= 0.5 + floor(time * freq))
				return peak;
			return -peak;

		
		case SAW_WAVE:
			return peak - 2. * peak * (freq * time - floor(freq * time));

		
		case RANDOM_WAVE:
			return 2.0 * peak * (nextOutput - 0.5);
	}
}


static void mdlInitializeSizes(S)
	SimStruct * S;
{
	ssSetNumContStates(S, 8);            
	ssSetNumDiscStates(S, 2);            
	ssSetNumOutputs(S, 0);               
	ssSetNumInputs(S, 0);                
	ssSetDirectFeedThrough(S, 0);        
	ssSetNumSampleTimes(S, 4);           
	ssSetNumIWork(S, 1);                 
	ssSetNumRWork(S, 1);                 
	ssSetNumPWork(S, 0);                 
	ssSetNumBlocks(S, 28);               
	ssSetNumScopes(S, 10);               
	ssSetNumBlockIO(S, 18);              
	ssSetNumBlockParams(S, 24);          
	ssSetChecksum(S, -1036243173);       
	ssSetParamChecksum(S, -1004903092);  
}


static void mdlInitializeSampleTimes(S)
	SimStruct * S;
{
	ssSetSampleTimeEvent(S, 0, 0);
	ssSetSampleTimeEvent(S, 1, 0.001);
	ssSetSampleTimeEvent(S, 2, 0.0314159265358979);
	ssSetSampleTimeEvent(S, 3, 0.0314159265358979);

	ssSetOffsetTimeEvent(S, 0, 0);
	ssSetOffsetTimeEvent(S, 1, 0);
	ssSetOffsetTimeEvent(S, 2, 0.0005);
	ssSetOffsetTimeEvent(S, 3, 0.0015);
}


static void mdlInitializeConditions(x0, S)
	double * x0;
	SimStruct * S;
{
	double *B = ssGetBlockIO(S);         
	double *P = ssGetBlockParam(S);      
	double *RWork = ssGetRWork(S);       
	int *IWork = ssGetIWork(S);          

	
	x0[8] = P[1];

	
	x0[9] = P[2];

	
	IWork[0] = SEED0 + (unsigned int)P[7];	
	RWork[0] = urand((unsigned int *) &IWork[0]);

	
	x0[0] = 0.0;
	x0[1] = 0.0;
	x0[2] = 0.0;
	x0[3] = 0.0;

	
	x0[4] = 0.0;
	x0[5] = 0.0;
	x0[6] = 0.0;
	x0[7] = 0.0;
}


static void mdlOutputs(y, x, u, S, tid)
	double * y;
	double * x;
	double * u;
	SimStruct * S;
	int tid;
{
	double *B = ssGetBlockIO(S);         
	double *P = ssGetBlockParam(S);      
	double *RWork = ssGetRWork(S);       
	int *IWork = ssGetIWork(S);          

	if (ssIsContinuousTask(S,tid))       
	{
		
		B[0] = P[0];
	}

	if (ssIsSampleHitEvent(S,2,tid))     
	{
		
		B[1] = x[8];

		
		B[2] = B[0] - B[1];
	}

	if (ssIsSampleHitEvent(S,3,tid))     
	{
		
		B[3] = x[9];

		
		B[4] = B[0] - B[3];
	}

	if (ssIsContinuousTask(S,tid))       
	{
		
		B[5] = ((B[2] != 0) + (B[4] != 0)) % 2;

		
		B[6] = !((B[5] != 0));

		
		B[7] = ssGetT(S);

		
		B[8] = P[3];

		
		B[9] = B[7] >= B[8];

		
		B[10] = B[6] * B[9];

		
		B[11] = P[4] * B[10];

		
		B[12] = sig_gen_output(P[5], P[6], P[7], RWork[0], ssGetT(S));

		
		B[13] = P[15] * x[3];

		
		B[14] = B[13] * B[11];

		
		B[15] = B[14];

		
		B[16] = ssGetT(S);

		
		B[17] = P[23] * x[7];
	}
}


static void mdlUpdate(x, u, S, tid)
	double * x;
	double * u;
	SimStruct * S;
	int tid;
{
	double *B = ssGetBlockIO(S);         
	double *P = ssGetBlockParam(S);      
	double *RWork = ssGetRWork(S);       
	int *IWork = ssGetIWork(S);          
	double *Scopes = ssGetScopes(S);     

	if (ssIsSampleHitEvent(S,2,tid))     
	{
		
		x[8] = B[2];
	}

	if (ssIsSampleHitEvent(S,3,tid))     
	{
		
		x[9] = B[4];
	}

	if (ssIsContinuousTask(S,tid))       
	{
		
		RWork[0] = urand((unsigned int *) &IWork[0]);
	}

	if (ssIsContinuousTask(S,tid))       
	{
		
		Scopes[0] = B[11];

		
		Scopes[1] = B[12];

		
		Scopes[2] = B[15];
	}

	if (ssIsSampleHitEvent(S,1,tid))     
	{
		
		Scopes[3] = B[16];
	}

	if (ssIsContinuousTask(S,tid))       
	{
		
		Scopes[4] = B[17];
	}

	if (ssIsSampleHitEvent(S,1,tid))     
	{
		
		Scopes[5] = B[13];
	}

	if (ssIsContinuousTask(S,tid))       
	{
		
		Scopes[6] = B[13];
	}

	if (ssIsSampleHitEvent(S,1,tid))     
	{
		
		Scopes[7] = B[12];

		
		Scopes[8] = B[17];

		
		Scopes[9] = B[15];
	}
}


static void mdlDerivatives(dx, x, u, S, tid)
	double * dx;
	double * x;
	double * u;
	SimStruct * S;
	int tid;
{
	double *B = ssGetBlockIO(S);         
	double *P = ssGetBlockParam(S);      
	double *RWork = ssGetRWork(S);       
	int *IWork = ssGetIWork(S);          

	

	
	dx[0] = P[8] * x[0] +
		P[9] * x[1] +
		B[12];
	dx[1] = P[10] * x[0];
	dx[2] = P[11] * x[1] +
		P[12] * x[2] +
		P[13] * x[3];
	dx[3] = P[14] * x[2];

	

	
	dx[4] = P[16] * x[4] +
		P[17] * x[5] +
		B[15];
	dx[5] = P[18] * x[4];
	dx[6] = P[19] * x[5] +
		P[20] * x[6] +
		P[21] * x[7];
	dx[7] = P[22] * x[6];
}


static void mdlTerminate(S)
	SimStruct * S;
{
	double *B = ssGetBlockIO(S);         
	double *P = ssGetBlockParam(S);      
	double *RWork = ssGetRWork(S);       
	int *IWork = ssGetIWork(S);          
}

#include "simulink.c"

