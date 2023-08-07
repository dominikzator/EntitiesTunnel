using Unity.Entities;
using UnityEngine;
using Random = Unity.Mathematics.Random;

public class TunnelMono : MonoBehaviour
{
    public GameObject ParticlePrefab;
    [HideInInspector] public float ParticleSpawnTimer;
    public float ParticleSpawnRate;
    [HideInInspector] public uint RandomSeed;
    public float Radius;
}

public class TunnelBaker : Baker<TunnelMono>
{
    public override void Bake(TunnelMono authoring)
    {
        var tunnelEntity = GetEntity(TransformUsageFlags.Dynamic);
        
        AddComponent(tunnelEntity, new TunnelProperties
        {
            ParticlePrefab = GetEntity(authoring.ParticlePrefab, TransformUsageFlags.Dynamic),
            ParticleSpawnTimer = authoring.ParticleSpawnTimer,
            ParticleSpawnRate = authoring.ParticleSpawnRate,
            RandomValue = Random.CreateFromIndex(authoring.RandomSeed),
            Radius = authoring.Radius
        });
    }
}