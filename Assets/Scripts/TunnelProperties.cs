using Unity.Entities;

public struct TunnelProperties : IComponentData
{
    public int ParticlesToSpawn;
    public Entity ParticlePrefab;
}
