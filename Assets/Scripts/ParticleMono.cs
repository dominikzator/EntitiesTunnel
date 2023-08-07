using Unity.Entities;
using UnityEngine;

public class ParticleMono : MonoBehaviour
{
    public GameObject Renderer;
}

public class ParticleBaker : Baker<ParticleMono>
{
    public override void Bake(ParticleMono authoring)
    {
        var particleEntity = GetEntity(TransformUsageFlags.Dynamic);
        AddComponent(particleEntity, new ParticleRenderer
        {
            Value = GetEntity(authoring.Renderer, TransformUsageFlags.Dynamic)
        });
        AddComponent(particleEntity, new ParticleTag
        {
            Speed = 5f,
            TimeToDestroy = 5f
        });
    }
}

public struct ParticleRenderer : IComponentData
{
    public Entity Value;
}

public struct ParticleTag : IComponentData
{
    public float Speed;
    public float TimeToDestroy;
}
