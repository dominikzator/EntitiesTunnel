using Unity.Entities;
using Unity.Mathematics;

public struct ParticleTag : IComponentData
{
    public float Speed;
    public float RotateSpeed;
    public float3 RandomRotation;
}
