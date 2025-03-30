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
            instances = openminds.internal.listControlledInstances(type);
            isMatch = instances.InstanceName==string(name);
            if any(isMatch)
                data = jsondecode(fileread(instances.Filepath(isMatch)));
            end
            instance = feval(type.ClassName, data);
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
