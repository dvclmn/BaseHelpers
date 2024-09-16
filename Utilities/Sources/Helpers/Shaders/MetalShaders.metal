//
//  Shaders.metal
//  Eucalypt
//
//  Created by Dave Coleman on 21/2/2024.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 psychodelics(
                   float2 position,
                   half4 color,
                   float4 bounds,
                   float time) {
                       const float speed = 0.5;
                       float slowedTime = time * speed;
                       
                       float2 uv = (position.xy - 0.5 * bounds.wz) / bounds.w;
                       float2 cir = uv * uv + sin(uv.x * 15 + slowedTime) / 15.0
                       * sin(uv.y * 7.0 + slowedTime) / 2.0 + uv.x
                       * sin(slowedTime) / 16.0 + uv.y * sin(slowedTime) / 16.0;
                       float circles = sqrt(abs(cir.x + cir.y * 0.5) * 35.0) * 5.0;
                       
                       return half4(sin(circles * 1.25 + 2.0), abs(sin(circles - 1.0) - sin(circles)), abs(sin(circles)), 1.0);
                   }

float oscillate(float f) {
    return 0.5 * (sin(f) + 1);
}


//[[ stitchable ]]
//kernel void colorHistogram(
//    texture2d<half, access::read> inTexture [[texture(0)]],
//    device atomic_uint *histogram [[buffer(0)]],
//    uint2 gid [[thread_position_in_grid]])
//{
//    // Read the input pixel color
//    const half4 color = inTexture.read(gid);
//    
//    // Reduce the color resolution, e.g., to 4 bits per channel
//    const uint r = uint(color.r * 15.0);
//    const uint g = uint(color.g * 15.0);
//    const uint b = uint(color.b * 15.0);
//    
//    // Calculate the histogram index for the reduced color
//    const uint index = (r << 8) | (g << 4) | b;
//    
//    // Atomically increment the histogram counter for this color
//    atomic_fetch_add_explicit(&histogram[index], 1, memory_order_relaxed);
//}



[[ stitchable ]]
half4 glitterTest(
                  float2 position,
                  SwiftUI::Layer layer,
                  float2 size,
                  float time
                  ) {
                      float2 uv = float2(position.x + 20, position.y + 60) / (size.x * 0.006);
                      float result = 0.0;
                      
                      const float greysThreshold = 0.12;
                      const float speed = 1.2;
                      
                      half4 red = layer.sample(uv * 0.9 + float2(time * -speed));
                      result += red.r;
                      
                      half4 green = layer.sample(uv * 1.8 + float2(time * speed));
                      result *= green.g;
                      
                      float alpha = result > greysThreshold ? 0.0 : 1.0;
                      
                      result = result > greysThreshold ? 1.0 : 0.0;
                      
                      return half4(result, result, result, alpha);
                  }





[[ stitchable ]]
half4 chromatic_abberation_static(float2 position, SwiftUI::Layer layer, float red, float blue, float strength) {
    
    // FIRST, WE STORE THE ORIGINAL COLOR.
    half4 original_color = layer.sample(position);
    
    // WE CREATE A NEW COLOR VARIABLE TO STORE THE MODIFIED COLOR.
    half4 new_color = original_color;
    
    // WE MODIFY THE COLOR BY SHIFTING THE RED AND BLUE CHANNELS.
    new_color.r = layer.sample(position - float2(red, -red)).r;
    
    // GREEN IS OPTIONAL, BUT WE CAN USE IT TO CREATE A MORE REALISTIC EFFECT.
    new_color.g = layer.sample(position).g;
    
    new_color.b = layer.sample(position - float2(blue, -blue)).b;
    
    // BLEND THE ORIGINAL COLOR WITH THE NEW COLOR BASED ON THE STRENGTH FACTOR.
    half4 blended_color = mix(original_color, new_color, strength);
    
    // WE RETURN THE NEW COLOR.
    return blended_color;
}

