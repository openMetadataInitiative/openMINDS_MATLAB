classdef MRIScannerUsage < openminds.abstract.Schema
%MRIScannerUsage - No description available.
%
%   PROPERTIES:
%
%   MRIWeighting                 : (1,1) <a href="matlab:help openminds.controlledterms.MRIWeighting" style="font-weight:bold">MRIWeighting</a>
%                                  Add the magnetic resonance imaging weighting type describing the dominant source of image contrast. This designation reflects the contrast determined by repetition time, echo time, and inversion time and can be identified from the sequence protocol.
%
%   MTPulseShape                 : (1,1) <a href="matlab:help openminds.controlledterms.PulseShape" style="font-weight:bold">PulseShape</a>
%                                  Add the shape of the magnetization transfer (MT) radiofrequency (RF) pulse waveform used in this acquisition. This information is specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   accelerationFactor           : (1,1) int64
%                                  Enter the acceleration factor (R), defined as the ratio of fully sampled to reduced k-space acquisition, with R ≥ 1 and R = 1 indicating no acceleration. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   diffusionEncodingParameters  : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>
%                                  Add two diffusion encoding files: a b-value file specifying the diffusion weighting for each acquired volume and a b-vector file specifying the corresponding three-dimensional diffusion gradient directions. Ensure that both files are correctly ordered, that b-vectors are normalized, and that they are aligned with the image volumes.
%
%   dwellTime                    : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                                  Enter the dwell time, defined as the time interval between successive data samples during signal readout, which determines the receiver bandwidth and frequency resolution. This value is typically set automatically by the sequence and can be retrieved from the sequence protocol or DICOM header.
%
%   echoTime                     : (1,:) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                                  Enter the echo time (TE), defined as the interval between the center of the excitation pulse and the center of the measured echo, expressed in milliseconds. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   fatSuppressionTechnique      : (1,1) <a href="matlab:help openminds.controlledterms.MRIFatSuppressionTechnique" style="font-weight:bold">MRIFatSuppressionTechnique</a>
%                                  Add the fat suppression technique used for this acquisition (for example, fat saturation, SPAIR, STIR, or Dixon); if no fat suppression was applied, leave this field null. This information is typically specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   fieldOfView                  : (1,1)
%                                  Add the field of view of this image.
%
%   flipAngle                    : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                                  Enter the flip angle, defined as the angle by which the net magnetization is rotated by the radiofrequency excitation pulse, expressed in degrees. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   gradientCorrection           : (1,1) <a href="matlab:help openminds.controlledterms.AnalysisTechnique" style="font-weight:bold">AnalysisTechnique</a>
%                                  Add the gradient correction method applied during image reconstruction. This information is typically defined by the scanner system and can be retrieved from the reconstruction settings or DICOM header.
%
%   inversionTime                : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                                  Enter the inversion time (TI), defined as the interval between the inversion pulse and the excitation pulse, expressed in milliseconds. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   lookupLabel                  : (1,1) string
%                                  Enter a lookup label for this device usage that may help you to find this instance more easily.
%
%   matrixSize                   : (1,:) int64
%                                  Enter the matrix size as the number of samples in the frequency and phase encoding directions for two-dimensional acquisitions (frequency × phase), or in the frequency, phase, and partition encoding directions for three-dimensional acquisitions (frequency × phase × partitions). This information is defined by the acquisition protocol and can be retrieved from the DICOM header.
%
%   metadataLocation             : (1,:) <a href="matlab:help openminds.core.data.File" style="font-weight:bold">File</a>, <a href="matlab:help openminds.core.data.FileBundle" style="font-weight:bold">FileBundle</a>
%                                  Add all files or file bundles containing additional information about the usage of this device.
%
%   numberOfDiscardedVolumes     : (1,1) int64
%                                  Enter the number of initial volumes automatically discarded by the scanner before saving data, typically to allow signal stabilization at the beginning of the acquisition. This value is defined by the acquisition protocol and can be retrieved from the DICOM header.
%
%   numberOfExcitations          : (1,1) int64
%                                  Enter the number of excitations (NEX), defined as the number of times each k-space line is acquired and averaged to improve signal-to-noise ratio; if no averaging was performed, set this value to 1. This value is specified in the acquisition protocol and can be retrieved from the DICOM header.
%
%   numberOfSlices               : (1,1) int64
%                                  Enter the number of slices corresponding to the total number of two-dimensional image slices acquired in this scan. This value is defined by the acquisition protocol and can be retrieved from the DICOM header.
%
%   parallelAcquisitionTechnique : (1,1) <a href="matlab:help openminds.controlledterms.MRIParallelAcquisitionTechnique" style="font-weight:bold">MRIParallelAcquisitionTechnique</a>
%                                  Add the parallel acquisition technique used for this scan (for example, SENSE or GRAPPA). This information is specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   phaseEncodingDirection       : (1,:) int64
%                                  Enter the phase encoding direction as a signed unit vector in the scanner or image coordinate system (for example, [±1, 0, 0], [0, ±1, 0], or [0, 0, ±1]), where the nonzero component indicates the encoding axis and the sign specifies the polarity of k-space traversal.
%
%   receiverBandwidth            : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                                  Enter the receiver bandwidth, defined as the range of frequencies sampled per pixel during signal acquisition, expressed in hertz per pixel. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   repetitionTime               : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                                  Enter the repetition time (TR), defined as the interval between successive excitation pulses, expressed in milliseconds. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   sliceAngulation              : (1,:) double
%                                  Enter the slice plane orientation as a three-element unit normal vector [nx, ny, nz] in scanner coordinates, where each component is a dimensionless floating-point value between -1 and +1 and the vector has unit length (nx² + ny² + nz² = 1). For non-oblique acquisitions, the vector aligns with a principal axis (for example, [0, 0, 1]), and for oblique acquisitions, the components are fractional.
%
%   sliceGap                     : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                                  Enter the slice gap, defined as the distance between adjacent slices, expressed in millimeters and excluding the slice thickness; if slice spacing is uniform, provide a single value, and if it varies across the volume, provide the corresponding range. This information is specified in the acquisition protocol and can be retrieved from the DICOM header.
%
%   sliceOrientation             : (1,1) <a href="matlab:help openminds.controlledterms.AnatomicalPlane" style="font-weight:bold">AnatomicalPlane</a>
%                                  Add the primary slice plane, defined relative to the scanner coordinate system, where axial corresponds to planes perpendicular to the scanner z-axis, sagittal to planes perpendicular to the x-axis, and coronal to planes perpendicular to the y-axis. This classification is independent of subject orientation and may therefore differ from anatomical planes when the subject is positioned non-standardly in the scanner.
%
%   sliceThickness               : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                                  Enter the slice thickness, defined as the physical thickness of each acquired slice, expressed in millimeters; if uniform, provide a single value, and if variable, provide the corresponding range. This value is specified in the acquisition protocol and can be retrieved from the DICOM header.
%
%   sliceTiming                  : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueArray" style="font-weight:bold">QuantitativeValueArray</a>
%                                  Enter the slice timing, defined as the acquisition time of each slice within a volume relative to the start of the volume acquisition. This information is determined by the sequence timing and can be retrieved from the DICOM header.
%
%   spatialEncoding              : (1,1) <a href="matlab:help openminds.controlledterms.SpatialEncoding" style="font-weight:bold">SpatialEncoding</a>
%                                  Add the spatial encoding scheme used to acquire the data, specifying how frequency, phase, and partition encoding were applied (for example, frequency–phase encoding for two-dimensional acquisitions or frequency–phase–phase encoding for three-dimensional acquisitions). This information is defined in the sequence protocol and can be retrieved from the DICOM header.
%
%   spoilingTechnique            : (1,1) <a href="matlab:help openminds.controlledterms.MRISpoilingTechnique" style="font-weight:bold">MRISpoilingTechnique</a>
%                                  Add the spoiling technique used in this acquisition, specifying the method applied to eliminate residual transverse magnetization (for example, radiofrequency spoiling or gradient spoiling). This information is defined in the sequence protocol and can be retrieved from the DICOM header.
%
%   totalReadOutTime             : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                                  Enter the total readout time (TRT), defined as the time interval between acquisition of the first and last k-space lines in the phase-encoding direction during a single readout, expressed in milliseconds. This value is typically computed automatically and can be retrieved from the DICOM header.
%
%   transmitterBandwidth         : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>
%                                  Enter the transmitter bandwidth, defined as the frequency range excited by the radiofrequency pulse per pixel, expressed in hertz per pixel. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
%
%   usedCoils                    : (1,:) <a href="matlab:help openminds.controlledterms.DeviceType" style="font-weight:bold">DeviceType</a>, <a href="matlab:help openminds.neuroimaging.device.MRICoilUsage" style="font-weight:bold">MRICoilUsage</a>
%                                  Add all coils used for this acquisition, including built-in and external transmit, receive, and gradient-related coils, corresponding to the relevant DICOM coil attributes. Preferably provide structured coil descriptions; if unavailable, specify at least the device type.
%
%   usedSpecimen                 : (1,1) <a href="matlab:help openminds.core.research.SubjectState" style="font-weight:bold">SubjectState</a>, <a href="matlab:help openminds.core.research.TissueSampleState" style="font-weight:bold">TissueSampleState</a>
%                                  Add the state of the tissue sample or subject that this device was used on.
%
%   voxelSize                    : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueArray" style="font-weight:bold">QuantitativeValueArray</a>
%                                  Enter the voxel size as the physical dimensions of a single image voxel in the x, y, and z directions, expressed in millimeters. This value is typically derived from the field of view, matrix size, and slice thickness and can be retrieved from the DICOM header.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the magnetic resonance imaging weighting type describing the dominant source of image contrast. This designation reflects the contrast determined by repetition time, echo time, and inversion time and can be identified from the sequence protocol.
        MRIWeighting (1,:) openminds.controlledterms.MRIWeighting ...
            {mustBeScalarOrEmpty(MRIWeighting)}

        % Add the shape of the magnetization transfer (MT) radiofrequency (RF) pulse waveform used in this acquisition. This information is specified in the sequence protocol and can be retrieved from the DICOM header.
        MTPulseShape (1,:) openminds.controlledterms.PulseShape ...
            {mustBeScalarOrEmpty(MTPulseShape)}

        % Enter the acceleration factor (R), defined as the ratio of fully sampled to reduced k-space acquisition, with R ≥ 1 and R = 1 indicating no acceleration. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
        accelerationFactor (1,:) int64 ...
            {mustBeScalarOrEmpty(accelerationFactor), mustBeInteger(accelerationFactor), mustBeGreaterThanOrEqual(accelerationFactor, 1)}

        % Add two diffusion encoding files: a b-value file specifying the diffusion weighting for each acquired volume and a b-vector file specifying the corresponding three-dimensional diffusion gradient directions. Ensure that both files are correctly ordered, that b-vectors are normalized, and that they are aligned with the image volumes.
        diffusionEncodingParameters (1,:) openminds.core.data.File ...
            {mustBeMinLength(diffusionEncodingParameters, 2), mustBeMaxLength(diffusionEncodingParameters, 2)}

        % Enter the dwell time, defined as the time interval between successive data samples during signal readout, which determines the receiver bandwidth and frequency resolution. This value is typically set automatically by the sequence and can be retrieved from the sequence protocol or DICOM header.
        dwellTime (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeScalarOrEmpty(dwellTime)}

        % Enter the echo time (TE), defined as the interval between the center of the excitation pulse and the center of the measured echo, expressed in milliseconds. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
        echoTime (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeMinLength(echoTime, 1), mustBeListOfUniqueItems(echoTime)}

        % Add the fat suppression technique used for this acquisition (for example, fat saturation, SPAIR, STIR, or Dixon); if no fat suppression was applied, leave this field null. This information is typically specified in the sequence protocol and can be retrieved from the DICOM header.
        fatSuppressionTechnique (1,:) openminds.controlledterms.MRIFatSuppressionTechnique ...
            {mustBeScalarOrEmpty(fatSuppressionTechnique)}

        % Add the field of view of this image.
        fieldOfView (1,:)  ...
            {mustBeScalarOrEmpty(fieldOfView)}

        % Enter the flip angle, defined as the angle by which the net magnetization is rotated by the radiofrequency excitation pulse, expressed in degrees. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
        flipAngle (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeScalarOrEmpty(flipAngle)}

        % Add the gradient correction method applied during image reconstruction. This information is typically defined by the scanner system and can be retrieved from the reconstruction settings or DICOM header.
        gradientCorrection (1,:) openminds.controlledterms.AnalysisTechnique ...
            {mustBeScalarOrEmpty(gradientCorrection)}

        % Enter the inversion time (TI), defined as the interval between the inversion pulse and the excitation pulse, expressed in milliseconds. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
        inversionTime (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeScalarOrEmpty(inversionTime)}

        % Enter a lookup label for this device usage that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Enter the matrix size as the number of samples in the frequency and phase encoding directions for two-dimensional acquisitions (frequency × phase), or in the frequency, phase, and partition encoding directions for three-dimensional acquisitions (frequency × phase × partitions). This information is defined by the acquisition protocol and can be retrieved from the DICOM header.
        matrixSize (1,:) int64 ...
            {mustBeMinLength(matrixSize, 2), mustBeMaxLength(matrixSize, 3)}

        % Add all files or file bundles containing additional information about the usage of this device.
        metadataLocation (1,:) openminds.internal.mixedtype.mriscannerusage.MetadataLocation ...
            {mustBeMinLength(metadataLocation, 1), mustBeListOfUniqueItems(metadataLocation)}

        % Enter the number of initial volumes automatically discarded by the scanner before saving data, typically to allow signal stabilization at the beginning of the acquisition. This value is defined by the acquisition protocol and can be retrieved from the DICOM header.
        numberOfDiscardedVolumes (1,:) int64 ...
            {mustBeScalarOrEmpty(numberOfDiscardedVolumes)}

        % Enter the number of excitations (NEX), defined as the number of times each k-space line is acquired and averaged to improve signal-to-noise ratio; if no averaging was performed, set this value to 1. This value is specified in the acquisition protocol and can be retrieved from the DICOM header.
        numberOfExcitations (1,:) int64 ...
            {mustBeScalarOrEmpty(numberOfExcitations)}

        % Enter the number of slices corresponding to the total number of two-dimensional image slices acquired in this scan. This value is defined by the acquisition protocol and can be retrieved from the DICOM header.
        numberOfSlices (1,:) int64 ...
            {mustBeScalarOrEmpty(numberOfSlices)}

        % Add the parallel acquisition technique used for this scan (for example, SENSE or GRAPPA). This information is specified in the sequence protocol and can be retrieved from the DICOM header.
        parallelAcquisitionTechnique (1,:) openminds.controlledterms.MRIParallelAcquisitionTechnique ...
            {mustBeScalarOrEmpty(parallelAcquisitionTechnique)}

        % Enter the phase encoding direction as a signed unit vector in the scanner or image coordinate system (for example, [±1, 0, 0], [0, ±1, 0], or [0, 0, ±1]), where the nonzero component indicates the encoding axis and the sign specifies the polarity of k-space traversal.
        phaseEncodingDirection (1,:) int64 ...
            {mustBeMinLength(phaseEncodingDirection, 3), mustBeMaxLength(phaseEncodingDirection, 3)}

        % Enter the receiver bandwidth, defined as the range of frequencies sampled per pixel during signal acquisition, expressed in hertz per pixel. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
        receiverBandwidth (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeScalarOrEmpty(receiverBandwidth)}

        % Enter the repetition time (TR), defined as the interval between successive excitation pulses, expressed in milliseconds. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
        repetitionTime (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeScalarOrEmpty(repetitionTime)}

        % Enter the slice plane orientation as a three-element unit normal vector [nx, ny, nz] in scanner coordinates, where each component is a dimensionless floating-point value between -1 and +1 and the vector has unit length (nx² + ny² + nz² = 1). For non-oblique acquisitions, the vector aligns with a principal axis (for example, [0, 0, 1]), and for oblique acquisitions, the components are fractional.
        sliceAngulation (1,:) double ...
            {mustBeMinLength(sliceAngulation, 3), mustBeMaxLength(sliceAngulation, 3)}

        % Enter the slice gap, defined as the distance between adjacent slices, expressed in millimeters and excluding the slice thickness; if slice spacing is uniform, provide a single value, and if it varies across the volume, provide the corresponding range. This information is specified in the acquisition protocol and can be retrieved from the DICOM header.
        sliceGap (1,:) openminds.internal.mixedtype.mriscannerusage.SliceGap ...
            {mustBeScalarOrEmpty(sliceGap)}

        % Add the primary slice plane, defined relative to the scanner coordinate system, where axial corresponds to planes perpendicular to the scanner z-axis, sagittal to planes perpendicular to the x-axis, and coronal to planes perpendicular to the y-axis. This classification is independent of subject orientation and may therefore differ from anatomical planes when the subject is positioned non-standardly in the scanner.
        sliceOrientation (1,:) openminds.controlledterms.AnatomicalPlane ...
            {mustBeScalarOrEmpty(sliceOrientation)}

        % Enter the slice thickness, defined as the physical thickness of each acquired slice, expressed in millimeters; if uniform, provide a single value, and if variable, provide the corresponding range. This value is specified in the acquisition protocol and can be retrieved from the DICOM header.
        sliceThickness (1,:) openminds.internal.mixedtype.mriscannerusage.SliceThickness ...
            {mustBeScalarOrEmpty(sliceThickness)}

        % Enter the slice timing, defined as the acquisition time of each slice within a volume relative to the start of the volume acquisition. This information is determined by the sequence timing and can be retrieved from the DICOM header.
        sliceTiming (1,:) openminds.core.miscellaneous.QuantitativeValueArray ...
            {mustBeScalarOrEmpty(sliceTiming)}

        % Add the spatial encoding scheme used to acquire the data, specifying how frequency, phase, and partition encoding were applied (for example, frequency–phase encoding for two-dimensional acquisitions or frequency–phase–phase encoding for three-dimensional acquisitions). This information is defined in the sequence protocol and can be retrieved from the DICOM header.
        spatialEncoding (1,:) openminds.controlledterms.SpatialEncoding ...
            {mustBeScalarOrEmpty(spatialEncoding)}

        % Add the spoiling technique used in this acquisition, specifying the method applied to eliminate residual transverse magnetization (for example, radiofrequency spoiling or gradient spoiling). This information is defined in the sequence protocol and can be retrieved from the DICOM header.
        spoilingTechnique (1,:) openminds.controlledterms.MRISpoilingTechnique ...
            {mustBeScalarOrEmpty(spoilingTechnique)}

        % Enter the total readout time (TRT), defined as the time interval between acquisition of the first and last k-space lines in the phase-encoding direction during a single readout, expressed in milliseconds. This value is typically computed automatically and can be retrieved from the DICOM header.
        totalReadOutTime (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeScalarOrEmpty(totalReadOutTime)}

        % Enter the transmitter bandwidth, defined as the frequency range excited by the radiofrequency pulse per pixel, expressed in hertz per pixel. This value is specified in the sequence protocol and can be retrieved from the DICOM header.
        transmitterBandwidth (1,:) openminds.core.miscellaneous.QuantitativeValue ...
            {mustBeScalarOrEmpty(transmitterBandwidth)}

        % Add all coils used for this acquisition, including built-in and external transmit, receive, and gradient-related coils, corresponding to the relevant DICOM coil attributes. Preferably provide structured coil descriptions; if unavailable, specify at least the device type.
        usedCoils (1,:) openminds.internal.mixedtype.mriscannerusage.UsedCoils ...
            {mustBeMinLength(usedCoils, 2)}

        % Add the state of the tissue sample or subject that this device was used on.
        usedSpecimen (1,:) openminds.internal.mixedtype.mriscannerusage.UsedSpecimen ...
            {mustBeScalarOrEmpty(usedSpecimen)}

        % Enter the voxel size as the physical dimensions of a single image voxel in the x, y, and z directions, expressed in millimeters. This value is typically derived from the field of view, matrix size, and slice thickness and can be retrieved from the DICOM header.
        voxelSize (1,:) openminds.core.miscellaneous.QuantitativeValueArray ...
            {mustBeScalarOrEmpty(voxelSize)}
    end

    properties (Access = protected)
        Required = ["echoTime", "repetitionTime", "sliceTiming"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/MRIScannerUsage"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'MRIWeighting', "openminds.controlledterms.MRIWeighting", ...
            'MTPulseShape', "openminds.controlledterms.PulseShape", ...
            'diffusionEncodingParameters', "openminds.core.data.File", ...
            'fatSuppressionTechnique', "openminds.controlledterms.MRIFatSuppressionTechnique", ...
            'fieldOfView', [], ...
            'gradientCorrection', "openminds.controlledterms.AnalysisTechnique", ...
            'metadataLocation', ["openminds.core.data.File", "openminds.core.data.FileBundle"], ...
            'parallelAcquisitionTechnique', "openminds.controlledterms.MRIParallelAcquisitionTechnique", ...
            'sliceOrientation', "openminds.controlledterms.AnatomicalPlane", ...
            'spatialEncoding', "openminds.controlledterms.SpatialEncoding", ...
            'spoilingTechnique', "openminds.controlledterms.MRISpoilingTechnique", ...
            'usedCoils', ["openminds.controlledterms.DeviceType", "openminds.neuroimaging.device.MRICoilUsage"], ...
            'usedSpecimen', ["openminds.core.research.SubjectState", "openminds.core.research.TissueSampleState"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'dwellTime', "openminds.core.miscellaneous.QuantitativeValue", ...
            'echoTime', "openminds.core.miscellaneous.QuantitativeValue", ...
            'flipAngle', "openminds.core.miscellaneous.QuantitativeValue", ...
            'inversionTime', "openminds.core.miscellaneous.QuantitativeValue", ...
            'receiverBandwidth', "openminds.core.miscellaneous.QuantitativeValue", ...
            'repetitionTime', "openminds.core.miscellaneous.QuantitativeValue", ...
            'sliceGap', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"], ...
            'sliceThickness', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"], ...
            'sliceTiming', "openminds.core.miscellaneous.QuantitativeValueArray", ...
            'totalReadOutTime', "openminds.core.miscellaneous.QuantitativeValue", ...
            'transmitterBandwidth', "openminds.core.miscellaneous.QuantitativeValue", ...
            'voxelSize', "openminds.core.miscellaneous.QuantitativeValueArray" ...
        )
    end

    methods
        function obj = MRIScannerUsage(structInstance, propValues)
            arguments
                structInstance (1,:) {mustBeA(structInstance, 'struct')} = struct.empty
                propValues.?openminds.neuroimaging.device.MRIScannerUsage
                propValues.id (1,1) string
            end
            propValues = namedargs2cell(propValues);
            obj@openminds.abstract.Schema(structInstance, propValues{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end
end
