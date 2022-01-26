pragma solidity 0.5.4;

contract TaskManager {

    uint public nTasks;
    
    //enum TaskPhase {ToDo = 0, InProgress = 1, Done = 2, ...}
    enum TaskPhase {ToDo, InProgress, Done, Blocked, Review, Postponed, Canceled}
    
    struct TaskStruct {
        address owner;
        string name;
        TaskPhase phase;
        // Priority 1-5: 1 higher, 5 less important
        uint priority;
    }
    TaskStruct[] private tasks;
    //TaskStruct[] public tasks;
    
    //maping é uma estrutura de 'chave e valor)
    mapping (address => uint[]) private myTasks;
    //mapping (address => uint[]) public myTasks;

    //Event é a forma como solidity avisa as coisas para o mundo exterior
    event TaskAdded(address owner, string name, TaskPhase phase, uint priority);
    
    //modifier serve para acoplar em funções e garantir alguns pré requisitos
    modifier onlyOwner (uint _taskIndex) {
         if  (tasks[_taskIndex].owner == msg.sender) {
           _;
        }
    }
    
    //Constructor é executado apenas no deploy do smart contract 
    constructor() public {
        nTasks = 0;
        addTask ("Create Task Manager", TaskPhase.Done, 1);
        addTask ("Create Your first task", TaskPhase.ToDo, 1);
        addTask ("Clean your house", TaskPhase.ToDo, 5);
    }

    //function serve para interagir com tudo que tem no smart contract 
    function getTask(uint _taskIndex) public view
        returns (address owner, string memory name, TaskPhase phase, uint priority) {
        
        owner = tasks[_taskIndex].owner;
        name = tasks[_taskIndex].name;
        phase = tasks[_taskIndex].phase;
        priority = tasks[_taskIndex].priority;
    }
    
    function listMyTasks() public view returns (uint[] memory) {
        return myTasks[msg.sender];
    }
    
    function addTask(string memory _name, TaskPhase _phase, uint _priority) public returns (uint index) {
        //retorna os parametros da função, require serve para tratamento de erros
        require ((_priority >= 1 && _priority <=5), "priority must be between 1 and 5");
        TaskStruct memory taskAux = TaskStruct ({
            owner: msg.sender,
            name: _name,
            phase: _phase, 
            priority: _priority
        });
        index = tasks.push (taskAux) - 1;
        nTasks ++;
        myTasks[msg.sender].push(index);
        //evisa quem está enviando
        emit TaskAdded (msg.sender, _name, _phase, _priority);
    }
    
    function updatePhase(uint _taskIndex, TaskPhase _phase) public onlyOwner(_taskIndex) {
        tasks[_taskIndex].phase = _phase;
    }
    
}