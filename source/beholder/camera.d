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

protected:
    import gfm.math;

    vec2f _window;
    vec3f _position;
    float _size;
    mat4f _projection, _view, _mvp_matrix, _model, _model_view;

    /// Преобразование экранных координат в мировые.
    /// Возвращает луч из камеры в мировых координатах.
    vec3f screenPoint2worldRay(vec2f screenCoords) pure const
    {
        vec3f normalized;
        normalized.x = (2.0f * screenCoords.x) / _window.x - 1.0f;
        normalized.y = 1.0f - (2.0f * screenCoords.y) / _window.y;

        vec4f rayClip = vec4f(normalized.xy, -1.0, 1.0);

        vec4f rayEye = _projection.inverse * rayClip;
        rayEye = vec4f(rayEye.xy, -1.0, 0.0);

        vec3f rayWorld = (_view.inverse * rayEye).xyz;
        rayWorld.normalize;

        return rayWorld;
    }

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