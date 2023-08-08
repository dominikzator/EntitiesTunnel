using System.Collections.Generic;
using Unity.Collections;
using Unity.Entities;
using Unity.Jobs;
using Unity.Mathematics;
using Unity.Rendering;
using Unity.Transforms;
using UnityEngine;
using UnityEngine.Rendering;
using Random = Unity.Mathematics.Random;

public class SpawnParticlesMono : MonoBehaviour
{
    public int ParticlesToSpawn;
    public Mesh ParticleMesh;
    public Material ParticleMaterial;
    public float TunnelRadius;
    public float TunnelLength;
    public int DifferentMaterialsCount;
    public float MinParticleSpeed;
    public float MaxParticleSpeed;

    private static float tunnelRadius;
    private static float tunnelLength;
    private static int differentMaterialsCount;
    private static float minParticleSpeed;
    private static float maxParticleSpeed;
    
    private static Random random;

    public static SpawnParticlesMono Instance;
    
    // Example Burst job that creates many entities
    [GenerateTestsForBurstCompatibility]
    public struct SpawnJob : IJobParallelFor
    {
        public Entity Prototype;
        public EntityCommandBuffer.ParallelWriter Ecb;

        public void Execute(int index)
        {
            var e = Ecb.Instantiate(index, Prototype);
            
            Ecb.SetComponent(index, e, MaterialMeshInfo.FromRenderMeshArrayIndices(random.NextInt(differentMaterialsCount), 0));
            Ecb.SetComponent(index, e, new LocalTransform {Position = GetRandomPosition(), Scale = 0.1f, Rotation = quaternion.identity});
            Ecb.SetComponent(index, e, new ParticleTag {Speed = random.NextFloat(minParticleSpeed, maxParticleSpeed)});
        }
    }

    private static Vector3 GetRandomPosition()
    {
        var startingPoint = new Vector2(0f, tunnelRadius * random.NextFloat(tunnelRadius));
        var randomCirclePoint = RotatePoint(startingPoint.x, startingPoint.y, random.NextFloat(360f), Vector2.zero);
        return new float3(randomCirclePoint.x, randomCirclePoint.y, random.NextFloat(tunnelLength));
    }

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            random = Random.CreateFromIndex((uint)UnityEngine.Random.Range(0, 100));
            tunnelRadius = TunnelRadius;
            tunnelLength = TunnelLength;
            differentMaterialsCount = (ParticlesToSpawn > DifferentMaterialsCount) ? DifferentMaterialsCount : ParticlesToSpawn;
            minParticleSpeed = MinParticleSpeed;
            maxParticleSpeed = MaxParticleSpeed;
        }
        else
        {
            Destroy(this);
        }
    }

    void Start()
    {
        var world = World.DefaultGameObjectInjectionWorld;
        var entityManager = world.EntityManager;
        var matList = new List<Material>();
        EntityCommandBuffer ecb = new EntityCommandBuffer(Allocator.TempJob);
        
        var colorsCount = ParticlesToSpawn <= differentMaterialsCount ? ParticlesToSpawn : differentMaterialsCount;
        
        for (int i=0;i<colorsCount;i++)
        {
            var mat = new Material(ParticleMaterial);
            Color col = new Color(UnityEngine.Random.Range(0.0f,1.0f), UnityEngine.Random.Range(0.0f,1.0f), UnityEngine.Random.Range(0.0f,1.0f), 1f);
            mat.SetColor("_Color", col);              // set for LW
            mat.SetColor("_BaseColor", col);          // set for HD
            matList.Add(mat);
        }

        var desc = new RenderMeshDescription(
            shadowCastingMode: ShadowCastingMode.Off,
            receiveShadows: false);
        
        var renderMeshArray = new RenderMeshArray(matList.ToArray(), new[] { ParticleMesh });
        
        var prototype = entityManager.CreateEntity();
        
        RenderMeshUtility.AddComponents(
            prototype,
            entityManager,
            desc,
            renderMeshArray,
            MaterialMeshInfo.FromRenderMeshArrayIndices(0, 0));
        
        entityManager.AddComponentData(prototype, new LocalTransform{Position = default, Scale = default, Rotation = quaternion.identity});
        entityManager.AddComponentData(prototype, new ParticleTag{Speed = default});
        
        var spawnJob = new SpawnJob
        {
            Prototype = prototype,
            Ecb = ecb.AsParallelWriter(),
        };

        var spawnHandle = spawnJob.Schedule(ParticlesToSpawn,128);
        spawnHandle.Complete();

        ecb.Playback(entityManager);
        ecb.Dispose();
        entityManager.DestroyEntity(prototype);
    }
    
    private static Vector2 RotatePoint(float cx,float cy,float angle,Vector2 point)
    {
        float s = math.sin(angle);
        float c = math.cos(angle);

        // translate point back to origin:
        point.x -= cx;
        point.y -= cy;

        // rotate point
        float xnew = point.x * c - point.y * s;
        float ynew = point.x * s + point.y * c;

        // translate point back:
        point.x = xnew + cx;
        point.y = ynew + cy;
        return point;
    }
}
