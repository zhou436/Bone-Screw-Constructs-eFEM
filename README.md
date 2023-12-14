# pullOutSimulation

The code was generate for voxel-to-element mesh, especially for screw bone construct stability evaluation. We provided several example data. To access more, please search 

Zhou, Y., Steiner, J. A., Affentranger, R., Persson, C., Ferguson, S. J., van Lenthe, H., & Helgason, B. (2023). Trabecular bone – screw interaction. Micro-CT models and experimental push-in results. (v1.0) [Data set]. Zenodo. https://doi.org/10.5281/zenodo.8405457

If you want to use the code, please cite:
Zhou, Y., Helgason, B., Ferguson, S. J., Persson, C. (2023). Validated, high-resolution, non-linear, explicit finite element models for simulating screw - bone interaction.

## Environment
* MATLAB
* ABAQUS (works on 2020/2021, other versions were not tested)

## Example model
<p align="center">
    <img src="Figs/screwBoneMesh.png" width="480"> <br />
    <em> The generated bone-screw construct and boundary conditions. </em> <br />
    <img src="Figs/screwBoneMeshDel.png" width="480"> <br />
    <em> The illustration of element digital deletion. </em> <br />
    <img src="Figs/stressStrainCurve.png" width="480"> <br />
    <em> The illustration of material model CDP. </em>
</p>

## Future aspect
* Besides ABAQUS keywords file, we also plan to generate LS-DYNA keywords file
* 

## Acknowledegement
Some of the ideas of early versions were generate from: Jiexian Ma (2023). voxelMesh (voxel-based mesh) (https://www.mathworks.com/matlabcentral/fileexchange/104720-voxelmesh-voxel-based-mesh), MATLAB Central File Exchange. Retrieved December 13, 2023.
Thanks to his contribution, mainly in the voxel to element part. The code was later optimized by converting loop to matrix calculation. It requires more memory, but more efficient by large model generation.