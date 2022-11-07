# -*- coding: mbcs -*-
# Do not delete the following import lines
from abaqus import *
from abaqusConstants import *
import __main__
import numpy as np

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
odb = session.openOdb(
        name='printInpTemp.odb')
xy_result = session.XYDataFromHistory(
    name='RF3 PI: rootAssembly N: 1 NSET SCREWTOPREF-1', odb=odb, 
    outputVariableName='Reaction force: RF3 PI: rootAssembly Node 1 in NSET SCREWTOPREF', 
    steps=('Step-1', ), __linkedVpName__='Viewport: 1')
# c1 = session.Curve(xyData=xy_result)
# xyp = session.xyPlots['XYPlot-1']
# chartName = xyp.charts.keys()[0]
# chart = xyp.charts[chartName]
# chart.setValues(curvesToPlot=(c1, ), )
# session.charts[chartName].autoColor(lines=True, symbols=True)
# session.viewports['Viewport: 1'].setValues(displayedObject=xyp)
# x0 = session.xyDataObjects['XYData-1']
session.writeXYReport(fileName='Force.csv', xyData=(xy_result, ))
xy_result = session.XYDataFromHistory(
    name='U3 PI: rootAssembly N: 1 NSET SCREWTOPREF-1', odb=odb, 
    outputVariableName='Spatial displacement: U3 PI: rootAssembly Node 1 in NSET SCREWTOPREF', 
    steps=('Step-1', ), __linkedVpName__='Viewport: 1')
session.writeXYReport(fileName='Displacement.csv', xyData=(xy_result, ))
# setValues(xy_result)
# np.savetxt('test.txt',c1)
# np.savetxt('test2.txt',xy_result)
xy_result = session.XYDataFromHistory(
    name='UR3 PI: rootAssembly N: 1 NSET SCREWTOPREF-1', odb=odb, 
    outputVariableName='Rotational displacement: UR3 PI: rootAssembly Node 1 in NSET SCREWTOPREF', 
    steps=('Step-1', ), __linkedVpName__='Viewport: 1')
session.writeXYReport(fileName='Rotation.csv', xyData=(xy_result, ))