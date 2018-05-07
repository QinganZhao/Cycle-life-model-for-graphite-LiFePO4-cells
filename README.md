<div align=center>
 
# Cycle-life-model-for-graphite-LiFePO4-cells

[**Franklin Zhao**](http://franklinzhao.top), **Junzhe shi, Ruitong Zhu, and Xin Peng**

May 2018

<div align=left>

Batteries are ubiquitous in all forms of electronics and transportation, and a key to the store of clean and secure energy. For different kinds of batteries,  Li-ion battery is the most prominent one for their superior gravimetric and volumetric energy density.  For the safe operation of Li-ion battery, the state of charge (SOC) and state of health (SOH) estimation are of great significance. Hence, the goal of the project is to design a robust observer which can estimate the SOC and SOH of Li-ion batteries. In the project, the equivalent-circuit model is used for the battery modeling with current and ambient temperature as inputs and voltage as the measured output. The equivalent-circuit model includes three parts which are an electrical model, a thermal model, and an aging model. To ensure the accuracy of states estimation, the Extend Kalman Filter (EKF) is applied and examined in the project. The battery system is constructed and simulated using MATLAB. The best observer built in this project is a Voltage-Temperature (VT) observer which can accurately observe SOC with great robustness, while SOH can be observed using open-loop observer. The robustness of designed observer is tested using the wrong initial estimates and wrong model parameters.
