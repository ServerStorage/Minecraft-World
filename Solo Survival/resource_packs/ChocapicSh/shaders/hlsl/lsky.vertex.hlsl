#include "ShaderConstants.fxh"

struct VS_Input
{
    float3 position : POSITION;
	float4 color : COLOR;
	
#ifdef INSTANCEDSTEREO
	uint instanceID : SV_InstanceID;
#endif
};


struct PS_Input
{
    float4 position : SV_Position;
    float4 color : COLOR;
	float3 cloud : CLOUD;
	float skya : SKYA;
	
#ifdef INSTANCEDSTEREO
	uint instanceID : SV_InstanceID;
#endif
};


void main( in VS_Input VSInput, out PS_Input PSInput )
{
#ifdef INSTANCEDSTEREO
	int i = VSInput.instanceID;
	PSInput.position = mul( WORLDVIEWPROJ_STEREO[i], float4( VSInput.position, 1 ) );
	PSInput.instanceID = i;
#else
	PSInput.position = mul(WORLDVIEWPROJ, float4(VSInput.position, 1));
#endif

    PSInput.cloud = VSInput.position.xyz;
	
	PSInput.skya = VSInput.color.r;
	
    //PSInput.color =lerp(lerp( CURRENT_COLOR, FOG_COLOR,VSInput.color.r ), lerp( CURRENT_COLOR+float4(0.0,0.1,0.2,0.0), FOG_COLOR,min(max(smoothstep(0.5, 1.0, VSInput.color.r * (1.0-VSInput.color.r)*2.0),0.0),1.0) ),VSInput.color.r);
	PSInput.color = lerp( CURRENT_COLOR+float4(0.0,0.2,0.3,0.0), FOG_COLOR,VSInput.color.r );

}