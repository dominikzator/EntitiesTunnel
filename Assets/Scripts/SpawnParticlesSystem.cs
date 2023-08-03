using Unity.Burst;
using Unity.Collections;
using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;
using UnityEngine;
using Random = Unity.Mathematics.Random;

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
        var graveyardEntity = SystemAPI.GetSingletonEntity<TunnelProperties>();
        var graveyard = SystemAPI.GetAspect<TunnelAspect>(graveyardEntity);
        
        var ecb = new EntityCommandBuffer(Allocator.Temp);
        
        for (var i = 0; i < graveyard.ParticlesToSpawn; i++)
        {
            var newTombstone = ecb.Instantiate(graveyard.ParticlePrefab);
            ecb.SetComponent(newTombstone, new LocalTransform{ Position = new float3(UnityEngine.Random.Range(-5, 5f), 0f, UnityEngine.Random.Range(-5, 5f)), Scale = 1f, Rotation = quaternion.identity});
        }

        ecb.Playback(state.EntityManager);
    }
}