///@desc

w = room_width;
h = room_height;
surf_crt = -1;

application_surface_draw_enable(false);

u_time = shader_get_uniform(shd_crt, "u_time");
u_resolution = shader_get_uniform(shd_crt, "u_resolution");

u_texel = shader_get_uniform(shd_bloom, "u_texel");