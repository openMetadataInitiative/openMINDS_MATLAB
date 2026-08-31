classdef MockLinkResolver < openminds.interface.LinkResolver
%MockLinkResolver Mock implementation of openminds.interface.LinkResolver for testing
%
%   This class provides a mock implementation for testing resolver
%   functionality with fake data. It can resolve instances with IRIs
%   starting with "https://mock.io/" and populate them with test data.

    properties (Constant)
        IRIPrefix = "https://mock.io/"
    end
    
    methods
        function instance = resolveNode(~, instance)
            % Mock implementation - populate instance with fake data
            if isa(instance, 'openminds.core.Person')
                % Populate a Person with mock data
                instance.givenName = "Mock";
                instance.familyName = "Person";
                
            elseif isa(instance, 'openminds.core.Organization')
                % Populate an Organization with mock data  
                instance.fullName = "Mock Organization";
                
            elseif isa(instance, 'openminds.core.Dataset')
                % Populate a Dataset with mock data
                instance.fullName = "Mock Dataset";
                instance.shortName = "MockDS";
                
            end
            
            % For any other type, just leave as-is (could add more types as needed)
        end
        
        function tf = canResolve(~, IRI)
            arguments
                ~
                IRI (1,1) string
            end
            % This mock resolver can handle IRIs that start with mock.io
            tf = startsWith(IRI, ommtest.helper.mock.MockLinkResolver.IRIPrefix);
        end
    end
end
