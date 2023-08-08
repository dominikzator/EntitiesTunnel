using Unity.Burst;
using Unity.Entities;

[BurstCompile]
[UpdateInGroup(typeof(InitializationSystemGroup))]
public partial struct MoveParticlesSystem : ISystem
{
    [BurstCompile]
    public void OnCreate(ref SystemState state)
    {
        
    }
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var deltaTime = SystemAPI.Time.DeltaTime;

        new MoveParticlesJob()
        {
            DeltaTime = deltaTime,
        }.ScheduleParallel();
    }
}

[BurstCompile]
public partial struct MoveParticlesJob : IJobEntity
{
    public float DeltaTime;
    
    [BurstCompile]
    private void Execute(ParticleAspect particle, [EntityIndexInQuery] int sortKey)
    {
        particle.MoveForward(DeltaTime);
    }
}
