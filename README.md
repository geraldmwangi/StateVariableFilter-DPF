# StateVariableFilter-DPF
 Implementation of the State Variable Filter in the book DAFX by Udo Zölzer
 Compilation:

 Run:
 git submodule init
 git submodule update
 make

 in the toplevel directory. A subdirectory called bin is created containing an lv2, vst and standalone version of the plugin
 Usage:
 Load the plugin in your favourite host, or from the commandline:
 jalv.qt5 https://github.com/geraldmwangi/StateVariableFilter-DPF
 You have 3 outputs: highpass, bandpass and lowpass
 the parameter CutOff is the cutoff frequency at which the filters kick-in
 The Damping factor sets the slope at the cutoff frequency. Note: when set to 0 the filters resonate and it gets LOUD!
 Treat with caution!
