classdef (Abstract) ControlledTerm < openminds.abstract.Schema
%ControlledTerm Abstract base class for schemas of the controlled terms model

    properties (Access = protected)
        Required = {'name'}
    end
    
    properties
        % Enter one sentence for defining this term.
        definition (1,1) string

        % Enter a short text describing this term.
        description (1,1) string

        % Enter the internationalized resource identifier (IRI) pointing to the integrated ontology entry in the InterLex project.
        interlexIdentifier (1,1) string

        % Enter the internationalized resource identifier (IRI) pointing to the wiki page of the corresponding term in the KnowledgeSpace.
        knowledgeSpaceLink (1,1) string

        % Controlled term originating from a defined terminology.
        name (1,1) string

        % Enter the internationalized resource identifier (IRI) pointing to the preferred ontological term.
        preferredOntologyIdentifier (1,1) string

        % Enter one or several synonyms (inlcuding abbreviations) for this controlled term.
        synonym (1,:) string {mustBeListOfUniqueItems(synonym)}
    end

    properties (SetAccess = protected, Hidden) % Todo: Same as id, combine
        at_id
    end
       
    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct()
        EMBEDDED_PROPERTIES = struct()
    end

    properties (Abstract, Constant, Hidden)
        CONTROLLED_INSTANCES
    end

    methods
        function obj = ControlledTerm(varargin)
            
            if isempty(varargin)
                return
            end

            if numel(varargin) == 1 && ischar(varargin{1})
                varargin{1} = string(varargin{1});
            end

            if nargin < 1
                % Make a "null" instance 
            elseif nargin == 1 && isstring( varargin{1} ) && isfile( varargin{1} )
                obj.load( varargin{1} )
            elseif nargin == 1 && isstring( varargin{1} ) && ~isfile( varargin{1} )
                % Deserialize from name of controlled instance
                if ~ismissing(varargin{1})
                    obj.deserializeFromName(varargin{1});
                end
            elseif nargin == 1 && isstruct( varargin{1} ) && isfield(varargin{1}, 'at_id')
                obj.deserializeFromName(varargin{1}.at_id);
            else
                obj.assignPVPairs(varargin{:})
                obj.id = obj.generateInstanceId();
            end
        end
    end
    
    methods (Access = protected) % Implement method for the CustomInstanceDisplay mixin

        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.name);
        end

        % function annotation = getAnnotation(obj)
        %     annotation = getAnnotation@openminds.abstract.Schema(obj);
        %     annotation = sprintf('%s <ControlledTerm>', annotation);
        % end
    end

    methods (Hidden)
        function str = char(obj)
            str = char(string(obj.name));
        end
    end

    methods (Access = private)
        function deserializeFromName(obj, instanceName)

            import openminds.internal.getControlledInstance
            import openminds.internal.utility.getSchemaName
            
            schemaName = getSchemaName(class(obj));

            if obj.isSemanticName(instanceName)
                 [~, instanceName] = openminds.utility.parseAtID(instanceName);
            end

            [instanceName, instanceNameOrig] = deal(instanceName);
            if ~any(strcmp(obj.CONTROLLED_INSTANCES, instanceName))
                % Try to make a valid name
                instanceName = strrep(instanceName, ' ', '');
                instanceName = matlab.lang.makeValidName(instanceName, 'ReplacementStyle', 'delete');
            end

            % Todo: Use a proper deserializer
            if any(strcmpi(obj.CONTROLLED_INSTANCES, instanceName))
                try
                    data = getControlledInstance(instanceName, schemaName, 'controlledTerms');
                catch
                    s = warning('off', 'backtrace');
                    warning('Controlled instance "%s" is not available.', instanceNameOrig)
                    warning(s);
                    return
                end
            else
                error('OpenMINDS:ControlledTerm:NoMatchingInstance', ...
                    'No matching instances were found for name "%s"', instanceName)
                %error('Deserialization from user instance is not implemented yet')
            end
            propNames = {'at_id', 'name', 'definition', 'description', 'interlexIdentifier', 'knowledgeSpaceLink', 'preferredOntologyIdentifier', 'synonym'};

            for i = 1:numel(propNames)
                if ~isempty( data.(propNames{i}) )
                    obj.(propNames{i}) = data.(propNames{i});
                end
            end

            obj.id = obj.at_id;
        end
    end

    methods (Static)
        function members = getMembers()
            className = mfilename('class');
            [~, members] = enumeration(className);
        end

        function obj = load(filePath)
            error('Not implemented')
        end

        function tf = isSemanticName(name)

            URI = matlab.net.URI(name);
            
            isValidUrl = sprintf("%s://%s", URI.Scheme, URI.Host) == ...
                openminds.internal.constants.url.OpenMindsBaseURL;

            URIPath = URI.Path;
            URIPath(URIPath=="")=[];
        
            isInstanceUrl = URIPath(1) == "instances";

            tf = isValidUrl && isInstanceUrl;
        end
    end

end
