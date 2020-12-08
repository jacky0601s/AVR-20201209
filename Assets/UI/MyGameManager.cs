using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;
using UnityEngine.SceneManagement;
using Vuforia;

public class MyGameManager : MonoBehaviour
{
    public bool VRMode = false;

    void Start()
    {
        if (VRMode)
        {
            StartCoroutine(StartVR());
        }
        else
        {
            StartCoroutine(StopVR());
        }

        CameraDevice.Instance.SetFocusMode
       (CameraDevice.FocusMode.FOCUS_MODE_CONTINUOUSAUTO);
    }

    void Update()
    {

    }

    public void ToggleVR()
    {
        if (XRSettings.loadedDeviceName != "cardboard")
        {
            StartCoroutine(StartVR());
        }
        else
        {
            StartCoroutine(StopVR());
        }
    }

    IEnumerator StopVR()
    {
        XRSettings.LoadDeviceByName("none");
        yield return null;
        XRSettings.enabled = false;
    }

    IEnumerator StartVR()
    {
        XRSettings.LoadDeviceByName("cardboard");
        yield return null;
        XRSettings.enabled = true;
    }

    public void GoToScene(string name)
    {
        StartCoroutine(GoToSceneWithDelay(1.0f, name));
    }

    IEnumerator GoToSceneWithDelay(float delay, string name)
    {
        yield return new WaitForSeconds(delay);
        SceneManager.LoadScene(name);
    }
}
