shader_type canvas_item;

float grid(vec2 uv, float velocity, float iTime)
{
    vec2 size = vec2(uv.y, uv.y * uv.y * 0.2) * 0.01;
    uv += vec2(0.0, iTime * 4.0 * (velocity + 0.05));
    uv = abs(fract(uv) - 0.5);
 	vec2 lines = smoothstep(size, vec2(0.0), uv);
 	lines += smoothstep(size * 5.0, vec2(0.0), uv) * 0.4 * velocity;
    return clamp(lines.x + lines.y, 0.0, 3.0);
}


void fragment()
{
    vec2 uv = (2.0 * FRAGCOORD.xy.xy - (1.0 / SCREEN_PIXEL_SIZE).xy)/(-1.4 / SCREEN_PIXEL_SIZE).y;
    float velocity = 1.0;
   
    {
        // Grid
        vec3 col = vec3(0.0, 0.1, 0.2);
        if (uv.y < -0.2)
        {
            uv.y = 3.0 / (abs(uv.y + 0.2) + 0.05);
            uv.x *= uv.y * 1.0;
            float gridVal = grid(uv, velocity, TIME*10.0);
            col = mix(col, vec3(0.5, 0.5, 1.0), gridVal);
        }
        else
        {
            uv.y -= velocity * 1.1 - 0.51;
        }

        col = mix(vec3(col.r, col.r, col.r) * 0.5, col*0.7,  0.7);

        COLOR = vec4(col,1.0);
    }
      
}