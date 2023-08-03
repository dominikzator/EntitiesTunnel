using System.Collections;
using System.Collections.Generic;
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
    }
}

public struct ParticleRenderer : IComponentData
{
    public Entity Value;
}
