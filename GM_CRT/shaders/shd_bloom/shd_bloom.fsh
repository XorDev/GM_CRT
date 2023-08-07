/*
	Bloom shader by @XorDev
	https://mini.gmshaders.com/p/gm-shaders-mini-crt
*/
//Bloom radius in pixels
#define BLOOM_RADIUS 16.0
//Bloom texture samples
#define BLOOM_SAMPLES 32.0
//Bloom base brightness
#define BLOOM_BASE 0.5
//Bloom glow brightness
#define BLOOM_GLOW 3.0

//Reciprocal of resolution
uniform vec2 u_texel;

varying vec4 v_color;
varying vec2 v_coord;

void main()
{
    //Pixel coordinates
	vec2 pixel = v_coord / u_texel;
    
    //Bloom total
   	vec4 bloom = vec4(0);
    //Sample point
    vec2 point = vec2(BLOOM_RADIUS, 0) * inversesqrt(BLOOM_SAMPLES);
    for(float i = 0.0; i<BLOOM_SAMPLES; i++)
    {
        //Rotate by golden angle
        point *= -mat2(0.7374, 0.6755, -0.6755, 0.7374);
        //Compute sample coordinates from rotated sample point
        vec2 coord = (pixel + point*sqrt(i)) * u_texel;
        //Add bloom samples
        bloom += texture2D(gm_BaseTexture, coord) * (1.0 - i/BLOOM_SAMPLES);
    }
    //Compute bloom average
    bloom *= BLOOM_GLOW/BLOOM_SAMPLES;
    //Add base sample
    bloom += texture2D(gm_BaseTexture, v_coord) * BLOOM_BASE;
    gl_FragColor = v_color * bloom;
}
