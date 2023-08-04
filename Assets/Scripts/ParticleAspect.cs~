using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;

public readonly partial struct ParticleAspect : IAspect
{
    public readonly Entity Entity;
    
    private readonly RefRW<LocalTransform> _transform;
    private readonly RefRO<ParticleTag> particleTag;

    private float Speed => particleTag.ValueRO.Speed;
    
    public float3 Position => _transform.ValueRO.Position;

    public void Move(float deltaTime)
    {
        _transform.ValueRW.Position += _transform.ValueRO.Up() * Speed * deltaTime;

        if (_transform.ValueRO.Position.y >= 100f)
        {
            _transform.ValueRW.Position = new float3(_transform.ValueRO.Position.x, 0f, _transform.ValueRO.Position.z);
        }
    }

}
