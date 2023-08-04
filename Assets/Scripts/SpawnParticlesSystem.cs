using Unity.Burst;
using Unity.Collections;
using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;

[BurstCompile]
[UpdateInGroup(typeof(InitializationSystemGroup))]
public partial struct SpawnParticlesSystem : ISystem
{
    [BurstCompile]
    public void OnCreate(ref SystemState state)
    {
        state.RequireForUpdate<TunnelProperties>();
    }

    [BurstCompile]
    public void OnDestroy(ref SystemState state)
    {
        
    }

    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        state.Enabled = false;
        var tunnelEntity = SystemAPI.GetSingletonEntity<TunnelProperties>();
        var tunnel = SystemAPI.GetAspect<TunnelAspect>(tunnelEntity);
        
        var ecb = new EntityCommandBuffer(Allocator.Temp);
        
        for (var i = 0; i < tunnel.ParticlesToSpawn; i++)
        {
            var particle = ecb.Instantiate(tunnel.ParticlePrefab);
            ecb.SetComponent(particle, new LocalTransform{ Position = new float3(UnityEngine.Random.Range(-50, 50f), UnityEngine.Random.Range(0, 100f), UnityEngine.Random.Range(-50, 50f)), Scale = 1f, Rotation = quaternion.identity});
        }

        ecb.Playback(state.EntityManager);
    }
}