classdef HasControlledInstance < handle
    methods (Static)
        function instanceNames = listInstances(type)
        % listInstances - List controlled instances of given type
            instanceTable = openminds.internal.listControlledInstances(type);
            instanceNames = instanceTable.InstanceName;
        end

        function instance = fromName(name, type)
        % fromName - Create metadata object from name of controlled instance
            arguments
                name (1,1) string
                type (1,1) openminds.enum.Types
            end
            % Todo: consolidate with instance resolver
            instances = openminds.internal.listControlledInstances(type);
            isMatch = instances.InstanceName==string(name);
            if any(isMatch)
                data = jsondecode(fileread(instances.Filepath(isMatch)));
                instance = feval(type.ClassName, data);
            else
                error(['Could not find data for instance of type "%s" ', ...
                    'with name "%s"'], string(type), name)
            end
        end
    end
end

% Include in subclasses
    % methods (Static)
    %     function instance = fromName(name)
    %         typeName = mfilename('classname');
    %         instance = openminds.internal.mixin.HasControlledInstance.fromName(name, typeName);
    %     end
    %     function instanceNames = listInstances()
    %         typeName = mfilename('classname');
    %         instanceNames = openminds.internal.mixin.HasControlledInstance.listInstances(typeName);
    %     end
    % end
