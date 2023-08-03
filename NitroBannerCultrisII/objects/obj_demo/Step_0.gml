
if (keyboard_check_released(ord("F")))
	{
	window_set_fullscreen(!window_get_fullscreen());
	}

if (keyboard_check_released(vk_add))
	{
	show_debug_message("New aaIterations will be " + string(aaIterations + 1));
	++aaIterations;
	}
if (keyboard_check_released(vk_subtract))
	{
	show_debug_message("New aaIterations will be " + string(aaIterations - 1));
	--aaIterations;
	}

var _pstps = delta_time/1000000;

terrain_radialAnim_phase += terrain_radialAnim_phase_delta*_pstps;
terrain_calculate();

var _posDelta = {x: 0, y: 0, z: 0};
if (keyboard_check(ord("W")))
	{
	_posDelta.x += lengthdir_x(moveVel*_pstps, fakeCam.azimuth);
	_posDelta.y += lengthdir_y(moveVel*_pstps, fakeCam.azimuth);
	}
if (keyboard_check(ord("A")))
	{
	_posDelta.x += lengthdir_x(moveVel*_pstps, fakeCam.azimuth + 90);
	_posDelta.y += lengthdir_y(moveVel*_pstps, fakeCam.azimuth + 90);
	}
if (keyboard_check(ord("S")))
	{
	_posDelta.x -= lengthdir_x(moveVel*_pstps, fakeCam.azimuth);
	_posDelta.y -= lengthdir_y(moveVel*_pstps, fakeCam.azimuth);
	}
if (keyboard_check(ord("D")))
	{
	_posDelta.x += lengthdir_x(moveVel*_pstps, fakeCam.azimuth - 90);
	_posDelta.y += lengthdir_y(moveVel*_pstps, fakeCam.azimuth - 90);
	}
if (keyboard_check(ord("Q"))) { _posDelta.z += moveVel*_pstps; }
if (keyboard_check(ord("E"))) { _posDelta.z -= moveVel*_pstps; }
fakeCam.xFrom += _posDelta.x;
fakeCam.yFrom += _posDelta.y;
fakeCam.zFrom += _posDelta.z;
if (keyboard_check(vk_left)) { fakeCam.azimuth += turnAngleDelta*_pstps; }
if (keyboard_check(vk_right)) { fakeCam.azimuth -= turnAngleDelta*_pstps; }
fakeCam.azimuth = fakeCam.azimuth mod 360;
if (keyboard_check(vk_up)) { fakeCam.altitude += turnAngleDelta*_pstps; }
if (keyboard_check(vk_down)) { fakeCam.altitude -= turnAngleDelta*_pstps; }
fakeCam.altitude = clamp(fakeCam.altitude, -89, 89);