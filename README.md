# Convex-Cone-Approach
The code for Blood Oxygenation Quantification in Multispectral Photoacoustic Tomography Using A Convex Cone Approach

The main code for Convex cone (CC) method in simulation, phantom, and human experiments. The code is entirely based on MATLAB. If running the program, it is necessary to modify the root directory.

Due to limitations of size, the original photoacoustic data and digital phantoms used to generate cones are not included in the package. Most of them only contain the extracted photoacoustic spectra of the positions of interest and the generated cones.

Toolbox: All functions of the CC method, where convexConeSO2_ Noise and convexConeSO2_ Bayes are main function.

Substance_spectra: absorption spectra of various substances

Simulation: Simulation data, programs, and results

Phantom_experiment: Data, Procedures, and Results of Biomimetic Experiments

Human_experiment: Human experimental data, procedures, and results

If you only want to see the result, please run the .m files that start with 'Figure'. The .m files end with 'experiment' utilize the CC method to get the result .mat file.

If more detailed data is needed, further communication can be made through email wuch22@mails.tsinghua.edu.cn.
