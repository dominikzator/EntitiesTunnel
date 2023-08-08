using Unity.Burst;
using Unity.Entities;

[BurstCompile]
[UpdateInGroup(typeof(InitializationSystemGroup))]
public partial struct RotateParticlesSystem : ISystem
{
    [BurstCompile]
    public void OnCreate(ref SystemState state)
    {
        
    }
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var time = (float)SystemAPI.Time.ElapsedTime;

        new RotateParticlesJob()
        {
            Time = time,
        }.ScheduleParallel();
    }
}

[BurstCompile]
public partial struct RotateParticlesJob : IJobEntity
{
    public float Time;
    
    [BurstCompile]
    private void Execute(ParticleAspect particle, [EntityIndexInQuery] int sortKey)
    {
        particle.RandomRotate(Time);
    }
}