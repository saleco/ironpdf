#!/usr/bin/env python
import os
import sys 
sys.prefix = "/var/task"

from ironpdf import *

License.LicenseKey = "IRONPDFXXXXXXX"
Logger.EnableDebugging = True
Logger.LogFilePath = "Custom.log"
Logger.LoggingMode = Logger.LoggingModes.All

dir = os.getcwd()
sourceFile = f"{dir}/sample.pdf"
targetFile = f"{dir}/sample_converted.pdf"
print("Starting conversion")
pdf = PdfDocument.FromFile(sourceFile)
pdf.SaveAsPdfA(targetFile, PdfAVersions.PdfA3b)
print("End conversion") 