module beholder.camera;

class Camera
{
    this(vec2f window, vec3f position, float size)
    {
        _projection = mat4f.identity;
        _mvp_matrix = mat4f.identity;
        _model      = mat4f.identity;
        _view       = mat4f.identity;

        _position   = position;
        _window     = window;
        _size       = size < 0 ? 0 : size;

        updateMatrices;
    }

    auto size(float size)
    {
        _size = size;
        updateMatrices();
    }

    auto size() const
    {
        return _size;
    }

    auto window(vec2f window)
    {
        _window = window;
        updateMatrices();
    }

	auto window()
	{
		return _window;
	}

    auto position() const
    {
        return _position;
    }

    auto position(vec3f position)
    {
        _position = position;
        updateMatrices();
    }

    ref mvpMatrix()
    {
        return _mvp_matrix;
    }

	ref projection()
	{
		return _projection;
	}

	ref modelView()
	{
		return _model_view;
	}

	ref model()
	{
		return _model;
	}
	
	ref view()
	{
		return _view;
	}

	auto unproject(float x, float y)
	{
		return unproject(vec2f(x, y));
	}

	auto unproject(vec2f p0)
	{
		const ndc = vec3f(2.0*p0.x/_window.x-1.0, 2.0*p0.y/_window.y-1, -1);
		const u = (_projection*_model).inverse;
		const rn = u * vec4f(ndc.xy, 0, 1);
		const rf = u * vec4f(ndc.xy, 1, 1);
		const p1 = rn.xyz / rn.w + _position;
		const p2 = rf.xyz / rf.w + _position;

		return ray3f(p1, p2);
	}

protected:
    import gfm.math;

    vec2f _window;
    vec3f _position;
    float _size;
    mat4f _projection, _view, _mvp_matrix, _model, _model_view;

    void updateMatrices()
    {
        auto aspect_ratio= _window.x/_window.y;

        if(_window.x <= _window.y)
            _projection = mat4f.orthographic(-_size, +_size,-_size/aspect_ratio, +_size/aspect_ratio, -_size, +_size);
        else
            _projection = mat4f.orthographic(-_size*aspect_ratio,+_size*aspect_ratio,-_size, +_size, -_size, +_size);

        _view = mat4f.lookAt(
            vec3f(_position.x, _position.y, +_size), // Camera has world coordinates
            vec3f(_position.x, _position.y, -_size), // and looks at origin
            vec3f(0, 1, 0)  // "Head" is up
        );

		_model_view = _view * _model;

        _mvp_matrix = _projection * _model_view;
    }
}