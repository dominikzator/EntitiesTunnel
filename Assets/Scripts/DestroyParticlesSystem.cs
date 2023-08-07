using Unity.Burst;
using Unity.Entities;
using Unity.Transforms;

[BurstCompile]
partial struct DestroyParticleSystem : ISystem
{
    [BurstCompile]
    public void OnCreate(ref SystemState state)
    {
        
    }

    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var ecbSingleton = SystemAPI.GetSingleton<EndSimulationEntityCommandBufferSystem.Singleton>();

        var destroyParticleJob = new DestroyParticleJob
        {
            ECB = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged),
            DeltaTime = SystemAPI.Time.DeltaTime
        };

        destroyParticleJob.Schedule();
    }
}

// IJobEntity relies on source generation to implicitly define a query from the signature of the Execute function.
[BurstCompile]
public partial struct DestroyParticleJob : IJobEntity
{
    public EntityCommandBuffer ECB;
    public float DeltaTime;

    void Execute(Entity entity, ref ParticleTag particleTag, ref LocalTransform transform)
    {
        particleTag.TimeToDestroy -= DeltaTime;
        
        if (particleTag.TimeToDestroy <= 0f)
        {
            ECB.DestroyEntity(entity);
        }
    }
}