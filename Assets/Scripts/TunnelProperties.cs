using Unity.Entities;
using Unity.Mathematics;

public struct TunnelProperties : IComponentData
{
    public Entity ParticlePrefab;
    public float ParticleSpawnTimer;
    public float ParticleSpawnRate;
    public Random RandomValue;
    public float Radius;
}
