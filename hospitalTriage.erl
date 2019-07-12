-module(hospitalTriage).
-export([startTriageProcess/0,triage/0,startCentralProcess/0,centralProcess/1,startHealthProviderProcess/0,healthProvider/0,masterProcess/1,recoverSlaveProcess/1,enqueue/3]).

%  ******Simple Hospital Triage Process*********
%
% How to test:
% hospitalTriage:startCentralProcess().
% hospitalTriage:startHealthProviderProcess().
% T=hospitalTriage:startTriageProcess().
% T!{notUrgent,"Filipe"}.
% T!{urgent,"Joao"}.
% T!{urgent,"Pedro"}.
%
% Author: Filipe Mesquita

startCentralProcess()->
    register(slaveProcess,spawn(hospitalTriage,centralProcess,[[]])),                    % create and register slave process
    register(masterProcess,spawn(hospitalTriage,masterProcess,[[]])).                    % create a master process 

startTriageProcess()->
    spawn(hospitalTriage,triage,[]).

startHealthProviderProcess()->
    spawn(hospitalTriage,healthProvider,[]).

masterProcess(List)->
    process_flag(trap_exit, true),                                                                     
    link(whereis(slaveProcess)),                                                                                                   
        receive
            {'EXIT',_,_} -> io:format("Recover Slave Process~n"),recoverSlaveProcess(List),masterProcess(List);
            {sendToBackup,ListSlave} -> masterProcess(ListSlave)
        end.

recoverSlaveProcess(List)->
    register(slaveProcess,spawn(hospitalTriage,centralProcess,[List])).                

triage()->
    receive
        {notUrgent,Name} -> whereis(slaveProcess)!{enqueue,1,Name},io:format("Not Urgent~n"),triage();
        {lessUrgent,Name} -> whereis(slaveProcess)!{enqueue,2,Name},io:format("Less Urgent~n"),triage();
        {urgent,Name} -> whereis(slaveProcess)!{enqueue,3,Name},io:format("Urgent~n"),triage() 
    end.

centralProcess(List)->
    receive
        {dequeue,Pid} -> 
            case List == [] of
                false ->[{Priority,PatientName}|T]=List, Pid!{processing,PatientName,Priority},whereis(masterProcess)!{sendToBackup,T},centralProcess(T);
                true -> Pid!{empty},centralProcess(List)
            end;
        {enqueue,Priority,PatientName} -> NewList=enqueue(List,{Priority,PatientName},[]), whereis(masterProcess)!{sendToBackup,NewList},centralProcess(NewList)
    end.

healthProvider()->
    whereis(slaveProcess)!{dequeue,self()},
    receive
        {processing,PatientName,Priority} -> io:format("Patient ~p with Priority ~p was attended ~n",[PatientName,Priority]),healthProvider();
        {empty}-> io:format("empty queue ~n"),timer:apply_after(20000, hospitalTriage, healthProvider, [])
    end.


enqueue([],{PriorityAux,PatientAux},List)->List++[{PriorityAux,PatientAux}];
enqueue([{Priority,Patient}|T],{PriorityAux,PatientAux},NewList) when PriorityAux>Priority ->NewList++[{PriorityAux,PatientAux}]++[{Priority,Patient}]++T;
enqueue([{Priority,Patient}|T],{PriorityAux,PatientAux},NewList) when PriorityAux<Priority -> enqueue(T,{PriorityAux,PatientAux},NewList++[{Priority,Patient}]);
enqueue([{Priority,Patient}|T],{PriorityAux,PatientAux},NewList) -> enqueue(T,{PriorityAux,PatientAux},NewList++[{Priority,Patient}]).
