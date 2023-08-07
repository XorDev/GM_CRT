///@desc Initialize

//Screen dimensions for demo
w = room_width;
h = room_height;

//Variable for CRT pass
surf_crt = -1;

//CRT shader uniforms
u_time = shader_get_uniform(shd_crt, "u_time");
u_resolution = shader_get_uniform(shd_crt, "u_resolution");

//Bloom shader uniforms
u_texel = shader_get_uniform(shd_bloom, "u_texel");

//We'll draw this manually
application_surface_draw_enable(false);