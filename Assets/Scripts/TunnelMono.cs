using Unity.Entities;
using UnityEngine;

public class TunnelMono : MonoBehaviour
{
    public int ParticlesToSpawn;
    public GameObject ParticlePrefab;
}

public class TunnelBaker : Baker<TunnelMono>
{
    public override void Bake(TunnelMono authoring)
    {
        var tunnelEntity = GetEntity(TransformUsageFlags.Dynamic);
        
        AddComponent(tunnelEntity, new TunnelProperties
        {
            ParticlePrefab = GetEntity(authoring.ParticlePrefab, TransformUsageFlags.Dynamic),
            ParticlesToSpawn = authoring.ParticlesToSpawn
        });
    }
}