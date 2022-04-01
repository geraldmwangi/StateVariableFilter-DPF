#include "statevariablefilter.h"
#include <math.h>
START_NAMESPACE_DISTRHO
StateVariableFilter::StateVariableFilter():
    Plugin(2, 0, 0)
{

    m_delayIn=0.0;
    m_delayHigh=0.0;
    m_delayBand=0.0;
    m_delayLow=0.0;
    m_cutoff=1000.0;
    m_damp=1.0;
}

void StateVariableFilter::initParameter(uint32_t index, Parameter &parameter)
{

    if(index==0)
    {
        parameter.name="CutOff";
        parameter.ranges.min=1;
        parameter.ranges.max=4500.0;
        parameter.unit="Hz";
        parameter.ranges.def=m_cutoff;
    }
    else if(index==1)
    {
        parameter.name="Damping Factor";
        parameter.ranges.min=0;
        parameter.ranges.max=1.0;
        parameter.unit="";
        parameter.ranges.def=m_damp;
    }


}

float StateVariableFilter::getParameterValue(uint32_t index) const
{
    if(index==0)
        return m_cutoff;
    else
        return m_damp;
}

void StateVariableFilter::setParameterValue(uint32_t index, float value)
{
    if(index==0)
    {
        m_cutoff=value;
        m_F=2.0*sin(M_PI*m_cutoff/getSampleRate());
    }
    else
        m_damp=value;
}

void StateVariableFilter::run(const float **inputs, float **outputs, uint32_t frames)
{
    const float *inbuf=inputs[0];
    float* highpass=outputs[0];
    float* bandpass=outputs[1];
    float* lowpass=outputs[2];
    float Q=2.0*m_damp;
    highpass[0]=inbuf[0]-m_delayLow-Q*m_delayBand;
    bandpass[0]=m_F*highpass[0]+m_delayBand;
    lowpass[0]=m_F*bandpass[0]+m_delayLow;

    for(int i=1;i<frames;i++)
    {
        highpass[i]=inbuf[i]-lowpass[i-1]-Q*bandpass[i-1];
        bandpass[i]=m_F*highpass[i]+bandpass[i-1];
        lowpass[i]=m_F*bandpass[i]+lowpass[i-1];
    }

    m_delayHigh=highpass[frames-1];
    m_delayBand=bandpass[frames-1];
    m_delayLow=lowpass[frames-1];




}
Plugin* createPlugin()
{
    return new StateVariableFilter();
}
END_NAMESPACE_DISTRHO
