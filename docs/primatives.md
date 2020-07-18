# Primatives

Hopscotch includes a variety of primatives upon which to build your own workflow engine and add functionality to hopscotch.

## Base Primatives
| Primative | Definition |
| -- | -- |
| Job | Individual job to be undertaken either standalone or part of a workflow | 
| Message | A message that is published by one system onto a given topic and received by another, contains all data necessary for anything receiving it to act upon it |
| Workflow | Represents a collection of interconnected jobs that combine to represent a single logical task i.e. `ReloadUser` |