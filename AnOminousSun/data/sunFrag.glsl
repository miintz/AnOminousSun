
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform sampler2D Stage1;
uniform sampler2D Stage2;
uniform sampler2D Stage3;
uniform sampler2D Stage4;
uniform sampler2D Stage5;
uniform sampler2D Stage6;

uniform float Time;
uniform float useClouds;

varying float Diffuse;
varying vec3  Specular;

void main() 
{
	float gloss	   = texture2D(Stage1, vertTexCoord.st).r;
	float clouds   = texture2D(Stage2, vec2(vertTexCoord.s+Time, vertTexCoord.t)).r;
	clouds *= useClouds;
	
    vec3 daytime   = (texture2D(Stage3, vertTexCoord.st).rgb * Diffuse + Specular * gloss) * (1.0 - clouds) + clouds * Diffuse;
    vec3 nighttime = texture2D(Stage4, vertTexCoord.st).rgb * (1.0 - clouds) * 2.0;

    vec3 color = daytime;

    if (Diffuse < 0.1)
        color = mix(nighttime, daytime, (Diffuse + 0.1) * 5.0);

    gl_FragColor = vec4(color, 1.0);
}
