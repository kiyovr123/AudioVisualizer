using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CubeController : MonoBehaviour
{
	[SerializeField]
	private float _Rot = 45;

	public float _Value;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
		this.transform.Rotate(_Value,45,_Value); 
    }
}
