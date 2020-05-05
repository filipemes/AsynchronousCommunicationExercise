# Asynchronous Communication Exercise

In this exercise I implemented a Simple Hospital Triage Process using asynchronous messages. The aim of this exercise was simulate a hospital triage process, when a patient arrives to triage process, it gives a priority and forwards it to central process. The Central process enqueue it with the respective priority, the queue is always sorted by priority. The health provider processes will attend patients through Central process.

## How to test

````
hospitalTriage:startCentralProcess().
hospitalTriage:startHealthProviderProcess().
hospitalTriage:startHealthProviderProcess().
hospitalTriage:startHealthProviderProcess().
T=hospitalTriage:startTriageProcess().
T!{notUrgent,"Filipe"}.
T!{urgent,"Joao"}.
T!{urgent,"Pedro"}.
````


## Author

* Filipe Mesquita - [filipemes](https://github.com/filipemes)
