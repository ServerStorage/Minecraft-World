#include "ShaderConstants.fxh"

struct PS_Input
{
    float4 position : SV_Position;
    float4 color : COLOR;
	float3 cloud : CLOUD;
	float skya : SKYA;
};

struct PS_Output
{
    float4 color : SV_Target;
};
float hash(float2 p)
{

    p = frac(p * 0.1031);
    p += dot(p, p + 10.19);
	
    return frac((p.x + p.y) * p.y);
}

float noise( float2 p )
{
    float2 i = floor( p );
    float2 f = frac( p );
	float2 u = f*f*(3.0-2.0*f);

    return lerp( lerp( hash( i + float2(0.0,0.0) ), hash( i + float2(1.0,0.0) ), u.x),lerp( hash( i + float2(0.0,1.0) ), hash( i + float2(1.0,1.0) ), u.x), u.y);
}
float fbm(float2 p){
    return noise(p) * 0.6 + noise(p*3.0) * 0.3 + noise(p*6.0) * 0.21 + noise(p*12.0) * 0.064 + noise(p*24.0) * 0.032 + noise(p*48.0) * 0.032; 
}
float cloudH2(float2 p, float mm) {
    float m = 4.0;
    float2 q = float2(fbm(float2(p)), fbm(p+float2(5.12*TIME*0.01, 1.08)));
    
    float2 r = float2(fbm((p+q*m)+float2(0.1, 4.741)), fbm((p+q*m)+float2(1.952, 7.845))); 
    m /= mm;
    return fbm(p+r*m);
}
void main( in PS_Input PSInput, out PS_Output PSOutput )
{	
	float night = FOG_COLOR.r + FOG_COLOR.g + FOG_COLOR.b + (1.0-PSInput.skya)*PSInput.skya;
   
	float2 xz = ((PSInput.cloud.xz)*5.6);
	
	xz.y += xz.y*2.0/500.0;
	
	xz.x += TIME*0.0375;
	
	float col = cloudH2(xz, 12.0+fbm(xz)*16.0);
	
	float col2 = cloudH2(xz+float2(0.1,0.1), 12.0+fbm(xz)*16.1);
	
	float4 clouds = lerp(float4(1.0,1.0,1.0,2.0)*0.8,float4(1.0,1.0,1.0,1.0), min(max(smoothstep(0.5, 1.0, col2),0.0),1.0));
	
	clouds *= night*0.35;
	
	
	PSOutput.color = lerp(lerp( CURRENT_COLOR+float4(0.0,0.1,0.1,0.0), FOG_COLOR,PSInput.skya ),clouds,min(max(smoothstep(0.5, 1.0, col),0.0),1.0));
}