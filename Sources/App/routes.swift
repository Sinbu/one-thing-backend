import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
// Routees needed:
// Post - New task
// Put - Update existing task
// Get - Specific Task
// Get - All tasks

public func routes(_ router: Router) throws {
    
    // MARK: - Version 1
    let v1 = router.grouped("v1")
    
    
    // MARK: - JSON
    let taskRouter = v1.grouped("task")
    
    // MARK: GET
    taskRouter.get(Task.parameter) { req -> Future<Task> in
        let task = try req.parameters.next(Task.self)
        
        return task
    }
    
    taskRouter.get() { req -> Future<[Task]> in
        let allTasks = Task.query(on: req).all()
        
        return allTasks
    }
    
    // MARK: POST
    taskRouter.post(Task.self, at:"create") { req, task  -> Task in
        task.save(on: req)
        return task
    }
    
    // MARK: PUT
    taskRouter.put(UUID.parameter) { req -> Future<Task> in
        let id = try req.parameters.next(UUID.self)
        
        let updatedTask = try req.content.syncDecode(Task.self)
        
        return Task.find(id, on: req).flatMap(to: Task.self) { task in
            guard var task = task else {
                throw Abort(.notFound)
            }
            task = updatedTask
            task.id = id
            
            return task.update(on: req)
        }
    }
    
    // MARK: - Views
    let taskRouterView = taskRouter.grouped("view")
    
    taskRouterView.get(Task.parameter) { req -> Future<View> in
        let task = try req.parameters.next(Task.self)
        
        let context = [String:String]()
        return try req.view().render("task", context)
    }
    
    taskRouterView.get() { req -> Future<View> in
        
        
        let allTasks = Task.query(on: req).all()
        
        let context = [String:String]()
        return try req.view().render("taskList", context)
    }
}
