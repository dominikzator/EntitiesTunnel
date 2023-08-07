using Unity.Burst;
using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;
using UnityEngine;

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
        var ecbSingleton = SystemAPI.GetSingleton<BeginInitializationEntityCommandBufferSystem.Singleton>();
        var cyclicSpawnParticleJob = new CyclicSpawnParticleJob { ECB = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged), DeltaTime = SystemAPI.Time.DeltaTime};

        cyclicSpawnParticleJob.Run();
    }
    
    // IJobEntity relies on source generation to implicitly define a query from the signature of the Execute function.
    [BurstCompile]
    public partial struct CyclicSpawnParticleJob : IJobEntity
    {
        public EntityCommandBuffer ECB;
        public float DeltaTime;
        
        public void Execute(TunnelAspect tunnel)
        {
            int spawnCount = (tunnel.ParticleSpawnRate >= DeltaTime) ? 1 : (int)(DeltaTime / tunnel.ParticleSpawnRate);

            if (spawnCount == 1)
            {
                tunnel.ParticleSpawnTimer -= DeltaTime;
            }
            else
            {
                tunnel.ParticleSpawnTimer -= tunnel.ParticleSpawnRate * spawnCount;
            }
            
            if (tunnel.ParticleSpawnTimer <= 0f)
            {
                for (int i = 0; i < spawnCount; i++)
                {
                    var randomPoint = tunnel.TunnelRandom;
                    var particle = ECB.Instantiate(tunnel.ParticlePrefab);
                    ECB.SetComponent(particle, new LocalTransform{ Position = new float3(randomPoint.x, randomPoint.y, 0f), Scale = .1f, Rotation = quaternion.identity});
                }
                tunnel.ParticleSpawnTimer = tunnel.ParticleSpawnRate;
            }
        }
    }
}