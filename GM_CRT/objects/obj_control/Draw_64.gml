///@desc

if !surface_exists(surf_crt) surf_crt = surface_create(w,h);

surface_set_target(surf_crt);
draw_clear_alpha(0,0);
shader_set(shd_crt);
shader_set_uniform_f(u_time, get_timer()/1000000);
shader_set_uniform_f(u_resolution, w, h);
draw_surface(application_surface,0,0);
shader_reset();
surface_reset_target();

shader_set(shd_bloom);
shader_set_uniform_f(u_texel, 1/w, 1/h);
draw_surface(surf_crt,0,0);
shader_reset();