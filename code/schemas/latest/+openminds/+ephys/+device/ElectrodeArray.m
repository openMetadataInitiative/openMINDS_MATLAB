classdef ElectrodeArray < openminds.abstract.Schema
%ElectrodeArray - Structured information on an electrode array.
%
%   PROPERTIES:
%
%   conductorMaterial   : (1,1) <a href="matlab:help openminds.chemicals.ChemicalMixture" style="font-weight:bold">ChemicalMixture</a>, <a href="matlab:help openminds.chemicals.ChemicalSubstance" style="font-weight:bold">ChemicalSubstance</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>
%                         Add the conductor material of this electrode array.
%
%   description         : (1,1) string
%                         Enter a short text describing this device.
%
%   deviceType          : (1,1) <a href="matlab:help openminds.controlledterms.DeviceType" style="font-weight:bold">DeviceType</a>
%                         Add the type of this device.
%
%   digitalIdentifier   : (1,1) <a href="matlab:help openminds.core.digitalidentifier.DOI" style="font-weight:bold">DOI</a>, <a href="matlab:help openminds.core.digitalidentifier.RRID" style="font-weight:bold">RRID</a>
%                         Add the globally unique and persistent digital identifier of this device.
%
%   electrodeIdentifier : (1,:) string
%                         Enter the identifiers for each electrode of this electrode array. Note that the number of identifiers should match the number of electrodes of the array as stated under 'numberOfElectrodes'.
%
%   insulatorMaterial   : (1,1) <a href="matlab:help openminds.chemicals.ChemicalMixture" style="font-weight:bold">ChemicalMixture</a>, <a href="matlab:help openminds.chemicals.ChemicalSubstance" style="font-weight:bold">ChemicalSubstance</a>, <a href="matlab:help openminds.controlledterms.MolecularEntity" style="font-weight:bold">MolecularEntity</a>
%                         Add the insulator material of this electrode array.
%
%   internalIdentifier  : (1,1) string
%                         Enter the identifier (or label) of this electrode array that is used within the corresponding data files to identify this electrode array.
%
%   intrinsicResistance : (1,1) <a href="matlab:help openminds.core.miscellaneous.QuantitativeValue" style="font-weight:bold">QuantitativeValue</a>, <a href="matlab:help openminds.core.miscellaneous.QuantitativeValueRange" style="font-weight:bold">QuantitativeValueRange</a>
%                         Enter the intrinsic resistance of this electrode array.
%
%   lookupLabel         : (1,1) string
%                         Enter a lookup label for this device that may help you to find this instance more easily.
%
%   manufacturer        : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                         Add the manufacturer (private or industrial) that constructed this device.
%
%   name                : (1,1) string
%                         Enter a descriptive name for this device, preferably including the model name as defined by the manufacturer.
%
%   numberOfElectrodes  : (1,1) int64
%                         Enter the number of electrodes that belong to this electrode array.
%
%   owner               : (1,:) <a href="matlab:help openminds.core.actors.Consortium" style="font-weight:bold">Consortium</a>, <a href="matlab:help openminds.core.actors.Organization" style="font-weight:bold">Organization</a>, <a href="matlab:help openminds.core.actors.Person" style="font-weight:bold">Person</a>
%                         Add all parties that legally own this device.
%
%   serialNumber        : (1,1) string
%                         Enter the serial number of this device.

%   This class was auto-generated by the openMINDS pipeline

    properties
        % Add the conductor material of this electrode array.
        conductorMaterial (1,:) openminds.internal.mixedtype.electrodearray.ConductorMaterial ...
            {mustBeSpecifiedLength(conductorMaterial, 0, 1)}

        % Enter a short text describing this device.
        description (1,1) string

        % Add the type of this device.
        deviceType (1,:) openminds.controlledterms.DeviceType ...
            {mustBeSpecifiedLength(deviceType, 0, 1)}

        % Add the globally unique and persistent digital identifier of this device.
        digitalIdentifier (1,:) openminds.internal.mixedtype.electrodearray.DigitalIdentifier ...
            {mustBeSpecifiedLength(digitalIdentifier, 0, 1)}

        % Enter the identifiers for each electrode of this electrode array. Note that the number of identifiers should match the number of electrodes of the array as stated under 'numberOfElectrodes'.
        electrodeIdentifier (1,:) string ...
            {mustBeListOfUniqueItems(electrodeIdentifier)}

        % Add the insulator material of this electrode array.
        insulatorMaterial (1,:) openminds.internal.mixedtype.electrodearray.InsulatorMaterial ...
            {mustBeSpecifiedLength(insulatorMaterial, 0, 1)}

        % Enter the identifier (or label) of this electrode array that is used within the corresponding data files to identify this electrode array.
        internalIdentifier (1,1) string

        % Enter the intrinsic resistance of this electrode array.
        intrinsicResistance (1,:) openminds.internal.mixedtype.electrodearray.IntrinsicResistance ...
            {mustBeSpecifiedLength(intrinsicResistance, 0, 1)}

        % Enter a lookup label for this device that may help you to find this instance more easily.
        lookupLabel (1,1) string

        % Add the manufacturer (private or industrial) that constructed this device.
        manufacturer (1,:) openminds.internal.mixedtype.electrodearray.Manufacturer ...
            {mustBeListOfUniqueItems(manufacturer)}

        % Enter a descriptive name for this device, preferably including the model name as defined by the manufacturer.
        name (1,1) string

        % Enter the number of electrodes that belong to this electrode array.
        numberOfElectrodes (1,:) int64 ...
            {mustBeSpecifiedLength(numberOfElectrodes, 0, 1), mustBeInteger(numberOfElectrodes), mustBeGreaterThanOrEqual(numberOfElectrodes, 2)}

        % Add all parties that legally own this device.
        owner (1,:) openminds.internal.mixedtype.electrodearray.Owner ...
            {mustBeListOfUniqueItems(owner)}

        % Enter the serial number of this device.
        serialNumber (1,1) string
    end

    properties (Access = protected)
        Required = ["deviceType", "electrodeIdentifier", "name", "numberOfElectrodes"]
    end

    properties (Constant, Hidden)
        X_TYPE = "https://openminds.om-i.org/types/ElectrodeArray"
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct(...
            'conductorMaterial', ["openminds.chemicals.ChemicalMixture", "openminds.chemicals.ChemicalSubstance", "openminds.controlledterms.MolecularEntity"], ...
            'deviceType', "openminds.controlledterms.DeviceType", ...
            'digitalIdentifier', ["openminds.core.digitalidentifier.DOI", "openminds.core.digitalidentifier.RRID"], ...
            'insulatorMaterial', ["openminds.chemicals.ChemicalMixture", "openminds.chemicals.ChemicalSubstance", "openminds.controlledterms.MolecularEntity"], ...
            'manufacturer', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"], ...
            'owner', ["openminds.core.actors.Consortium", "openminds.core.actors.Organization", "openminds.core.actors.Person"] ...
        )
        EMBEDDED_PROPERTIES = struct(...
            'intrinsicResistance', ["openminds.core.miscellaneous.QuantitativeValue", "openminds.core.miscellaneous.QuantitativeValueRange"] ...
        )
    end

    methods
        function obj = ElectrodeArray(varargin)
            obj@openminds.abstract.Schema(varargin{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(obj)
            str = obj.lookupLabel;
        end
    end
end