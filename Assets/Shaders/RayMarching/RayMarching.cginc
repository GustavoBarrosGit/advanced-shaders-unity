#define STEPS 30

float sphere_sdf(float3 p){
    float displacement = sin(_Displacement * p.x) * sin(_Displacement * p.y) * sin(_Displacement*p.z) * 0.25;
    float d = length(p-_Center) - _Radius + displacement * cos(_Time.y+p.x+p.y+p.z);
    return d;
}

int raymarching(float3 ro, float3 rd, inout float3 pos){
    float total_dist = 0;


    for(int i=0;i<STEPS;i++){
        pos = ro + rd * total_dist;
        float d = sphere_sdf(pos);
        if(d<0.001){
            return 1;
        }
        if(d>1000){
            return 0;
        }

        total_dist += d;
    }
    return 0;
}

float3 calculate_normal(float3 p)
{
    float offset = 0.001;

    float grad_x = sphere_sdf(float3(p.x + offset,p.y,p.z)) - sphere_sdf(float3(p.x - offset,p.y,p.z));
    float grad_y = sphere_sdf(float3(p.x,p.y + offset,p.z)) - sphere_sdf(float3(p.x,p.y - offset,p.z));
    float grad_z = sphere_sdf(float3(p.x,p.y,p.z + offset)) - sphere_sdf(float3(p.x,p.y,p.z - offset));

    float3 normal = float3(grad_x,grad_y,grad_z);
    return normalize(normal);
}