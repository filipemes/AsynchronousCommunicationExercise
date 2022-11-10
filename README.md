# Asynchronous Communication Exercise

In this exercise, I implemented a Simple Hospital Triage Process using asynchronous messages. The aim of this exercise was to simulate a hospital triage process, when a patient arrives at the triage process, it gives a priority and forwards it to the central process. The Central process is responsible to enqueue patients with a priority, the queue is always sorted by priority. The health provider processes will attend patients through the central process.

## How to test it

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

**Development Date:** May 2019

## Author

* Filipe Mesquita - [filipemes](https://github.com/filipemes)
