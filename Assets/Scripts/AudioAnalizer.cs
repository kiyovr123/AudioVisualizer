using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioAnalizer : MonoBehaviour
{
	[SerializeField]
	private AudioClip[] _AudioClip;
	[SerializeField]
	private float _Power;
	[SerializeField]
	private Material _Mat;
	[SerializeField]
	private float _N;

	private float[] _Spectrum;
	private AudioSource _AudioSource;

	void Start()
	{
		_AudioSource = GetComponent<AudioSource>();
		_Spectrum = new float[256];
	}

	void Update()
	{
		AnalizeAudioSource();
	}

	public void AnalizeAudioSource()
	{
		_Power = 0;
		_AudioSource.GetSpectrumData(_Spectrum, 0, FFTWindow.Hamming);

		for (int i = 0; i < 256; i++)
		{
			_Power += _Spectrum[i];
		}
		_Mat.SetFloat("_Scale", _Power * _N);
		_Mat.SetFloat("_Power",Mathf.Pow(_Power,2));
	}
}
