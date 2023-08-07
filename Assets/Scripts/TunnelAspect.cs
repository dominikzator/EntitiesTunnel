using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;

public readonly partial struct TunnelAspect : IAspect
{
    public readonly Entity Entity;

    private readonly RefRO<LocalTransform> _transform;
    private LocalTransform Transform => _transform.ValueRO;

    private readonly RefRW<TunnelProperties> tunnelProperties;
        
    public Entity ParticlePrefab => tunnelProperties.ValueRO.ParticlePrefab;

    public float ParticleSpawnRate => tunnelProperties.ValueRO.ParticleSpawnRate;

    public float2 TunnelRandom => tunnelProperties.ValueRW.RandomValue.NextFloat2(new float2(Radius, Radius));

    public float Radius => tunnelProperties.ValueRO.Radius;

    public float ParticleSpawnTimer
    {
        get => tunnelProperties.ValueRO.ParticleSpawnTimer;
        set => tunnelProperties.ValueRW.ParticleSpawnTimer = value;
    }

    private const float BRAIN_SAFETY_RADIUS_SQ = 100;
        
    public float3 Position => Transform.Position;
}
