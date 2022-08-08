# -*- coding: mbcs -*-
#
# Abaqus/CAE Release 2020 replay file
# Internal Version: 2019_09_13-19.49.31 163176
# Run by zyj19 on Mon Aug  8 08:07:09 2022
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=168.440612792969, 
    height=127.548141479492)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from caeModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=ON)
execfile('abaqusMacros20220720.py', __main__.__dict__)
p = mdb.models['contiOpti'].parts['Cube']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
session.viewports['Viewport: 1'].partDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].partDisplay.meshOptions.setValues(
    meshTechnique=ON)
session.viewports['Viewport: 1'].partDisplay.geometryOptions.setValues(
    referenceRepresentation=OFF)
a = mdb.models['contiOpti'].rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=a)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON, 
    optimizationTasks=OFF, geometricRestrictions=OFF, stopConditions=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
a = mdb.models['contiOpti'].rootAssembly
partInstances =(a.instances['Cube-1'], )
a.seedPartInstance(regions=partInstances, size=1.0, deviationFactor=0.1, 
    minSizeFactor=0.1)
a = mdb.models['contiOpti'].rootAssembly
partInstances =(a.instances['Screw-1'], )
a.seedPartInstance(regions=partInstances, size=0.25, deviationFactor=0.1, 
    minSizeFactor=0.1)
a = mdb.models['contiOpti'].rootAssembly
c1 = a.instances['Screw-1'].cells
pickedRegions = c1.getSequenceFromMask(mask=('[#1 ]', ), )
a.setMeshControls(regions=pickedRegions, elemShape=TET, technique=FREE)
elemType1 = mesh.ElemType(elemCode=C3D20R)
elemType2 = mesh.ElemType(elemCode=C3D15)
elemType3 = mesh.ElemType(elemCode=C3D10)
a = mdb.models['contiOpti'].rootAssembly
c1 = a.instances['Screw-1'].cells
cells = c1.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(cells, )
a.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
a = mdb.models['contiOpti'].rootAssembly
partInstances =(a.instances['Cube-1'], a.instances['Screw-1'], )
a.generateMesh(regions=partInstances)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=ON)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=ON)
elemType1 = mesh.ElemType(elemCode=UNKNOWN_HEX, elemLibrary=EXPLICIT)
elemType2 = mesh.ElemType(elemCode=UNKNOWN_WEDGE, elemLibrary=EXPLICIT)
elemType3 = mesh.ElemType(elemCode=C3D10M, elemLibrary=EXPLICIT, 
    secondOrderAccuracy=OFF, distortionControl=ON, 
    lengthRatio=0.100000001490116)
a = mdb.models['contiOpti'].rootAssembly
c1 = a.instances['Screw-1'].cells
cells1 = c1.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(cells1, )
a.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
elemType1 = mesh.ElemType(elemCode=C3D8, elemLibrary=EXPLICIT, 
    secondOrderAccuracy=OFF, distortionControl=ON, 
    lengthRatio=0.100000001490116, elemDeletion=ON, maxDegradation=0.9)
elemType2 = mesh.ElemType(elemCode=C3D6, elemLibrary=EXPLICIT)
elemType3 = mesh.ElemType(elemCode=C3D4, elemLibrary=EXPLICIT)
a = mdb.models['contiOpti'].rootAssembly
c1 = a.instances['Cube-1'].cells
cells1 = c1.getSequenceFromMask(mask=('[#1 ]', ), )
pickedRegions =(cells1, )
a.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    elemType3))
session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    meshTechnique=OFF)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    adaptiveMeshConstraints=ON)
mdb.models['contiOpti'].ExplicitDynamicsStep(name='Step-1', previous='Initial', 
    improvedDtMethod=ON)
session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='Step-1')
session.viewports['Viewport: 1'].assemblyDisplay.setValues(
    adaptiveMeshConstraints=OFF)
mdb.Job(name='Job-1', model='contiOpti', description='', type=ANALYSIS, 
    atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, 
    memoryUnits=PERCENTAGE, explicitPrecision=DOUBLE_PLUS_PACK, 
    nodalOutputPrecision=SINGLE, echoPrint=OFF, modelPrint=OFF, 
    contactPrint=OFF, historyPrint=OFF, userSubroutine='', scratch='', 
    resultsFormat=ODB, parallelizationMethodExplicit=DOMAIN, numDomains=20, 
    activateLoadBalancing=False, multiprocessingMode=DEFAULT, numCpus=20)
mdb.jobs['Job-1'].writeInput(consistencyChecking=OFF)
#: The job input file has been written to "Job-1.inp".
