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
    private float RotationSpeed => particleTag.ValueRO.RotateSpeed;
    private float3 RandomRotation => particleTag.ValueRO.RandomRotation;
    
    public float3 Position => _transform.ValueRO.Position;

    public void MoveForward(float deltaTime)
    {
        _transform.ValueRW.Position += _transform.ValueRO.Forward() * Speed * deltaTime;
        if (_transform.ValueRO.Position.z >= SpawnParticlesMono.Instance.TunnelLength)
        {
            _transform.ValueRW.Position = new float3(_transform.ValueRO.Position.x, _transform.ValueRO.Position.y, 0f);
        }
    }

    public void RandomRotate(float time)
    {
        _transform.ValueRW.Rotation = quaternion.RotateX(RandomRotation.x * time * RotationSpeed);
        _transform.ValueRW.Rotation = quaternion.RotateY(RandomRotation.y * time * RotationSpeed);
        _transform.ValueRW.Rotation = quaternion.RotateZ(RandomRotation.z * time * RotationSpeed);
    }

}
