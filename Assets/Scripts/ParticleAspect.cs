using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;

public readonly partial struct ParticleAspect : IAspect
{
    public readonly Entity Entity;
    
    private readonly RefRW<LocalTransform> _transform;
    private readonly RefRW<ParticleTag> particleTag;

    private float Speed => particleTag.ValueRO.Speed;
    
    public float3 Position => _transform.ValueRO.Position;

    public void MoveForward(float deltaTime)
    {
        _transform.ValueRW.Position += _transform.ValueRO.Forward() * Speed * deltaTime;
        if (_transform.ValueRO.Position.z >= SpawnParticlesMono.Instance.TunnelLength)
        {
            _transform.ValueRW.Position = new float3(_transform.ValueRO.Position.x, _transform.ValueRO.Position.y, 0f);
        }
    }
}
