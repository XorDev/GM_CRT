///@desc Draw CRT + bloom

//Make sure the surface exists first!
if !surface_exists(surf_crt) surf_crt = surface_create(w,h);

//Draw the CRT pass
surface_set_target(surf_crt);
draw_clear_alpha(0,0);
//Set shader and uniforms
shader_set(shd_crt);
shader_set_uniform_f(u_time, get_timer()/1000000);
shader_set_uniform_f(u_resolution, w, h);
//Draw the whole app surface for our demo
draw_surface(application_surface,0,0);
//Reset shader and surface
shader_reset();
surface_reset_target();

//Draw bloom pass
shader_set(shd_bloom);
shader_set_uniform_f(u_texel, 1/w, 1/h);
draw_surface(surf_crt,0,0);
shader_reset();