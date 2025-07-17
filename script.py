# -*- coding: utf-8 -*-
"""
__title__  = PlaceCube
__author__ = Amir
__doc__    = Finds first .rfa in this folder, loads & places it at 0,0,0 and zooms to it
"""

import os
import clr
clr.AddReference("RevitAPI")
clr.AddReference("RevitAPIUI")

from Autodesk.Revit.DB import Transaction, IFamilyLoadOptions, XYZ
from pyrevit import revit

doc   = revit.doc
uidoc = revit.uidoc

# 1. locate any .rfa in this script folder
here   = os.path.dirname(__file__)
files  = [f for f in os.listdir(here) if f.lower().endswith(".rfa")]
if not files:
    raise Exception("No RFA file found in " + here)
cube_rfa = os.path.join(here, files[0])

# 2. load family (overwrite if already loaded)
class LoadOpts(IFamilyLoadOptions):
    def OnFamilyFound(self, familyInUse, overwriteParameterValues): return True
    def OnSharedFamilyFound(self, sharedFamily, familyInUse, source): return True

success, family = doc.LoadFamily(cube_rfa, LoadOpts())
if not success:
    raise Exception("Failed to load " + cube_rfa)

# 3. get first symbol and ensure it’s active
symbol_id = next(iter(family.GetFamilySymbolIds()))
symbol    = doc.GetElement(symbol_id)
if not symbol.IsActive:
    t0 = Transaction(doc, "Activate Symbol")
    t0.Start()
    symbol.Activate()
    doc.Regenerate()
    t0.Commit()

# 4. place instance at origin
t1 = Transaction(doc, "Place Cube")
t1.Start()
instance = doc.Create.NewFamilyInstance(
    XYZ(0,0,0),
    symbol,
    doc.ActiveView
)
t1.Commit()

# 5. zoom to it
uidoc.ShowElements(instance)
