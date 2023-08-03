// to accomodate for the fact that this function is valid for
// the mathy axis orientation of "X+ east Y+ north", negate the
// computer axis orientation ("X+ east Y+ south") _y component
// as you feed it in, then negate the y element of the returned
// struct as soon as you get it back
function rotate2Dvector(_x, _y, _deltaTheta)
	{
	var _magnitude = sqrt(sqr(_x) + sqr(_y));
	var _theta = darctan2(_y, _x) + _deltaTheta;
	return
		{
		x: _magnitude*dcos(_theta),
		y: _magnitude*dsin(_theta)
		};
	}

function reRange(_aMin, _aX, _aMax, _bMin, _bMax)
	{
	var _percent = (_aX - _aMin)/(_aMax - _aMin);
	return _bMin + _percent*(_bMax - _bMin);
	}

function draw_line_crudeAA(_x1, _y1, _x2, _y2, _iterations)
	{
	var _alphaBefore = draw_get_alpha();
	draw_set_alpha(1/_iterations);
	for (var _iterI = 0; _iterI < _iterations; ++_iterI)
		{
		var _dx = lengthdir_x(0.5, 360*(_iterI/_iterations));
		var _dy = lengthdir_y(0.5, 360*(_iterI/_iterations));
		draw_line(_x1 + _dx, _y1 + _dy, _x2 + _dx, _y2 + _dy);
		}
	draw_set_alpha(_alphaBefore);
	}