float4 gaussianBlur(float2 dir, float4 grabPos, float res, sampler2D tex, float radius)
{
    float4 sum = float4(0, 0, 0, 0);
    
    float blur = radius / res; 
    
    float hstep = dir.x;
    float vstep = dir.y;
    
    
    sum += tex2Dproj(tex, float4(grabPos.x - 4*blur*hstep, grabPos.y - 4.0*blur*vstep, grabPos.zw)) * 0.0162162162;
    sum += tex2Dproj(tex, float4(grabPos.x - 3.0*blur*hstep, grabPos.y - 3.0*blur*vstep, grabPos.zw)) * 0.0540540541;
    sum += tex2Dproj(tex, float4(grabPos.x - 2.0*blur*hstep, grabPos.y - 2.0*blur*vstep, grabPos.zw)) * 0.1216216216;
    sum += tex2Dproj(tex, float4(grabPos.x - 1.0*blur*hstep, grabPos.y - 1.0*blur*vstep, grabPos.zw)) * 0.1945945946;
    
    sum += tex2Dproj(tex, float4(grabPos.x, grabPos.y, grabPos.zw)) * 0.2270270270;
    
    sum += tex2Dproj(tex, float4(grabPos.x + 1.0*blur*hstep, grabPos.y + 1.0*blur*vstep, grabPos.zw)) * 0.1945945946;
    sum += tex2Dproj(tex, float4(grabPos.x + 2.0*blur*hstep, grabPos.y + 2.0*blur*vstep, grabPos.zw)) * 0.1216216216;
    sum += tex2Dproj(tex, float4(grabPos.x + 3.0*blur*hstep, grabPos.y + 3.0*blur*vstep, grabPos.zw)) * 0.0540540541;
    sum += tex2Dproj(tex, float4(grabPos.x + 4.0*blur*hstep, grabPos.y + 4.0*blur*vstep, grabPos.zw)) * 0.0162162162;

    return float4(sum.rgb, 1.0);
}