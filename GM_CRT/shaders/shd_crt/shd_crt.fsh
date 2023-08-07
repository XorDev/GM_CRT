/*
	CRT shader by @XorDev
	https://mini.gmshaders.com/p/gm-shaders-mini-crt
*/
//RGB Mask intensity(0 to 1)
#define MASK_INTENSITY 1.0
//Mask size (in pixels)
#define MASK_SIZE 12.0
//Border intensity (0 to 1)
#define MASK_BORDER 0.8

//Chromatic abberration offset in texels (0 = no aberration)
#define ABERRATION_OFFSET vec2(2,0)

//Curvature intensity
#define SCREEN_CURVATURE 0.08
//Screen vignette
#define SCREEN_VIGNETTE 0.4

//Intensity of pulsing animation
#define PULSE_INTENSITY 0.03
//Pulse width in pixels (times tau)
#define PULSE_WIDTH 6e1
//Pulse animation speed
#define PULSE_RATE 2e1

//Animation time in seconds
uniform float u_time;
//Screen resolution
uniform vec2 u_resolution;

varying vec4 v_color;
varying vec2 v_coord;

void main()
{
    //Signed uv coordinates (ranging from -1 to +1)
	vec2 uv = v_coord * 2.0 - 1.0;
    //Scale inward using the square of the distance
	uv *= 1.0 + (dot(uv,uv) - 1.0) * SCREEN_CURVATURE;
    //Convert back to pixel coordinates
	vec2 pixel = (uv*0.5+0.5)*u_resolution;
    
    //Square distance to the edge
    vec2 edge = max(1.0 - uv*uv, 0.0);
    //Compute vignette from x/y edges
    float vignette = pow(edge.x * edge.y, SCREEN_VIGNETTE);
	
    //RGB cell and subcell coordinates
    vec2 coord = pixel / MASK_SIZE;
    vec2 subcoord = coord * vec2(3,1);
    //Offset for staggering every other cell
	vec2 cell_offset = vec2(0, fract(floor(coord.x)*0.5));
    
    //Pixel coordinates rounded to the nearest cell
    vec2 mask_coord = floor(coord+cell_offset) * MASK_SIZE;
    
    //Chromatic aberration
	vec4 aberration = texture2D(gm_BaseTexture, (mask_coord-ABERRATION_OFFSET) / u_resolution);
    //Color shift the green channel
	aberration.g = texture2D(gm_BaseTexture,    (mask_coord+ABERRATION_OFFSET) / u_resolution).g;
   
    //Output color with chromatic aberration
	vec4 color = aberration;
    
    //Compute the RGB color index from 0 to 2
    float ind = mod(floor(subcoord.x), 3.0);
    //Convert that value to an RGB color (multiplied to maintain brightness)
    vec3 mask_color = vec3(ind == 0.0, ind == 1.0, ind == 2.0) * 3.0;
    
    //Signed subcell uvs (ranging from -1 to +1)
    vec2 cell_uv = fract(subcoord + cell_offset) * 2.0 - 1.0;
    //X and y borders
    vec2 border = 1.0 - cell_uv * cell_uv * MASK_BORDER;
    //Blend x and y mask borders
    mask_color.rgb *= border.x * border.y;
    //Blend with color mask
	color.rgb *= 1.0 + (mask_color - 1.0) * MASK_INTENSITY;  
    
    //Apply vignette
    color.rgb *= vignette;
    //Apply pulsing glow
	color.rgb *= 1.0+PULSE_INTENSITY*cos(pixel.x/PULSE_WIDTH+u_time*PULSE_RATE);
    
    gl_FragColor = v_color * color;
}
