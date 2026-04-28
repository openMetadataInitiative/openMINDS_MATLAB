
## Before you start
```matlab
% Verify that openMINDS_MATLAB is installed
disp( openminds.toolboxversion )
```

```matlabTextOutput
Version 0.9.7
```

If you have installed **openMINDS\_MATLAB** and the above command does not work, most likely **openMINDS\_MATLAB** is not added to MATLAB's [search path](https://se.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html).


If you opened this file in MATLAB Online from the GitHub Demo link, the following steps should add **openMINDS\_MATLAB** to the search path:


1) Open the `code` folder from the `Files` panel on the left sidebar.


2) Open and run the `startup.m` file. Select "Add to Path" if prompted from a popup dialog.


See also: [Crew Member Collection Tutorial](./livescripts/crewMemberCollection.mlx)

## Configure MATLAB's search path to use the latest model versions

Note: The following is only relevant if you have cloned or downloaded openMINDS\_MATLAB from GitHub. If you installed the Matlab toolbox, you can skip this part.


The openMINDS\_MATLAB toolbox comes packaged with schema classes for all versions of the openMINDS models. Therefore is important to use the [`openminds.startup`](+openminds/startup.m) function to ensure that the search path only contains schema classes for a specific openMINDS version. Provide the version number as an input, i.e "latest", or "v2.0"

```matlab
openminds.startup("latest") % Add schema classes for the latest version to the search path
```

```matlabTextOutput
Initializing openMINDS_MATLAB...
Added classes for version "latest" of the openMINDS metadata model to the search path.
```
## Import schemas from the core model
```matlab
import openminds.core.*
```
## Create a Subject
```matlab
% Create a new demo subject
subject1 = Subject('species', 'musMusculus', 'biologicalSex', 'male', 'lookupLabel', 'demo_subject1');
```

```matlabTextOutput
Error using openminds.core.research.Subject (line 73)
Invalid value for 'biologicalSex' argument. Value must be openminds.controlledterms.BiologicalSex or be convertible to openminds.controlledterms.BiologicalSex.
```

```matlab
disp(subject1)
```
## Create a Subject State
```matlab
subjectState = openminds.core.SubjectState('lookupLabel', 'demo_state')
% Add subject state to subject
subject1.studiedState = subjectState;
disp(subject1)
% Update the value of the lookup label
subjectState.lookupLabel = "demo_subjectstate_pre_recording";

% Create a new subject state
subjectStatePost = openminds.core.SubjectState('lookupLabel', 'demo_subjectstate_post_recording')
% Append the new subject state to the subject's studiedState property
subject1.studiedState(end+1) = subjectStatePost;
disp(subject1)
```
