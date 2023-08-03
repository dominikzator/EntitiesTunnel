using System.Collections;
using System.Collections.Generic;
using Unity.Entities;
using UnityEngine;

public struct TunnelProperties : IComponentData
{
    public int ParticlesToSpawn;
    public Entity ParticlePrefab;
}
