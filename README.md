# Bash Tab-Completion Automation

This script provides an example how to build a tab completion
from a set of user-defined functions automatically.
Each function must a hierarchy to reach to the root function or
reach to the target sub-function.
The root function is a function that the tab completion begins
In this sample script, 'myapp' is the root function for all others.
All the sub-functions must start with `__` prefix string 
and concatenate their ancestor's names using `-` similarly to a path.


## Usage
In order to use the script, please grep and replace all `myapp` to your function name.
And then update the sub-functions and their function body.

```bash
neoul$ source tab-completion-auto.sh 
neoul$ myapp<ENTER>
A
neoul$ myapp <TAB>
help     secondB  secondC  secondD  
neoul$ myapp second<TAB>
secondB  secondC  secondD  
neoul$ myapp secondC third<TAB>
thirdX  thirdY  thirdZ  
neoul$ myapp secondC thirdY<ENTER>
A-C-Y

# Subfunction with PARAM1 and PARAM2
neoul$ myapp secondC thirdY PARAM1 PARAM2
A-C-Y PARAM1 PARAM2
neoul$ 

# help
neoul$ myapp help
myapp help                     
myapp                           help description A
myapp secondB                   help description A-B
myapp secondB thirdX           
myapp secondB thirdY           
myapp secondC                   help description A-C
myapp secondC thirdX           
myapp secondC thirdY           
myapp secondC thirdZ           
myapp secondD                  

```
