using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;
using UnityEngine;

public readonly partial struct ParticleAspect : IAspect
{
    public readonly Entity Entity;
    
    private readonly RefRW<LocalTransform> _transform;
    private readonly RefRW<ParticleTag> particleTag;

    private float Speed => particleTag.ValueRO.Speed;
    
    public float3 Position => _transform.ValueRO.Position;

    public void Move(float deltaTime)
    {
        _transform.ValueRW.Position += _transform.ValueRO.Forward() * Speed * deltaTime;
    }
}
