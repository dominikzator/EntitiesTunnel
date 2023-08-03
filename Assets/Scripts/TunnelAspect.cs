using System.Collections;
using System.Collections.Generic;
using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;
using UnityEngine;

public readonly partial struct TunnelAspect : IAspect
    {
        public readonly Entity Entity;

        private readonly RefRO<LocalTransform> _transform;
        private LocalTransform Transform => _transform.ValueRO;

        private readonly RefRO<TunnelProperties> tunnelProperties;
        
        public int ParticlesToSpawn => tunnelProperties.ValueRO.ParticlesToSpawn;
        public Entity ParticlePrefab => tunnelProperties.ValueRO.ParticlePrefab;

        private const float BRAIN_SAFETY_RADIUS_SQ = 100;
        
        
        public float3 Position => Transform.Position;
    }
