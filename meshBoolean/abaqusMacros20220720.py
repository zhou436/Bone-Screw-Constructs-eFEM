# -*- coding: mbcs -*-
# Do not delete the following import lines
from abaqus import *
from abaqusConstants import *
import __main__


import section
import regionToolset
import displayGroupMdbToolset as dgm
import part
import material
import assembly
import step
import interaction
import load
import mesh
import optimization
import job
import sketch
import visualization
import xyPlot
import displayGroupOdbToolset as dgo
import connectorBehavior
import os
#os.chdir(r"C:\Users\zyj19\Desktop\AbaqusScript\contiOpti")
mdb.models.changeKey(fromName='Model-1', toName='contiOpti')
s = mdb.models['contiOpti'].ConstrainedSketch(name='__profile__', 
    sheetSize=20.0)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)
s.CircleByCenterPerimeter(center=(0.0, 0.0), point1=(0.0, 2.0))
p = mdb.models['contiOpti'].Part(name='Screw', dimensionality=THREE_D, 
    type=DEFORMABLE_BODY)
p = mdb.models['contiOpti'].parts['Screw']
p.BaseSolidExtrude(sketch=s, depth=10.0)
s.unsetPrimaryObject()
p = mdb.models['contiOpti'].parts['Screw']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
del mdb.models['contiOpti'].sketches['__profile__']
p = mdb.models['contiOpti'].parts['Screw']
e = p.edges
p.Chamfer(length=1.9, edgeList=(e[1], ))
p = mdb.models['contiOpti'].parts['Screw']
p.DatumPlaneByPrincipalPlane(principalPlane=XZPLANE, offset=0.0)
p = mdb.models['contiOpti'].parts['Screw']
e1, d1 = p.edges, p.datums
t = p.MakeSketchTransform(sketchPlane=d1[3], sketchUpEdge=e1[2], 
    sketchPlaneSide=SIDE1, sketchOrientation=TOP, origin=(0.0, 0.0, 5.0))
s1 = mdb.models['contiOpti'].ConstrainedSketch(name='__profile__', 
    sheetSize=22.71, gridSpacing=0.56, transform=t)
g, v, d, c = s1.geometry, s1.vertices, s1.dimensions, s1.constraints
s1.setPrimaryObject(option=SUPERIMPOSE)
p = mdb.models['contiOpti'].parts['Screw']
p.projectReferencesOntoSketch(sketch=s1, filter=COPLANAR_EDGES)
# thread shape #########################################################
s1.Line(point1=(-2.0, -5.0), point2=(-0.95, -5.2))
s1.Line(point1=(-0.95, -5.2), point2=(-0.95, -6.7))
s1.VerticalConstraint(entity=g[3], addUndoState=False)
s1.Line(point1=(-0.95, -6.7), point2=(-2.0, -6.7))
s1.HorizontalConstraint(entity=g[4], addUndoState=False)
s1.PerpendicularConstraint(entity1=g[3], entity2=g[4], addUndoState=False)
s1.Line(point1=(-2.0, -6.7), point2=(-2.0, -5.0))
s1.VerticalConstraint(entity=g[5], addUndoState=False)
s1.PerpendicularConstraint(entity1=g[4], entity2=g[5], addUndoState=False)
# thread shape end #########################################################
s1.ConstructionLine(point1=(0.0, 2.0), point2=(0.0, 0.0))
s1.VerticalConstraint(entity=g[6], addUndoState=False)
p = mdb.models['contiOpti'].parts['Screw']
e, d2 = p.edges, p.datums
p.CutRevolve(sketchPlane=d2[3], sketchUpEdge=e[2], sketchPlaneSide=SIDE1, 
    sketchOrientation=TOP, sketch=s1, angle=5400.0, 
    flipRevolveDirection=OFF, pitch=1.75, flipPitchDirection=ON, 
    moveSketchNormalToPath=OFF)
s1.unsetPrimaryObject()
del mdb.models['contiOpti'].sketches['__profile__']
s = mdb.models['contiOpti'].ConstrainedSketch(name='__profile__', 
    sheetSize=20.0)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)
s.rectangle(point1=(-5.0, -5.0), point2=(5.0, 5.0))
p = mdb.models['contiOpti'].Part(name='Cube', dimensionality=THREE_D, 
    type=DEFORMABLE_BODY)
p = mdb.models['contiOpti'].parts['Cube']
p.BaseSolidExtrude(sketch=s, depth=10.0)
s.unsetPrimaryObject()
p = mdb.models['contiOpti'].parts['Cube']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
del mdb.models['contiOpti'].sketches['__profile__']
a = mdb.models['contiOpti'].rootAssembly
a = mdb.models['contiOpti'].rootAssembly
a.DatumCsysByDefault(CARTESIAN)

a = mdb.models['contiOpti'].rootAssembly
a1 = mdb.models['contiOpti'].rootAssembly
p = mdb.models['contiOpti'].parts['Cube']
a1.Instance(name='Cube-1', part=p, dependent=OFF)
p = mdb.models['contiOpti'].parts['Screw']
a1.Instance(name='Screw-1', part=p, dependent=OFF)
a1 = mdb.models['contiOpti'].rootAssembly
a1.translate(instanceList=('Screw-1', ), vector=(0.0, 0.0, 1.0))
a1 = mdb.models['contiOpti'].rootAssembly
## Do Boolean operation for cube
# a1.InstanceFromBooleanCut(name='CubeBoolean', 
    # instanceToBeCut=mdb.models['contiOpti'].rootAssembly.instances['Cube-1'], 
    # cuttingInstances=(a1.instances['Screw-1'], ), 
    # originalInstances=SUPPRESS)
# a1 = mdb.models['contiOpti'].rootAssembly
# p = mdb.models['contiOpti'].parts['Screw']
# a1.Instance(name='Screw-2', part=p, dependent=OFF)
# a1 = mdb.models['contiOpti'].rootAssembly
# a1.translate(instanceList=('Screw-2', ), vector=(0.0, 0.0, 1.0))
# p = mdb.models['contiOpti'].parts['Cube']
# mdb.models['contiOpti'].Material(name='Bone')
# mdb.models['contiOpti'].materials['Bone'].Elastic(table=((300.0, 0.3), ))
# mdb.models['contiOpti'].materials['Bone'].Density(table=((1.98e-09, ), ))
# mdb.models['contiOpti'].materials['Bone'].Plastic(table=((2.0, 0.0), (4.0, 0.5)))
# mdb.models['contiOpti'].materials['Bone'].DuctileDamageInitiation(table=((0.15, 0.0, 0.0), ))
# mdb.models['contiOpti'].materials['Bone'].ductileDamageInitiation.DamageEvolution(type=DISPLACEMENT, table=((0.01, ), ))
# mdb.models['contiOpti'].Material(name='Screw')
# mdb.models['contiOpti'].materials['Screw'].Elastic(table=((120000.0, 0.3), ))
# mdb.models['contiOpti'].materials['Screw'].Density(table=((3.14e-09, ), ))
# mdb.models['contiOpti'].HomogeneousSolidSection(name='Bone', material='Bone', 
    # thickness=None)
# mdb.models['contiOpti'].HomogeneousSolidSection(name='Screw', material='Screw', 
    # thickness=None)
# p = mdb.models['contiOpti'].parts['CubeBoolean']
# p = mdb.models['contiOpti'].parts['CubeBoolean']
# c = p.cells
# cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
# region = regionToolset.Region(cells=cells)
# p = mdb.models['contiOpti'].parts['CubeBoolean']
# p.SectionAssignment(region=region, sectionName='Bone', offset=0.0, 
    # offsetType=MIDDLE_SURFACE, offsetField='', 
    # thicknessAssignment=FROM_SECTION)
# p = mdb.models['contiOpti'].parts['Screw']
# p = mdb.models['contiOpti'].parts['Screw']
# c = p.cells
# cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
# region = regionToolset.Region(cells=cells)
# p = mdb.models['contiOpti'].parts['Screw']
# p.SectionAssignment(region=region, sectionName='Screw', offset=0.0, 
    # offsetType=MIDDLE_SURFACE, offsetField='', 
    # thicknessAssignment=FROM_SECTION)
# a1 = mdb.models['contiOpti'].rootAssembly
# a1.regenerate()
# a = mdb.models['contiOpti'].rootAssembly
# mdb.models['contiOpti'].ExplicitDynamicsStep(name='Step-1', previous='Initial', 
    # massScaling=((SEMI_AUTOMATIC, MODEL, AT_BEGINNING, 0.0, 5e-05, 
    # BELOW_MIN, 0, 0, 0.0, 0.0, 0, None), ), improvedDtMethod=ON)
# mdb.models['contiOpti'].fieldOutputRequests['F-Output-1'].setValues(variables=(
    # 'S', 'SVAVG', 'PE', 'PEVAVG', 'PEEQ', 'PEEQVAVG', 'LE', 'U', 'V', 'A', 
    # 'RF', 'CSTRESS', 'DAMAGEC', 'DAMAGET', 'DAMAGEMT', 'DAMAGEMC', 
    # 'DAMAGESHR', 'EVF', 'SDV', 'ESDV', 'FV', 'MFR', 'UVARM', 'EMSF', 
    # 'DENSITY', 'DENSITYVAVG', 'STATUS', 'EACTIVE', 'RHOE', 'RHOP', 'BURNF', 
    # 'DBURNF', 'TIEDSTATUS', 'TIEADJUST'))
# # a = mdb.models['contiOpti'].rootAssembly
# # f1 = a.instances['Screw-2'].faces
# # faces1 = f1.getSequenceFromMask(mask=('[#1000000 ]', ), )
# # a.Set(faces=faces1, name='ScrewTop')
# # regionDef=mdb.models['contiOpti'].rootAssembly.sets['ScrewTop']
# # mdb.models['contiOpti'].HistoryOutputRequest(name='H-Output-2', 
    # # createStepName='Step-1', variables=('U1', 'U2', 'U3', 'RF3'), 
    # # region=regionDef, sectionPoints=DEFAULT, rebar=EXCLUDE)
# mdb.models['contiOpti'].ContactProperty('IntProp-1')
# mdb.models['contiOpti'].interactionProperties['IntProp-1'].TangentialBehavior(
    # formulation=PENALTY, directionality=ISOTROPIC, slipRateDependency=OFF, 
    # pressureDependency=OFF, temperatureDependency=OFF, dependencies=0, 
    # table=((0.3, ), ), shearStressLimit=None, maximumElasticSlip=FRACTION, 
    # fraction=0.005, elasticSlipStiffness=None)
# mdb.models['contiOpti'].interactionProperties['IntProp-1'].NormalBehavior(
    # pressureOverclosure=HARD, allowSeparation=ON, 
    # constraintEnforcementMethod=DEFAULT)
# mdb.models['contiOpti'].ContactExp(name='Int-1', createStepName='Initial')
# mdb.models['contiOpti'].interactions['Int-1'].includedPairs.setValuesInStep(
    # stepName='Initial', useAllstar=ON)
# mdb.models['contiOpti'].interactions['Int-1'].contactPropertyAssignments.appendInStep(
    # stepName='Initial', assignments=((GLOBAL, SELF, 'IntProp-1'), ))
# mdb.models['contiOpti'].SmoothStepAmplitude(name='Amp-1', timeSpan=STEP, data=(
    # (0.0, 0.0), (1.0, 1.0)))
# # a = mdb.models['contiOpti'].rootAssembly
# a = mdb.models['contiOpti'].rootAssembly
# f1 = a.instances['Screw-2'].faces
# faces1 = f1.getSequenceFromMask(mask=('[#1000000 ]', ), )
# a.Set(faces=faces1, name='ScrewTop')
# a = mdb.models['contiOpti'].rootAssembly
# e1 = a.instances['Screw-2'].edges
# a.ReferencePoint(point=a.instances['Screw-2'].InterestingPoint(edge=e1[73], 
    # rule=CENTER))
# a = mdb.models['contiOpti'].rootAssembly
# f1 = a.instances['Screw-2'].faces
# faces1 = f1.getSequenceFromMask(mask=('[#1000000 ]', ), )
# region4=regionToolset.Region(faces=faces1)
# a = mdb.models['contiOpti'].rootAssembly
# r1 = a.referencePoints
# refPoints1=(r1[11], )
# region1=regionToolset.Region(referencePoints=refPoints1)
# mdb.models['contiOpti'].RigidBody(name='Constraint-1', refPointRegion=region1, 
    # tieRegion=region4)
# a = mdb.models['contiOpti'].rootAssembly
# r1 = a.referencePoints
# refPoints1=(r1[11], )
# a.Set(referencePoints=refPoints1, name='ScrewTopRef')
# regionDef=mdb.models['contiOpti'].rootAssembly.sets['ScrewTopRef']
# mdb.models['contiOpti'].HistoryOutputRequest(name='H-Output-2', 
    # createStepName='Step-1', variables=('U3', 'UR3', 'RF3'), 
    # region=regionDef, sectionPoints=DEFAULT, rebar=EXCLUDE)
# session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=ON, bcs=ON, 
    # predefinedFields=ON, connectors=ON, adaptiveMeshConstraints=OFF)
# session.viewports['Viewport: 1'].assemblyDisplay.setValues(step='Step-1')
# a = mdb.models['contiOpti'].rootAssembly
# region = a.sets['ScrewTopRef']
# mdb.models['contiOpti'].DisplacementBC(name='BC-1', createStepName='Step-1', 
    # region=region, u1=UNSET, u2=UNSET, u3=2.5, ur1=UNSET, ur2=UNSET, 
    # ur3=UNSET, amplitude='Amp-1', fixed=OFF, distributionType=UNIFORM, 
    # fieldName='', localCsys=None)
# a = mdb.models['contiOpti'].rootAssembly
# f1 = a.instances['CubeBoolean-1'].faces
# faces1 = f1.getSequenceFromMask(mask=('[#20000000 ]', ), )
# region = regionToolset.Region(faces=faces1)
# mdb.models['contiOpti'].DisplacementBC(name='BC-2', createStepName='Step-1', 
    # region=region, u1=0.0, u2=0.0, u3=0.0, ur1=0.0, ur2=0.0, ur3=0.0, 
    # amplitude='Amp-1', fixed=OFF, distributionType=UNIFORM, fieldName='', 
    # localCsys=None)
# session.viewports['Viewport: 1'].assemblyDisplay.setValues(loads=OFF, bcs=OFF, 
    # predefinedFields=OFF, connectors=OFF)


# a1 = mdb.models['contiOpti'].rootAssembly
# a1.makeIndependent(instances=(a1.instances['CubeBoolean-1'], ))
# a = mdb.models['contiOpti'].rootAssembly
# partInstances =(a.instances['Screw-2'], )
# a.seedPartInstance(regions=partInstances, size=0.25, deviationFactor=0.1, 
    # minSizeFactor=0.1)
# a = mdb.models['contiOpti'].rootAssembly
# partInstances =(a.instances['CubeBoolean-1'], )
# a.seedPartInstance(regions=partInstances, size=0.5, deviationFactor=0.1, 
    # minSizeFactor=0.1)
# a = mdb.models['contiOpti'].rootAssembly
# c1 = a.instances['Screw-2'].cells
# cells1 = c1.getSequenceFromMask(mask=('[#1 ]', ), )
# c2 = a.instances['CubeBoolean-1'].cells
# cells2 = c2.getSequenceFromMask(mask=('[#1 ]', ), )
# pickedRegions = cells1+cells2
# a.setMeshControls(regions=pickedRegions, elemShape=TET, technique=FREE)
# elemType1 = mesh.ElemType(elemCode=UNKNOWN_HEX, elemLibrary=EXPLICIT)
# elemType2 = mesh.ElemType(elemCode=UNKNOWN_WEDGE, elemLibrary=EXPLICIT)
# elemType3 = mesh.ElemType(elemCode=C3D10M, elemLibrary=EXPLICIT)
# a = mdb.models['contiOpti'].rootAssembly
# c1 = a.instances['Screw-2'].cells
# cells1 = c1.getSequenceFromMask(mask=('[#1 ]', ), )
# c2 = a.instances['CubeBoolean-1'].cells
# cells2 = c2.getSequenceFromMask(mask=('[#1 ]', ), )
# cells = cells1+cells2
# pickedRegions =(cells, )
# a.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    # elemType3))
# a = mdb.models['contiOpti'].rootAssembly
# partInstances =(a.instances['CubeBoolean-1'], a.instances['Screw-2'], )
# a.generateMesh(regions=partInstances)
# elemType1 = mesh.ElemType(elemCode=UNKNOWN_HEX, elemLibrary=EXPLICIT)
# elemType2 = mesh.ElemType(elemCode=UNKNOWN_WEDGE, elemLibrary=EXPLICIT)
# elemType3 = mesh.ElemType(elemCode=C3D10, elemLibrary=EXPLICIT, 
    # secondOrderAccuracy=ON, distortionControl=ON, 
    # lengthRatio=0.10, elemDeletion=ON, maxDegradation=0.9)
# a = mdb.models['contiOpti'].rootAssembly
# c1 = a.instances['CubeBoolean-1'].cells
# cells1 = c1.getSequenceFromMask(mask=('[#1 ]', ), )
# c2 = a.instances['Screw-2'].cells
# cells2 = c2.getSequenceFromMask(mask=('[#1 ]', ), )
# pickedRegions =((cells1+cells2), )
# a.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, 
    # elemType3))
# session.viewports['Viewport: 1'].assemblyDisplay.setValues(mesh=OFF)
# session.viewports['Viewport: 1'].assemblyDisplay.meshOptions.setValues(
    # meshTechnique=OFF)
# mdb.Job(name='Job-1', model='contiOpti', description='', type=ANALYSIS, 
    # atTime=None, waitMinutes=0, waitHours=0, queue=None, memory=90, 
    # memoryUnits=PERCENTAGE, explicitPrecision=DOUBLE_PLUS_PACK, 
    # nodalOutputPrecision=SINGLE, echoPrint=OFF, modelPrint=OFF, 
    # contactPrint=OFF, historyPrint=OFF, userSubroutine='', scratch='', 
    # resultsFormat=ODB, parallelizationMethodExplicit=DOMAIN, numDomains=20, 
    # activateLoadBalancing=False, multiprocessingMode=DEFAULT, numCpus=20)
# # mdb.saveAs(pathName='contiOpti20220720')
# mdb.jobs['Job-1'].submit(consistencyChecking=OFF)


