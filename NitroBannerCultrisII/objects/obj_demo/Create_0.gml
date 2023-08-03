
#region eewwww software 3D
fakeCam = {};
with (fakeCam)
	{
	// publicly assignable
	FOV_hAngle = 70;
	xFrom = -100;
	yFrom = -100;
	zFrom = -500;
	altitude = -18;
	azimuth = -45;
	
	// calculated
	FOV_hSlope = undefined;
	FOV_vSlope = undefined;
	aspectRatio = undefined;
	
	// run this after assigning a new value to FOV_hAngle
	updateFOV = function()
		{
		aspectRatio = room_width/room_height;
		FOV_hSlope = dsin(FOV_hAngle/2);
		FOV_vSlope = FOV_hSlope/aspectRatio;
		};
	updateFOV();
	
	project = function(_x, _y, _z)
		{
		// slide both point and cam bringing cam "from" to world origin
		_x -= xFrom;
		_y -= yFrom;
		_z -= zFrom;
		
		// lock relative rotation of point and cam to each other, force cam to aim due east by rotation of both
		var _xyRotated = rotate2Dvector(_x, -_y, -azimuth);
		_x = _xyRotated.x;
		_y = -_xyRotated.y;
		var _xzRotated = rotate2Dvector(_x, -_z, -altitude);
		_x = _xzRotated.x;
		_z = -_xzRotated.y;
		
		// determine where in frustum point lies (we finally have a visual 2D coordinate based on the 3D point; _fx and _fy lie in -1 to 1)
		var _fx = _y/(FOV_hSlope*_x);
		var _fy = _z/(FOV_vSlope*_x);
		
		// blow up 2D coordinate to scale of room
		return
			{
			x: reRange(-1, _fx, 1, 0, room_width),
			y: reRange(-1, _fy, 1, 0, room_height)
			};
		};
	}
#endregion

// quick and dirty movement
moveVel = 1200;  // px per sec
turnAngleDelta = 50;  // degrees per sec




// actual stuff specific to this project
aaIterations = 8;
gradientColA = $110C03;
gradientColB = $6F4D16;

terrain_rowCount = 48;
terrain_clmnCount = 48;
terrain_s = 192;
terrain = array_create(terrain_rowCount);
terrain_projected = array_create(terrain_rowCount);
for (var _rowI = 0; _rowI < terrain_rowCount; ++_rowI)
	{
	terrain[_rowI] = array_create(terrain_clmnCount);
	terrain_projected[_rowI] = array_create(terrain_clmnCount);
	}
terrain_radialAnim_origin_x = irandom(terrain_clmnCount);  // terrain[][] index
terrain_radialAnim_origin_y = irandom(terrain_rowCount);  // terrain[][] index
terrain_radialAnim_amplitude = -128;  // pre-projected room pixels (think about the z axis)
terrain_radialAnim_radius = 15;  // cells/units, not pixels
terrain_radialAnim_phase = 0;  // percentage in [0,1]
terrain_radialAnim_phase_delta = 0.2;  // portion of 100% (again, in [0,1]) per second
terrain_calculate = function()
	{
	for (var _rowI = 0; _rowI < terrain_rowCount; ++_rowI)
		{
		for (var _clmnI = 0; _clmnI < terrain_clmnCount; ++_clmnI)
			{
			terrain[_rowI][_clmnI] =
				terrain_radialAnim_amplitude*
				sin(2*pi*(terrain_radialAnim_phase - (
					point_distance(
						terrain_radialAnim_origin_x,
						terrain_radialAnim_origin_y,
						_clmnI,
						_rowI
					)/terrain_radialAnim_radius)));
			}
		}
	}
terrain_project = function()
	{
	for (var _rowI = 0; _rowI < terrain_rowCount; ++_rowI)
		{
		for (var _clmnI = 0; _clmnI < terrain_clmnCount; ++_clmnI)
			{
			terrain_projected[_rowI][_clmnI] = fakeCam.project(_rowI*terrain_s, _clmnI*terrain_s, terrain[_rowI][_clmnI]);
			}
		}
	};
terrain_draw = function()
	{
	for (var _rowI = 0; _rowI < terrain_rowCount; ++_rowI)
		{
		var _p = undefined;
		var _pEast = undefined;
		var _pSouth = undefined;
		for (var _clmnI = 0; _clmnI < terrain_clmnCount; ++_clmnI)
			{
			_p = (is_undefined(_p))?(terrain_projected[_rowI][_clmnI]):(_pEast);
				// FORMER/TRUE -> we're on the west edge, grab the first projected coordinate
				// LATTER/FALSE -> we've moved east one unit, old east is new rightHere
			if (_clmnI < terrain_clmnCount - 1)  // not east edge, do draw east stick
				{
				_pEast = terrain_projected[_rowI][_clmnI + 1];
				draw_line_crudeAA(_p.x, _p.y, _pEast.x, _pEast.y, aaIterations);
				}
			if (_rowI < terrain_rowCount - 1)  // not south edge, do draw south stick
				{
				_pSouth = terrain_projected[_rowI + 1][_clmnI];
				draw_line_crudeAA(_p.x, _p.y, _pSouth.x, _pSouth.y, aaIterations);
				}
			}
		}
	};

// if (display_aa > 12) { display_reset(8, true); }