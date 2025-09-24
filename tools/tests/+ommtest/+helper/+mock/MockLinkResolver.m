classdef MockLinkResolver < openminds.internal.resolver.AbstractLinkResolver
%MockLinkResolver Mock implementation of AbstractLinkResolver for testing
%
%   This class provides a mock implementation for testing resolver
%   functionality with fake data. It can resolve instances with IRIs
%   starting with "https://mock.io/" and populate them with test data.

    properties (Constant)
        IRIPrefix = "https://mock.io/"
    end
    
    methods (Static)
        function instance = resolve(instance, options)
            arguments
                instance
                options.NumLinksToResolve = 0 %#ok<INUSA>
            end
            
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
        
        function tf = canResolve(IRI)
            arguments
                IRI (1,:) string
            end
            % This mock resolver can handle IRIs that start with mock.io
            tf = startsWith(IRI, ommtest.helper.mock.MockLinkResolver.IRIPrefix);
        end
    end
end
