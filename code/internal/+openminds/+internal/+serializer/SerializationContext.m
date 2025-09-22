classdef SerializationContext < handle
%SerializationContext Manages state during serialization of openMINDS instances
%
%   This class tracks the serialization state to handle recursion depth
%   for linked types and prevent infinite loops from circular references.
%
%   USAGE:
%   ------
%   context = openminds.internal.serializer.SerializationContext(config)
%   context = openminds.internal.serializer.SerializationContext(config, 'MaxRecursionDepth', 3)
%
%   PROPERTIES:
%   -----------
%   Config              - SerializationConfig object
%   CurrentDepth        - Current recursion depth for linked types
%   MaxRecursionDepth   - Maximum allowed recursion depth
%   VisitedInstances    - Set of instance IDs already being processed

    properties (SetAccess = private)
        Config % SerializationConfig object
        CurrentDepth (1,1) {mustBeInteger, mustBeNonnegative} = 0
        MaxRecursionDepth (1,1) {mustBeInteger, mustBeNonnegative} = 0
    end

    properties (SetAccess = {?openminds.internal.serializer.SerializationContext, ?openminds.internal.serializer.BaseSerializer})
        VisitedInstances containers.Map
        LinkedInstances containers.Map
    end
    
    methods
        function obj = SerializationContext(config, options)
        %SerializationContext Constructor for serialization context
        %
        %   context = openminds.internal.serializer.SerializationContext(config) creates a context
        %   with the provided configuration
        %
        %   context = openminds.internal.serializer.SerializationContext(config, Name, Value, ...)
        %   creates a context with additional options
        %
        %   PARAMETERS:
        %   -----------
        %   config : SerializationConfig
        %       Configuration object for serialization
        %
        %   MaxRecursionDepth : integer (optional)
        %       Override the recursion depth from config
            
            arguments
                config % SerializationConfig object
                options.CurrentDepth {mustBeInteger, mustBeNonnegative} = 0
                options.MaxRecursionDepth {mustBeInteger, mustBeNonnegative} = []
            end
            
            obj.Config = config;
            
            if ~isempty(options.MaxRecursionDepth)
                obj.MaxRecursionDepth = options.MaxRecursionDepth;
            else
                obj.MaxRecursionDepth = config.RecursionDepth;
            end
            if ~isempty(options.CurrentDepth)
                obj.CurrentDepth = options.CurrentDepth;
            end
            
            obj.VisitedInstances = containers.Map();
            obj.LinkedInstances = containers.Map();
        end
        
        function tf = canRecurse(obj)
        %canRecurse Check if recursion is allowed at current depth
        %
        %   tf = context.canRecurse() returns true if the current
        %   recursion depth is less than the maximum allowed depth
            
            tf = obj.CurrentDepth < obj.MaxRecursionDepth;
        end
        
        function tf = isVisited(obj, instanceId)
        %isVisited Check if an instance is currently being processed
        %
        %   tf = context.isVisited(instanceId) returns true if the
        %   instance with the given ID is already in the processing stack
        %
        %   This helps prevent infinite loops from circular references.
            
            arguments
                obj (1,1) openminds.internal.serializer.SerializationContext
                instanceId (1,1) string
            end
            
            tf = obj.VisitedInstances.isKey(char(instanceId));
        end
        
        function markVisited(obj, instanceId)
        %markVisited Mark an instance as currently being processed
        %
        %   context.markVisited(instanceId) adds the instance ID to
        %   the set of currently visited instances
            
            arguments
                obj (1,1) openminds.internal.serializer.SerializationContext
                instanceId (1,1) string
            end
            
            obj.VisitedInstances(char(instanceId)) = true;
        end
        
        function unmarkVisited(obj, instanceId)
        %unmarkVisited Remove an instance from the visited set
        %
        %   context.unmarkVisited(instanceId) removes the instance ID
        %   from the set of currently visited instances
            
            arguments
                obj (1,1) openminds.internal.serializer.SerializationContext
                instanceId (1,1) string
            end
            
            if obj.VisitedInstances.isKey(char(instanceId))
                obj.VisitedInstances.remove(char(instanceId));
            end
        end
        
        function newContext = createChildContext(obj)
        %createChildContext Create a child context with incremented depth
        %
        %   childContext = context.createChildContext() creates a new
        %   context with the same configuration but incremented recursion
        %   depth and shared visited instances set
            
            newContext = openminds.internal.serializer.SerializationContext(obj.Config, ...
                'MaxRecursionDepth', obj.MaxRecursionDepth, ...
                'CurrentDepth', obj.CurrentDepth + 1);
            newContext.VisitedInstances = obj.VisitedInstances; % Share the same map
            newContext.LinkedInstances = obj.LinkedInstances; % Share the same map
        end
        
        function reset(obj)
        %reset Reset the context to initial state
        %
        %   context.reset() clears the visited instances and resets
        %   the current depth to 0
            
            obj.CurrentDepth = 0;
            obj.VisitedInstances = containers.Map();
            obj.LinkedInstances  = containers.Map();
        end
    end
    
    methods
        function depth = get.CurrentDepth(obj)
            depth = obj.CurrentDepth;
        end
    end
end
